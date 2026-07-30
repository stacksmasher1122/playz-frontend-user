import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:redesign/model/User_Models/Home_Models/Groups_Model/groups_model.dart';
import 'package:redesign/model/User_Models/Home_Models/Groups_Model/group_info_model.dart';
import 'package:redesign/sqflite/User_SQF/Home_SQF/Groups_SQF/groupsSqflite.dart';
import 'package:redesign/sqflite/User_SQF/Home_SQF/Groups_SQF/groupsInfoSqflite.dart';
import 'package:redesign/shared_preferences/userPreferences.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Groups_Controller/groups_controller.dart';

class GroupInfoController extends GetxController {
  final _firestore = FirebaseFirestore.instance;
  final _picker = ImagePicker();
  final _storage = FirebaseStorage.instance;

  // ── State ──
  final Rxn<GroupModel> currentGroup = Rxn<GroupModel>();
  final mediaFiles = <GroupMediaModel>[].obs;
  
  final isLoading = false.obs;
  final isSaving = false.obs;
  final isAdmin = false.obs;
  final friendsList = <Map<String, dynamic>>[].obs;

  // Real-time tracking listeners & workers
  StreamSubscription? _groupSub;
  StreamSubscription? _mediaSub;
  StreamSubscription? _friendsSub;
  Worker? _groupWorker;
  Worker? _friendsWorker;

  String myEmail = '';
  String myName = '';
  String myPic = '';
  String _lastSearchQuery = '';

  @override
  void onClose() {
    _groupSub?.cancel();
    _mediaSub?.cancel();
    _friendsSub?.cancel();
    _groupWorker?.dispose();
    _friendsWorker?.dispose();
    super.onClose();
  }

  Future<void> initGroupInfo(String groupId) async {
    myEmail = await UserPreferences.getDocId() ?? '';
    myName = await UserPreferences.getUserName() ?? '';
    myPic = await UserPreferences.getProfileImageUrl() ?? '';

    if (myEmail.isEmpty) return;

    // 1) Initial SQFlite load for fast UI render
    final localGroup = await GroupsSqflite.getGroupById(groupId);
    if (localGroup != null) {
      currentGroup.value = localGroup;
      _checkAdmin(localGroup);
    }
    
    final localMedia = await GroupsInfoSqflite.getGroupMedia(groupId);
    mediaFiles.assignAll(localMedia);

    // 2) Start Live Data Stream
    _listenToGroupUpdates(groupId);
    _listenToMedia(groupId);
    _listenToFriends();

    // 3) Dispose previous workers and create fresh reactive search listeners
    _groupWorker?.dispose();
    _friendsWorker?.dispose();
    _groupWorker = ever(currentGroup, (_) => _performLocalSearch(_lastSearchQuery));
    _friendsWorker = ever(friendsList, (_) => _performLocalSearch(_lastSearchQuery));
  }

  void _checkAdmin(GroupModel group) {
    if (group.members[myEmail] == null) {
      isAdmin.value = false;
      return;
    }
    final role = group.members[myEmail]['role'];
    isAdmin.value = (role == 'admin' || group.creator == myEmail);
  }

  void _listenToGroupUpdates(String groupId) {
    _groupSub?.cancel();
    _groupSub = _firestore.collection('Groups').doc(groupId).snapshots().listen(
      (doc) async {
        if (!doc.exists || doc.data() == null) return; // Group deleted or empty
        try {
          final group = GroupModel.fromMap(doc.data()!, doc.id);
          
          // Cache update
          await GroupsSqflite.insertGroup(group);
          
          currentGroup.value = group;
          _checkAdmin(group);
        } catch (e) {
          debugPrint('🔴 [GroupInfoController] Group parse error: $e');
        }
      },
      onError: (e) => debugPrint('🔴 [GroupInfoController] Group stream error: $e'),
    );
  }

  void _listenToMedia(String groupId) {
    _mediaSub?.cancel();
    _mediaSub = _firestore
        .collection('Groups')
        .doc(groupId)
        .collection('chats')
        .where('type', whereIn: ['image', 'video'])
        .snapshots()
        .listen(
      (snapshot) async {
        final newMedia = snapshot.docs
            .map((doc) => GroupMediaModel.fromMap(doc.id, groupId, doc.data()))
            .toList();
        newMedia.sort((a, b) => b.timestamp.compareTo(a.timestamp));
        mediaFiles.assignAll(newMedia);
        await GroupsInfoSqflite.clearAndInsertGroupMedia(groupId, newMedia);
      },
      onError: (e) => debugPrint('🔴 [GroupInfoController] Media stream error: $e'),
    );
  }

  // ═══════════════════════════════════════════════════════
  //  EDIT GROUP DETAILS
  // ═══════════════════════════════════════════════════════

  Future<void> updateGroupDetails(String groupId, String name, String desc, {File? newImage}) async {
    if (!isAdmin.value) return;
    isSaving.value = true;
    try {
      String imageUrl = currentGroup.value?.imageUrl ?? '';
      
      if (newImage != null) {
        final ref = _storage.ref().child('Groups/$groupId/media/profile.jpg');
        await ref.putFile(newImage, SettableMetadata(contentType: 'image/jpeg'));
        imageUrl = await ref.getDownloadURL();
      }

      await _firestore.collection('Groups').doc(groupId).update({
        'name': name.trim(),
        'description': desc.trim(),
        'imageUrl': imageUrl,
      });
      
      Get.snackbar('Success', 'Group details updated',
          backgroundColor: const Color(0xFF1DB954), colorText: Colors.black);
    } catch (e) {
      debugPrint('🔴 [GroupInfoController] Edit group error: $e');
      Get.snackbar('Error', 'Failed to update group details.');
    } finally {
      isSaving.value = false;
    }
  }

  Future<File?> pickImage() async {
    final XFile? file = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (file != null) return File(file.path);
    return null;
  }

  void _listenToFriends() {
    if (myEmail.isEmpty) return;
    _friendsSub?.cancel();
    _friendsSub = _firestore.collection('User').doc(myEmail).snapshots().listen(
      (doc) {
        if (!doc.exists || doc.data() == null) return;
        final data = doc.data()!;
        final rawFriends = data['friends'] as List? ?? [];
        friendsList.assignAll(
          rawFriends.map((f) => Map<String, dynamic>.from(f)).toList()
        );
      },
      onError: (e) => debugPrint('🔴 [GroupInfoController] Friends stream error: $e'),
    );
  }

  // ═══════════════════════════════════════════════════════
  //  MEMBER MANAGEMENT
  // ═══════════════════════════════════════════════════════

  final searchResults = <Map<String, dynamic>>[].obs;
  
  void searchUsers(String query) {
    _lastSearchQuery = query;
    _performLocalSearch(query);
  }

  void _performLocalSearch(String query) {
    if (query.trim().isEmpty) {
      searchResults.clear();
      return;
    }
    
    final lowerQuery = query.toLowerCase().trim();
    final memberEmails = currentGroup.value?.members.keys.toSet() ?? {};

    final filtered = friendsList.where((friend) {
      final email = (friend['email'] ?? '').toString();
      final name = (friend['fullName'] ?? email).toString().toLowerCase();
      
      final matchesQuery = name.contains(lowerQuery) || email.toLowerCase().contains(lowerQuery);
      final notInGroup = !memberEmails.contains(email);
      
      return matchesQuery && notInGroup;
    }).toList();

    searchResults.assignAll(filtered);
  }

  Future<void> addMember(String userEmail, Map<String, dynamic> userData) async {
    if (currentGroup.value == null) return;
    try {
      final groupId = currentGroup.value!.groupId;
      final now = DateTime.now();
      final memberName = userData['fullName'] ?? userData['Name'] ?? 'Unknown';
      final memberPic = userData['profileImageUrl'] ?? '';

      final newMemberData = {
        'name': memberName,
        'imageUrl': memberPic,
        'joinedAt': Timestamp.fromDate(now),
        'role': 'member',
        'lastSeenAt': Timestamp.fromDate(now),
      };

      // 1) Optimistically update local Group state
      final updatedMembers = Map<String, dynamic>.from(currentGroup.value!.members);
      updatedMembers[userEmail] = newMemberData;

      final updatedGroup = GroupModel.fromMap(
        {...currentGroup.value!.toMap(), 'members': updatedMembers},
        groupId,
      );
      currentGroup.value = updatedGroup;

      // 2) Write to Firestore
      await _firestore.collection('Groups').doc(groupId).update({
        FieldPath(['members', userEmail]): newMemberData,
      });

      await _firestore.collection('User').doc(userEmail).set({
        'groups': {
          groupId: {
            'groupId': groupId,
            'name': currentGroup.value!.name,
            'description': currentGroup.value!.description,
            'imageUrl': currentGroup.value!.imageUrl,
          },
        },
      }, SetOptions(merge: true));

      searchResults.removeWhere((item) => item['email'] == userEmail);

      Get.snackbar('Added', '$memberName added to group',
          backgroundColor: const Color(0xFF1DB954), colorText: Colors.black);
    } catch (e) {
      debugPrint('🔴 [GroupInfoController] Add member error: $e');
      Get.snackbar('Error', 'Failed to add member.');
    }
  }

  Future<void> removeMember(String memberEmail) async {
    if (!isAdmin.value || currentGroup.value == null) return;
    try {
      final groupId = currentGroup.value!.groupId;
      
      // Optimistic update
      final updatedMembers = Map<String, dynamic>.from(currentGroup.value!.members);
      updatedMembers.remove(memberEmail);
      currentGroup.value = GroupModel.fromMap(
        {...currentGroup.value!.toMap(), 'members': updatedMembers},
        groupId,
      );

      await _firestore.collection('Groups').doc(groupId).update({
        FieldPath(['members', memberEmail]): FieldValue.delete(),
      });
      
      await _firestore.collection('User').doc(memberEmail).update({
        FieldPath(['groups', groupId]): FieldValue.delete(),
      });
      
      Get.snackbar('Removed', 'User removed from group',
          backgroundColor: Colors.redAccent, colorText: Colors.white);
    } catch (e) {
      debugPrint('🔴 [GroupInfoController] Remove member error: $e');
      Get.snackbar('Error', 'Failed to remove member.');
    }
  }

  Future<void> makeAdmin(String memberEmail) async {
    if (!isAdmin.value || currentGroup.value == null) return;
    try {
      final groupId = currentGroup.value!.groupId;

      // Optimistic update
      final updatedMembers = Map<String, dynamic>.from(currentGroup.value!.members);
      if (updatedMembers.containsKey(memberEmail)) {
        updatedMembers[memberEmail] = {
          ...Map<String, dynamic>.from(updatedMembers[memberEmail]),
          'role': 'admin',
        };
      }
      currentGroup.value = GroupModel.fromMap(
        {...currentGroup.value!.toMap(), 'members': updatedMembers},
        groupId,
      );
      
      await _firestore.collection('Groups').doc(groupId).update({
        FieldPath(['members', memberEmail, 'role']): 'admin',
      });
      
      Get.snackbar('Success', 'User is now an admin',
          backgroundColor: const Color(0xFF1DB954), colorText: Colors.black);
    } catch (e) {
      debugPrint('🔴 [GroupInfoController] Make admin error: $e');
      Get.snackbar('Error', 'Failed to make admin.');
    }
  }

  Future<void> makeMember(String memberEmail) async {
    if (!isAdmin.value || currentGroup.value == null) return;
    try {
      final groupId = currentGroup.value!.groupId;

      // Optimistic update
      final updatedMembers = Map<String, dynamic>.from(currentGroup.value!.members);
      if (updatedMembers.containsKey(memberEmail)) {
        updatedMembers[memberEmail] = {
          ...Map<String, dynamic>.from(updatedMembers[memberEmail]),
          'role': 'member',
        };
      }
      currentGroup.value = GroupModel.fromMap(
        {...currentGroup.value!.toMap(), 'members': updatedMembers},
        groupId,
      );
      
      await _firestore.collection('Groups').doc(groupId).update({
        FieldPath(['members', memberEmail, 'role']): 'member',
      });
      
      Get.snackbar('Success', 'User is now a member',
          backgroundColor: Colors.orange, colorText: Colors.black);
    } catch (e) {
      debugPrint('🔴 [GroupInfoController] Make member error: $e');
      Get.snackbar('Error', 'Failed to change role.');
    }
  }

  // ═══════════════════════════════════════════════════════
  //  PROFANITY MODERATION TOGGLES
  // ═══════════════════════════════════════════════════════

  Future<void> toggleProfanityModerationMembers(bool value) async {
    if (currentGroup.value == null) return;
    if (!isAdmin.value) {
      Get.snackbar(
        'Permission Denied',
        'Only group admins can change chat moderation settings.',
        backgroundColor: Colors.orange,
        colorText: Colors.black,
      );
      return;
    }
    
    final oldGroup = currentGroup.value!;
    Map<String, dynamic> rawMap = oldGroup.toMap();
    rawMap['profanityModerationMembers'] = value;
    if (!value) {
      rawMap['profanityModerationAdmins'] = false;
    }
    currentGroup.value = GroupModel.fromMap(rawMap, oldGroup.groupId);

    try {
      final groupId = oldGroup.groupId;
      final updates = <String, dynamic>{
        'profanityModerationMembers': value,
      };
      if (!value) {
        updates['profanityModerationAdmins'] = false;
      }
      await _firestore.collection('Groups').doc(groupId).update(updates);
    } catch (e) {
      currentGroup.value = oldGroup; // revert on fail
      debugPrint('🔴 [GroupInfoController] Toggle member moderation error: $e');
      Get.snackbar('Error', 'Failed to update moderation setting.');
    }
  }

  Future<void> toggleProfanityModerationAdmins(bool value) async {
    if (currentGroup.value == null) return;
    if (!isAdmin.value) {
      Get.snackbar(
        'Permission Denied',
        'Only group admins can change chat moderation settings.',
        backgroundColor: Colors.orange,
        colorText: Colors.black,
      );
      return;
    }

    final oldGroup = currentGroup.value!;
    Map<String, dynamic> rawMap = oldGroup.toMap();
    rawMap['profanityModerationAdmins'] = value;
    currentGroup.value = GroupModel.fromMap(rawMap, oldGroup.groupId);

    try {
      final groupId = oldGroup.groupId;
      await _firestore.collection('Groups').doc(groupId).update({
        'profanityModerationAdmins': value,
      });
    } catch (e) {
      currentGroup.value = oldGroup; // revert on fail
      debugPrint('🔴 [GroupInfoController] Toggle admin moderation error: $e');
      Get.snackbar('Error', 'Failed to update moderation setting.');
    }
  }

  // ═══════════════════════════════════════════════════════
  //  LEAVE GROUP
  // ═══════════════════════════════════════════════════════

  Future<void> leaveGroup() async {
    if (currentGroup.value == null) return;
    final group = currentGroup.value!;
    final groupId = group.groupId;

    // PlayZ Global groups cannot be left
    if (groupId.startsWith('PLAYZ-')) {
      Get.snackbar(
        'Notice',
        'PlayZ Global community groups cannot be left.',
        backgroundColor: Colors.orange,
        colorText: Colors.black,
      );
      return;
    }

    try {
      // 1) Instantly update local state in GroupsController so UI updates immediately
      if (Get.isRegistered<GroupsController>()) {
        final groupsCtrl = Get.find<GroupsController>();
        groupsCtrl.myGroups.removeWhere((g) => g.groupId == groupId);
        groupsCtrl.myGroups.refresh();
      }

      // 2) Clear local SQFlite database
      await GroupsSqflite.deleteGroup(groupId);
      await GroupsSqflite.deleteGroupMessagesByGroupId(groupId);

      // 3) Show immediate feedback & pop back out of chat/info flow
      Get.snackbar(
        'Left Group',
        'You have left ${group.name}',
        backgroundColor: const Color(0xFF1DB954),
        colorText: Colors.black,
      );

      if (Get.isOverlaysOpen) {
        Get.back();
      }
      Get.until((route) => route.isFirst || Get.currentRoute == '/home');

      // 4) Perform Firestore network operations asynchronously in background
      _performBackgroundLeave(group, groupId);
    } catch (e) {
      debugPrint('🔴 [GroupInfoController] Leave group error: $e');
      Get.snackbar('Error', 'Failed to leave group.');
    }
  }

  Future<void> _performBackgroundLeave(GroupModel group, String groupId) async {
    try {
      // If the user leaving is an admin, auto-assign a new admin if available
      if (isAdmin.value) {
        final otherMembers = group.members.keys.where((k) => k != myEmail).toList();
        final hasOtherAdmin = otherMembers.any((k) => group.members[k]['role'] == 'admin');

        if (!hasOtherAdmin && otherMembers.isNotEmpty) {
          final newAdminEmail = otherMembers.first;
          await _firestore.collection('Groups').doc(groupId).update({
            FieldPath(['members', newAdminEmail, 'role']): 'admin',
          });
        }
      }

      // Remove self from group members map in Firestore
      await _firestore.collection('Groups').doc(groupId).update({
        FieldPath(['members', myEmail]): FieldValue.delete(),
      });

      // Remove group reference from user doc in Firestore
      await _firestore.collection('User').doc(myEmail).update({
        FieldPath(['groups', groupId]): FieldValue.delete(),
      });

      // Trigger full background sync in GroupsController
      if (Get.isRegistered<GroupsController>()) {
        final groupsCtrl = Get.find<GroupsController>();
        await groupsCtrl.fetchMyGroups();
        await groupsCtrl.fetchRecommendedGroups();
      }
    } catch (e) {
      debugPrint('🔴 [GroupInfoController] Background leave Firestore error: $e');
    }
  }
}
