import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

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
import 'package:redesign/services/global_groups_service.dart';
import 'package:redesign/controller/maps_controller.dart';
import 'package:redesign/services/xp_reward_service.dart';

class GroupsController extends GetxController {
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;
  final _picker = ImagePicker();
  final _uuid = const Uuid();

  // ── Reactive state ──
  final myGroups = <GroupModel>[].obs;
  final recommendedGroups = <GroupModel>[].obs;
  final pendingGroupRequests = <GroupRequestModel>[].obs;

  final isLoading = false.obs;
  final isLoadingRecommended = false.obs;
  final isCreating = false.obs;
  final pickedImage = Rxn<File>();

  StreamSubscription? _requestsSub;

  String _myEmail = '';
  String _myName = '';
  String _myPic = '';

  String get myEmail => _myEmail;

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

    // 1) Load from local SQFlite database for instant display
    await _loadFromSqflite();

    // 2) Ensure user is joined to PLAYZ-GLOBAL & favorite PLAYZ-{sport} groups in background
    try {
      await GlobalGroupsService.checkAndJoinAllUserGroups(
        targetDocId: _myEmail,
      );
    } catch (e) {
      debugPrint('🔴 [GroupsController] Global groups check error: $e');
    }

    // 3) Fetch live user groups & recommended groups from Firestore in parallel
    await Future.wait([fetchMyGroups(), fetchRecommendedGroups()]);
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
  //  LIVE → FIRESTORE MY GROUPS (PARALLEL FETCH)
  // ═══════════════════════════════════

  Future<void> fetchMyGroups() async {
    if (_myEmail.isEmpty) return;
    isLoading.value = true;
    try {
      final userDoc = await _firestore.collection('User').doc(_myEmail).get();
      if (!userDoc.exists || userDoc.data() == null) return;

      final data = userDoc.data()!;
      final groupsMap = Map<String, dynamic>.from(data['groups'] ?? {});

      if (groupsMap.isEmpty) {
        myGroups.clear();
        await GroupsSqflite.clearAll();
        return;
      }

      // Fetch full group details in parallel for fast response
      final groupFutures = groupsMap.keys.map(
        (groupId) => _firestore.collection('Groups').doc(groupId).get(),
      );
      final groupDocs = await Future.wait(groupFutures);

      final List<GroupModel> liveGroups = [];
      for (final groupDoc in groupDocs) {
        if (groupDoc.exists && groupDoc.data() != null) {
          try {
            liveGroups.add(GroupModel.fromMap(groupDoc.data()!, groupDoc.id));
          } catch (e) {
            debugPrint('🔴 [GroupsController] Parse group error: $e');
          }
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
  //  LIVE → RECOMMENDED GROUPS
  // ═══════════════════════════════════

  // ── Haversine Distance Helper (in km) ──
  double _calculateDistanceKm(double lat1, double lon1, double lat2, double lon2) {
    const p = 0.017453292519943295;
    final a = 0.5 -
        math.cos((lat2 - lat1) * p) / 2 +
        math.cos(lat1 * p) *
            math.cos(lat2 * p) *
            (1 - math.cos((lon2 - lon1) * p)) /
            2;
    return 12742 * math.asin(math.sqrt(a));
  }

  // ═══════════════════════════════════
  //  LIVE → RECOMMENDED GROUPS
  // ═══════════════════════════════════

  Future<void> fetchRecommendedGroups() async {
    isLoadingRecommended.value = true;
    try {
      // 1) Fetch all public & official groups from Firestore
      final snapshot = await _firestore.collection('Groups').get();
      final allGroups = snapshot.docs
          .map((doc) => GroupModel.fromMap(doc.data(), doc.id))
          .toList();

      // 2) Fetch user's left groups history from Firestore User doc
      List<String> leftGroups = [];
      if (_myEmail.isNotEmpty) {
        final userDoc = await _firestore.collection('User').doc(_myEmail).get();
        final rawLeft = userDoc.data()?['leftGroups'];
        if (rawLeft is List) {
          leftGroups = rawLeft.map((e) => e.toString()).toList();
        }
      }

      // 3) Separate official PlayZ global groups vs normal groups
      final officialPlayzGroups = allGroups.where((g) => g.isPlayZGlobalGroup).toList();

      // Check if user is currently part of or was part of ALL official PlayZ groups
      final unjoinedOfficialGroups = officialPlayzGroups.where((g) {
        final isCurrentMember = g.members.containsKey(_myEmail);
        final wasMember = leftGroups.contains(g.groupId);
        return !isCurrentMember && !wasMember;
      }).toList();

      final List<GroupModel> recommendedList = [];

      if (unjoinedOfficialGroups.isNotEmpty) {
        // ── CASE 1: User has NOT been part of all official PlayZ groups ──
        // Show the other 2-3 PlayZ official groups
        recommendedList.addAll(unjoinedOfficialGroups.take(3));
      } else {
        // ── CASE 2: User IS part of all or WAS part of all official PlayZ groups ──
        // Rule: 1 group will be PlayZ, and other 2 will be from user's favorite sports within 100km!

        // A) 1 Official PlayZ Group (primary global group, e.g. PLAYZ-GLOBAL)
        final playzOfficial = officialPlayzGroups.firstWhereOrNull(
              (g) => g.groupId.toUpperCase() == 'PLAYZ-GLOBAL',
            ) ??
            (officialPlayzGroups.isNotEmpty ? officialPlayzGroups.first : null);

        if (playzOfficial != null) {
          recommendedList.add(playzOfficial);
        }

        // B) Fetch user's favorite sports
        final userFavorites = await UserPreferences.getFavoriteSports();
        final safeFavorites = userFavorites.isNotEmpty
            ? userFavorites
            : ['Cricket', 'Football', 'Badminton'];

        final mostPlayedSport = safeFavorites.first;

        // C) Get user location for 100 km radius filter
        final mapsCtrl = Get.isRegistered<MapsController>()
            ? Get.find<MapsController>()
            : null;
        final userLoc = mapsCtrl?.currentLocation.value;
        final double? userLat = userLoc?.lat;
        final double? userLng = userLoc?.lng;

        // D) Candidates for non-global groups where user is not currently a member
        final candidateGroups = allGroups.where((g) {
          if (g.isPlayZGlobalGroup) return false;
          if (g.members.containsKey(_myEmail)) return false;
          return true;
        }).toList();

        // E) Filter candidates within 100 kms of user's location
        final nearCandidates = candidateGroups.where((g) {
          if (userLat != null && userLng != null && g.latitude != null && g.longitude != null) {
            final distKm = _calculateDistanceKm(userLat, userLng, g.latitude!, g.longitude!);
            return distKm <= 100.0;
          }
          if (userLoc != null && userLoc.city.isNotEmpty && g.city.isNotEmpty) {
            return g.city.toLowerCase() == userLoc.city.toLowerCase();
          }
          return true; // Fallback if no lat/lng set
        }).toList();

        // F) Pick 1 group for the sport user plays most (within 100 km)
        GroupModel? mostPlayedGroup = nearCandidates.firstWhereOrNull(
          (g) => g.sport.toLowerCase() == mostPlayedSport.toLowerCase(),
        );

        // Fallback to candidate groups of most played sport if no location match
        mostPlayedGroup ??= candidateGroups.firstWhereOrNull(
          (g) => g.sport.toLowerCase() == mostPlayedSport.toLowerCase(),
        );

        if (mostPlayedGroup != null) {
          recommendedList.add(mostPlayedGroup);
        }

        // G) Pick 1 group for another favorite sport (within 100 km)
        final otherFavoriteSports = safeFavorites
            .where((s) => s.toLowerCase() != mostPlayedSport.toLowerCase())
            .toList();

        GroupModel? secondFavoriteGroup;
        for (final sport in otherFavoriteSports) {
          secondFavoriteGroup = nearCandidates.firstWhereOrNull(
            (g) => g.sport.toLowerCase() == sport.toLowerCase() && !recommendedList.contains(g),
          );
          if (secondFavoriteGroup != null) break;
        }

        // Fallback to candidate groups if near candidates has no match
        if (secondFavoriteGroup == null) {
          for (final sport in safeFavorites) {
            secondFavoriteGroup = candidateGroups.firstWhereOrNull(
              (g) => g.sport.toLowerCase() == sport.toLowerCase() && !recommendedList.contains(g),
            );
            if (secondFavoriteGroup != null) break;
          }
        }

        if (secondFavoriteGroup != null) {
          recommendedList.add(secondFavoriteGroup);
        }
      }

      recommendedGroups.assignAll(recommendedList);
    } catch (e) {
      debugPrint('🔴 [GroupsController] Recommended fetch error: $e');
    } finally {
      isLoadingRecommended.value = false;
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
    String locality = '',
    String city = '',
    String address = '',
    double? latitude,
    double? longitude,
  }) async {
    if (name.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Group name is required.',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
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
        locality: locality.trim(),
        city: city.trim(),
        address: address.trim(),
        latitude: latitude,
        longitude: longitude,
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
        'groups': {groupId: group.toUserGroupRef()},
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
      fetchRecommendedGroups();

      // Award +5 XP for creating a group (once per unique groupId)
      await XpRewardService.awardGroupXpOnce(
        userDocId: _myEmail,
        groupId: groupId,
        xpAmount: 5,
      );

      Get.snackbar(
        'Success',
        'Group "$name" created!',
        backgroundColor: const Color(0xFF1DB954),
        colorText: Colors.black,
      );

      return true;
    } catch (e) {
      debugPrint('🔴 [GroupsController] Create group error: $e');
      Get.snackbar(
        'Error',
        'Failed to create group. Please try again.',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
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
            snapshot.docs
                .map((doc) => GroupRequestModel.fromMap(doc.data()))
                .toList(),
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
      final groupDoc = await _firestore
          .collection('Groups')
          .doc(req.groupId)
          .get();
      if (groupDoc.exists && groupDoc.data() != null) {
        final groupData = groupDoc.data()!;
        final groupRef = {
          'groupId': req.groupId,
          'name': groupData['name'],
          'description': groupData['description'],
          'imageUrl': groupData['imageUrl'],
        };

        await _firestore.collection('User').doc(req.senderEmail).set({
          'groups': {req.groupId: groupRef},
        }, SetOptions(merge: true));
      }

      // 3) Delete the request
      await _firestore
          .collection('Groups')
          .doc(req.groupId)
          .collection('requests')
          .doc(req.senderEmail)
          .delete();

      // Award +5 XP to the user for joining the group (once per unique groupId)
      await XpRewardService.awardGroupXpOnce(
        userDocId: req.senderEmail,
        groupId: req.groupId,
        xpAmount: 5,
      );

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
      final snapshot = await _firestore.collection('Groups').get();
      final lowerQuery = query.toLowerCase();

      final results = snapshot.docs
          .map((doc) => GroupModel.fromMap(doc.data(), doc.id))
          .where(
            (g) =>
                g.name.toLowerCase().contains(lowerQuery) &&
                !myGroups.any((mine) => mine.groupId == g.groupId),
          )
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
        'groups': {group.groupId: group.toUserGroupRef()},
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

      // 4) Remove from search & recommended results
      searchResults.removeWhere((g) => g.groupId == group.groupId);
      recommendedGroups.removeWhere((g) => g.groupId == group.groupId);

      // 5) Save locally
      await GroupsSqflite.insertGroup(joinedGroup);

      // Award +5 XP for joining a public group (once per unique groupId)
      await XpRewardService.awardGroupXpOnce(
        userDocId: _myEmail,
        groupId: group.groupId,
        xpAmount: 5,
      );

      Get.snackbar(
        'Joined!',
        'You are now a member of "${group.name}".',
        backgroundColor: const Color(0xFF1DB954),
        colorText: Colors.black,
      );
    } catch (e) {
      debugPrint('🔴 [GroupsController] Join error: $e');
      Get.snackbar(
        'Error',
        'Failed to join group.',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
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

      Get.snackbar(
        'Request Sent',
        'Your request to join "${group.name}" has been sent.',
        backgroundColor: const Color(0xFF1DB954),
        colorText: Colors.black,
      );
    } catch (e) {
      debugPrint('🔴 [GroupsController] Request error: $e');
      Get.snackbar(
        'Error',
        'Failed to send request.',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }

  Future<bool> updateGroupLocation({
    required String groupId,
    required String locality,
    required String city,
    required String address,
    double? latitude,
    double? longitude,
  }) async {
    try {
      final locData = {
        'locality': locality.trim(),
        'city': city.trim(),
        'address': address.trim(),
        'latitude': latitude,
        'longitude': longitude,
      };

      // 1) Update Firestore Groups/{groupId}
      await _firestore.collection('Groups').doc(groupId).update(locData);

      // 2) Update Firestore User/{myEmail} nested group ref
      await _firestore.collection('User').doc(_myEmail).set({
        'groups': {
          groupId: locData,
        },
      }, SetOptions(merge: true));

      // 3) Update local reactive list
      final index = myGroups.indexWhere((g) => g.groupId == groupId);
      if (index != -1) {
        final existing = myGroups[index];
        final updatedGroup = GroupModel(
          groupId: existing.groupId,
          name: existing.name,
          description: existing.description,
          sport: existing.sport,
          isPublic: existing.isPublic,
          maxMembers: existing.maxMembers,
          imageUrl: existing.imageUrl,
          creator: existing.creator,
          members: existing.members,
          createdAt: existing.createdAt,
          profanityModerationMembers: existing.profanityModerationMembers,
          profanityModerationAdmins: existing.profanityModerationAdmins,
          locality: locality.trim(),
          city: city.trim(),
          address: address.trim(),
          latitude: latitude,
          longitude: longitude,
        );
        myGroups[index] = updatedGroup;
        myGroups.refresh();

        // 4) Update local SQFlite DB
        await GroupsSqflite.insertGroup(updatedGroup);
      }

      return true;
    } catch (e) {
      debugPrint('🔴 [GroupsController] updateGroupLocation error: $e');
      return false;
    }
  }

  @override
  void onClose() {
    _requestsSub?.cancel();
    super.onClose();
  }
}
