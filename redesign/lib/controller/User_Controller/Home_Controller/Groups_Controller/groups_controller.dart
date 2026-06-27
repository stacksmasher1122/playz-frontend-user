import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import 'package:redesign/model/User_Models/Home_Models/Groups_Model/groups_model.dart';
import 'package:redesign/model/User_Models/Home_Models/Groups_Model/group_request_model.dart';
import 'package:redesign/sqflite/User_SQF/Home_SQF/Groups_SQF/groupsSqflite.dart';
import 'package:redesign/shared_preferences/userPreferences.dart';
import 'dart:async';

class GroupsController extends GetxController {
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;
  final _picker = ImagePicker();
  final _uuid = const Uuid();

  // ── Reactive state ──
  final myGroups = <GroupModel>[].obs;
  final pendingGroupRequests = <GroupRequestModel>[].obs;
  final isLoading = false.obs;
  final isCreating = false.obs;

  // ── Image picking state ──
  final Rxn<File> pickedImage = Rxn<File>();

  String _myEmail = '';
  String _myName = '';
  String _myPic = '';

  String get myEmail => _myEmail;

  StreamSubscription? _requestsSub;

  @override
  void onInit() {
    super.onInit();
    _init();
  }

  Future<void> _init() async {
    _myEmail = await UserPreferences.getDocId() ?? '';
    _myName = await UserPreferences.getUserName() ?? '';
    _myPic = await UserPreferences.getProfileImageUrl() ?? '';
    if (_myEmail.isEmpty) return;

    // 1) Load from SQFlite for instant display
    await _loadFromSqflite();

    // 2) Fetch live data from Firestore
    await fetchMyGroups();
  }

  // ═══════════════════════════════════
  //  LOCAL → SQFLITE
  // ═══════════════════════════════════

  Future<void> _loadFromSqflite() async {
    try {
      final localGroups = await GroupsSqflite.getAllGroups();
      myGroups.assignAll(localGroups);
    } catch (e) {
      debugPrint('🔴 [GroupsController] SQFlite load error: $e');
    }
  }

  // ═══════════════════════════════════
  //  LIVE → FIRESTORE
  // ═══════════════════════════════════

  Future<void> fetchMyGroups() async {
    if (_myEmail.isEmpty) return;
    isLoading.value = true;
    try {
      final userDoc = await _firestore.collection('User').doc(_myEmail).get();
      if (!userDoc.exists) return;

      final data = userDoc.data()!;
      final groupsMap = Map<String, dynamic>.from(data['groups'] ?? {});

      if (groupsMap.isEmpty) {
        myGroups.clear();
        await GroupsSqflite.clearAll();
        return;
      }

      // Fetch full group details for each group ID
      final List<GroupModel> liveGroups = [];
      for (final groupId in groupsMap.keys) {
        try {
          final groupDoc =
              await _firestore.collection('Groups').doc(groupId).get();
          if (groupDoc.exists) {
            liveGroups.add(GroupModel.fromMap(groupDoc.data()!, groupDoc.id));
          }
        } catch (e) {
          debugPrint('🔴 [GroupsController] Fetch group $groupId error: $e');
        }
      }

      myGroups.assignAll(liveGroups);
      await GroupsSqflite.clearAndInsertGroups(liveGroups);
    } catch (e) {
      debugPrint('🔴 [GroupsController] Firestore fetch error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // ═══════════════════════════════════
  //  PICK GROUP IMAGE
  // ═══════════════════════════════════

  Future<void> pickGroupImage() async {
    try {
      final XFile? file = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (file != null) {
        pickedImage.value = File(file.path);
      }
    } catch (e) {
      debugPrint('🔴 [GroupsController] Image pick error: $e');
    }
  }

  // ═══════════════════════════════════
  //  CREATE GROUP
  // ═══════════════════════════════════

  Future<bool> createGroup({
    required String name,
    required String description,
    required String sport,
    required bool isPublic,
    required int maxMembers,
  }) async {
    if (name.trim().isEmpty) {
      Get.snackbar('Error', 'Group name is required.',
          backgroundColor: Colors.redAccent, colorText: Colors.white);
      return false;
    }

    isCreating.value = true;

    try {
      // 1) Generate a unique group ID
      final groupId = _uuid.v4().substring(0, 12);
      final now = DateTime.now();

      // 2) Upload image if picked
      String imageUrl = '';
      if (pickedImage.value != null) {
        imageUrl = await _uploadGroupImage(groupId, pickedImage.value!);
      }

      // 3) Build members map with creator as first member
      final Map<String, dynamic> members = {
        _myEmail: {
          'name': _myName,
          'imageUrl': _myPic,
          'joinedAt': Timestamp.fromDate(now),
          'role': 'admin',
          'lastSeenAt': Timestamp.fromDate(now),
        },
      };

      // 4) Build GroupModel
      final group = GroupModel(
        groupId: groupId,
        name: name.trim(),
        description: description.trim(),
        sport: sport,
        isPublic: isPublic,
        maxMembers: maxMembers,
        imageUrl: imageUrl,
        creator: _myEmail,
        members: members,
        createdAt: now,
      );

      // 5) Save to Firestore: Groups/{groupId}
      await _firestore.collection('Groups').doc(groupId).set(group.toMap());

      // 6) Initialize empty chats sub-collection with a placeholder doc
      await _firestore
          .collection('Groups')
          .doc(groupId)
          .collection('chats')
          .doc('_init')
          .set({
        'type': 'system',
        'content': 'Group created',
        'timestamp': Timestamp.fromDate(now),
      });

      // 7) Update User/{docId} with group reference (nested map)
      await _firestore.collection('User').doc(_myEmail).set({
        'groups': {
          groupId: group.toUserGroupRef(),
        },
      }, SetOptions(merge: true));

      // 8) Save to local SQFlite
      await GroupsSqflite.insertGroup(group);

      // 9) Update reactive list
      myGroups.insert(0, group);
      myGroups.refresh();

      // 10) Clear picked image
      pickedImage.value = null;

      // Ensure full sync with Firestore in the background
      fetchMyGroups();

      Get.snackbar('Success', 'Group "$name" created!',
          backgroundColor: const Color(0xFF1DB954),
          colorText: Colors.black);

      return true;
    } catch (e) {
      debugPrint('🔴 [GroupsController] Create group error: $e');
      Get.snackbar('Error', 'Failed to create group. Please try again.',
          backgroundColor: Colors.redAccent, colorText: Colors.white);
      return false;
    } finally {
      isCreating.value = false;
    }
  }

  // ═══════════════════════════════════
  //  UPLOAD GROUP IMAGE
  // ═══════════════════════════════════

  Future<String> _uploadGroupImage(String groupId, File imageFile) async {
    final ref = _storage.ref().child('Groups/$groupId/media/profile.jpg');
    final uploadTask = ref.putFile(
      imageFile,
      SettableMetadata(contentType: 'image/jpeg'),
    );
    final snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }

  // ═══════════════════════════════════
  //  JOIN REQUESTS
  // ═══════════════════════════════════

  void listenToGroupRequests(String groupId) {
    _requestsSub?.cancel();
    _requestsSub = _firestore
        .collection('Groups')
        .doc(groupId)
        .collection('requests')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen((snapshot) {
      pendingGroupRequests.assignAll(
        snapshot.docs.map((doc) => GroupRequestModel.fromMap(doc.data())).toList(),
      );
    });
  }

  Future<void> approveGroupRequest(GroupRequestModel req) async {
    try {
      final now = DateTime.now();
      
      // 1) Update Group members map
      await _firestore.collection('Groups').doc(req.groupId).update({
        FieldPath(['members', req.senderEmail]): {
          'name': req.senderName,
          'imageUrl': req.senderPic,
          'joinedAt': Timestamp.fromDate(now),
          'role': 'member',
          'lastSeenAt': Timestamp.fromDate(now),
        },
      });

      // 2) Update User's groups map
      final groupDoc = await _firestore.collection('Groups').doc(req.groupId).get();
      if (groupDoc.exists) {
        final groupData = groupDoc.data()!;
        final groupRef = {
          'groupId': req.groupId,
          'name': groupData['name'],
          'description': groupData['description'],
          'imageUrl': groupData['imageUrl'],
        };

        await _firestore.collection('User').doc(req.senderEmail).set({
          'groups': {
            req.groupId: groupRef,
          },
        }, SetOptions(merge: true));
      }

      // 3) Delete the request
      await _firestore
          .collection('Groups')
          .doc(req.groupId)
          .collection('requests')
          .doc(req.senderEmail)
          .delete();
          
      Get.snackbar('Success', 'User approved to join.');
    } catch (e) {
      debugPrint('🔴 [GroupsController] Approval error: $e');
      Get.snackbar('Error', 'Failed to approve user.');
    }
  }

  Future<void> declineGroupRequest(GroupRequestModel req) async {
    try {
      await _firestore
          .collection('Groups')
          .doc(req.groupId)
          .collection('requests')
          .doc(req.senderEmail)
          .delete();
      Get.snackbar('Success', 'Request declined.');
    } catch (e) {
      debugPrint('🔴 [GroupsController] Decline error: $e');
    }
  }

  bool isGroupAdmin(String groupId) {
    final group = myGroups.firstWhereOrNull((g) => g.groupId == groupId);
    if (group == null) return false;
    final myMemberData = group.members[_myEmail];
    return myMemberData != null && myMemberData['role'] == 'admin';
  }

  // ═══════════════════════════════════
  //  SEARCH GROUPS
  // ═══════════════════════════════════

  final searchResults = <GroupModel>[].obs;
  final searchQuery = ''.obs;
  final isSearching = false.obs;

  Future<void> searchGroups(String query) async {
    searchQuery.value = query;
    if (query.trim().isEmpty) {
      searchResults.clear();
      return;
    }

    isSearching.value = true;
    try {
      // Firestore doesn't support full-text search natively,
      // so we fetch groups whose name starts with the query (case-sensitive prefix).
      // For broader matching we fetch all groups and filter client-side.
      final snapshot = await _firestore.collection('Groups').get();
      final lowerQuery = query.toLowerCase();

      final results = snapshot.docs
          .map((doc) => GroupModel.fromMap(doc.data(), doc.id))
          .where((g) =>
              g.name.toLowerCase().contains(lowerQuery) &&
              !myGroups.any((mine) => mine.groupId == g.groupId))
          .toList();

      searchResults.assignAll(results);
    } catch (e) {
      debugPrint('🔴 [GroupsController] Search error: $e');
    } finally {
      isSearching.value = false;
    }
  }

  // ═══════════════════════════════════
  //  JOIN PUBLIC GROUP (INSTANT)
  // ═══════════════════════════════════

  Future<void> joinPublicGroup(GroupModel group) async {
    try {
      final now = DateTime.now();

      // 1) Add self to group members
      await _firestore.collection('Groups').doc(group.groupId).update({
        FieldPath(['members', _myEmail]): {
          'name': _myName,
          'imageUrl': _myPic,
          'joinedAt': Timestamp.fromDate(now),
          'role': 'member',
          'lastSeenAt': Timestamp.fromDate(now),
        },
      });

      // 2) Add group ref to User doc
      await _firestore.collection('User').doc(_myEmail).set({
        'groups': {
          group.groupId: group.toUserGroupRef(),
        },
      }, SetOptions(merge: true));

      // 3) Update local state immediately
      final updatedMembers = Map<String, dynamic>.from(group.members);
      updatedMembers[_myEmail] = {
        'name': _myName,
        'imageUrl': _myPic,
        'joinedAt': Timestamp.fromDate(now),
        'role': 'member',
        'lastSeenAt': Timestamp.fromDate(now),
      };

      final joinedGroup = GroupModel(
        groupId: group.groupId,
        name: group.name,
        description: group.description,
        sport: group.sport,
        isPublic: group.isPublic,
        maxMembers: group.maxMembers,
        imageUrl: group.imageUrl,
        creator: group.creator,
        members: updatedMembers,
        createdAt: group.createdAt,
      );

      myGroups.insert(0, joinedGroup);
      myGroups.refresh();

      // 4) Remove from search results
      searchResults.removeWhere((g) => g.groupId == group.groupId);

      // 5) Save locally
      await GroupsSqflite.insertGroup(joinedGroup);

      Get.snackbar('Joined!', 'You are now a member of "${group.name}".',
          backgroundColor: const Color(0xFF1DB954),
          colorText: Colors.black);
    } catch (e) {
      debugPrint('🔴 [GroupsController] Join error: $e');
      Get.snackbar('Error', 'Failed to join group.',
          backgroundColor: Colors.redAccent, colorText: Colors.white);
    }
  }

  // ═══════════════════════════════════
  //  REQUEST TO JOIN PRIVATE GROUP
  // ═══════════════════════════════════

  Future<void> requestToJoinGroup(GroupModel group) async {
    try {
      final now = DateTime.now();

      await _firestore
          .collection('Groups')
          .doc(group.groupId)
          .collection('requests')
          .doc(_myEmail)
          .set({
        'senderEmail': _myEmail,
        'senderName': _myName,
        'senderPic': _myPic,
        'groupId': group.groupId,
        'timestamp': Timestamp.fromDate(now),
      });

      Get.snackbar('Request Sent', 'Your request to join "${group.name}" has been sent.',
          backgroundColor: const Color(0xFF1DB954),
          colorText: Colors.black);
    } catch (e) {
      debugPrint('🔴 [GroupsController] Request error: $e');
      Get.snackbar('Error', 'Failed to send request.',
          backgroundColor: Colors.redAccent, colorText: Colors.white);
    }
  }

  @override
  void onClose() {
    _requestsSub?.cancel();
    super.onClose();
  }
}
