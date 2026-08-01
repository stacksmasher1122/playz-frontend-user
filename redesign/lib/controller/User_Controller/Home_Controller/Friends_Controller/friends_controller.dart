import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:redesign/model/User_Models/Home_Models/Friends_Model/friends_model.dart';
import 'package:redesign/sqflite/User_SQF/Home_SQF/Friends_SQF/friendsSqflite.dart';
import 'package:redesign/shared_preferences/userPreferences.dart';
import 'package:redesign/services/xp_reward_service.dart';

class FriendsController extends GetxController {
  final _firestore = FirebaseFirestore.instance;

  // ── Reactive state ──
  final friends = <FriendModel>[].obs;
  final pendingRequests = <FriendRequestModel>[].obs;
  final searchResults = <Map<String, dynamic>>[].obs;
  final suggestedPlayers = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;
  final isSearching = false.obs;
  final isLoadingSuggested = false.obs;

  // Cache all users for client-side search
  List<Map<String, dynamic>> _allUsersCache = [];

  String _myEmail = '';

  @override
  void onInit() {
    super.onInit();
    _init();
  }

  Future<void> _init() async {
    _myEmail = await UserPreferences.getDocId() ?? '';
    if (_myEmail.isEmpty) return;

    // 1️⃣ Load local data instantly
    await _loadFromSqflite();

    // 2️⃣ Fetch live data and sync
    await fetchLiveData();
  }

  // ═══════════════════════════════════
  //  LOCAL → SQFLITE
  // ═══════════════════════════════════

  Future<void> _loadFromSqflite() async {
    try {
      final localFriends = await FriendsSqflite.getAllFriends();
      final localRequests = await FriendsSqflite.getAllRequests();
      friends.assignAll(localFriends);
      pendingRequests
          .assignAll(localRequests.where((r) => r.status == 'pending'));
    } catch (e) {
      debugPrint('🔴 [FriendsController] SQFlite load error: $e');
    }
  }

  // ═══════════════════════════════════
  //  LIVE → FIRESTORE
  // ═══════════════════════════════════

  Future<void> fetchLiveData() async {
    if (_myEmail.isEmpty) return;
    isLoading.value = true;
    try {
      await Future.wait([
        _fetchFriendsFromFirestore(),
        _fetchRequestsFromFirestore(),
        fetchSuggestedPlayers(),
      ]);
    } catch (e) {
      debugPrint('🔴 [FriendsController] Firestore fetch error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // ═══════════════════════════════════
  //  SUGGESTED PLAYERS LOGIC
  // ═══════════════════════════════════

  Future<void> fetchSuggestedPlayers() async {
    if (_myEmail.isEmpty) return;
    isLoadingSuggested.value = true;
    try {
      // 1. Fetch current user's profile to compare sports & level
      final myDoc = await _firestore.collection('User').doc(_myEmail).get();
      final myData = myDoc.data() ?? {};
      final mySports = (myData['favoriteSports'] as List<dynamic>?)
              ?.map((s) => s.toString().trim().toLowerCase())
              .toSet() ??
          {};
      final myTier = (myData['tier'] ?? 'Bronze').toString().trim().toLowerCase();
      final myXp = (myData['xpPoints'] as num?)?.toInt() ?? 100;

      final snapshot = await _firestore.collection('User').limit(40).get();
      final friendEmails =
          friends.map((f) => f.email.toLowerCase().trim()).toSet();
      final pendingEmails = pendingRequests
          .map((r) => r.fromEmail.toLowerCase().trim())
          .toSet();

      final suggestions = <Map<String, dynamic>>[];

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final docId = doc.id.toLowerCase().trim();
        final primaryEmail =
            (data['primaryEmail'] ?? doc.id).toString().toLowerCase().trim();

        // 1. Exclude current user
        if (docId == _myEmail.toLowerCase().trim() ||
            primaryEmail == _myEmail.toLowerCase().trim()) {
          continue;
        }

        // 2. Exclude existing friends
        if (friendEmails.contains(docId) ||
            friendEmails.contains(primaryEmail)) {
          continue;
        }

        // 3. Exclude pending requests
        if (pendingEmails.contains(docId) ||
            pendingEmails.contains(primaryEmail)) {
          continue;
        }

        final fullName = (data['fullName'] ?? '').toString().trim();
        final name = fullName.isNotEmpty
            ? fullName
            : (data['username'] ?? 'Player');

        final rawTier = (data['tier'] ?? 'Bronze').toString().trim();
        final level = rawTier.isNotEmpty
            ? (rawTier[0].toUpperCase() + rawTier.substring(1).toLowerCase())
            : 'Bronze';

        final candidateSports = (data['favoriteSports'] as List<dynamic>?)
                ?.map((s) => s.toString().trim())
                .toList() ??
            [];

        // Calculate sports overlap & level proximity
        final matchingSports = candidateSports
            .where((s) => mySports.contains(s.toLowerCase()))
            .toList();

        int score = 0;
        score += matchingSports.length * 10;
        if (rawTier.toLowerCase() == myTier) {
          score += 5;
        }
        final candidateXp = (data['xpPoints'] as num?)?.toInt() ?? 100;
        final xpDiff = (candidateXp - myXp).abs();
        if (xpDiff < 300) score += 3;

        String meta = 'Plays ${candidateSports.isNotEmpty ? candidateSports.first : 'Sports'}';
        if (matchingSports.isNotEmpty) {
          meta = '${matchingSports.length} Sport${matchingSports.length > 1 ? 's' : ''} in Common';
        } else if (rawTier.toLowerCase() == myTier) {
          meta = 'Same Level ($level)';
        } else if (candidateSports.isNotEmpty) {
          meta = '$level · ${candidateSports.first}';
        }

        suggestions.add({
          'docId': doc.id,
          'primaryEmail': data['primaryEmail'] ?? doc.id,
          'fullName': name,
          'profileImageUrl': data['profileImageUrl'] ?? '',
          'level': level,
          'meta': meta,
          'matchingSports': matchingSports,
          'score': score,
          'isPublicProfile': data['isPublicProfile'] ?? true,
          'isOnline': data['isOnline'] ?? false,
        });
      }

      // Sort by highest match score
      suggestions.sort((a, b) => (b['score'] as int).compareTo(a['score'] as int));

      // Take top 3 to 4 most matching real players
      suggestedPlayers.assignAll(suggestions.take(4).toList());
    } catch (e) {
      debugPrint('🔴 [FriendsController] Suggested players fetch error: $e');
    } finally {
      isLoadingSuggested.value = false;
    }
  }

  Future<void> _fetchFriendsFromFirestore() async {
    final doc = await _firestore.collection('User').doc(_myEmail).get();
    if (!doc.exists) return;

    final data = doc.data()!;
    final rawList = data['friends'] as List<dynamic>? ?? [];
    final liveFriends = await Future.wait(rawList.map((m) async {
      final friendMap = Map<String, dynamic>.from(m);
      final email = friendMap['email'];
      if (email != null && email.toString().isNotEmpty) {
        try {
          final fDoc = await _firestore.collection('User').doc(email).get();
          final fData = fDoc.data();
          if (fData != null) {
            friendMap['isOnline'] = fData['isOnline'] ?? false;
            friendMap['profileImageUrl'] = fData['profileImageUrl'] ?? friendMap['profileImageUrl'];
            friendMap['fullName'] = fData['fullName'] ?? friendMap['fullName'];
          }
        } catch (_) {}
      }
      return FriendModel.fromMap(friendMap);
    }).toList());

    friends.assignAll(liveFriends);
    await FriendsSqflite.clearAndInsertFriends(liveFriends);
  }

  Future<void> _fetchRequestsFromFirestore() async {
    final doc = await _firestore.collection('User').doc(_myEmail).get();
    if (!doc.exists) return;

    final data = doc.data()!;
    final rawList = data['friendRequests'] as List<dynamic>? ?? [];
    final liveRequests = rawList
        .map((m) => FriendRequestModel.fromMap(Map<String, dynamic>.from(m)))
        .toList();

    pendingRequests
        .assignAll(liveRequests.where((r) => r.status == 'pending'));
    await FriendsSqflite.clearAndInsertRequests(liveRequests);
  }

  // ═══════════════════════════════════
  //  SEARCH USERS
  // ═══════════════════════════════════

  Future<void> searchUsers(String query) async {
    if (query.trim().isEmpty) {
      searchResults.clear();
      isSearching.value = false;
      return;
    }

    isSearching.value = true;

    // Lazy-load the full user list on first search
    if (_allUsersCache.isEmpty) {
      try {
        final snapshot = await _firestore.collection('User').get();
        _allUsersCache = snapshot.docs
            .where((doc) => doc.id != _myEmail)
            .map((doc) => {'docId': doc.id, ...doc.data()})
            .toList();
      } catch (e) {
        debugPrint('🔴 [FriendsController] User fetch error: $e');
        isSearching.value = false;
        return;
      }
    }

    final lowerQuery = query.toLowerCase();
    final friendEmails = friends.map((f) => f.email).toSet();
    final requestedEmails = pendingRequests.map((r) => r.fromEmail).toSet();

    searchResults.assignAll(
      _allUsersCache.where((user) {
        final name = (user['fullName'] ?? '').toString().toLowerCase();
        final email = (user['primaryEmail'] ?? '').toString().toLowerCase();
        return name.contains(lowerQuery) || email.contains(lowerQuery);
      }).map((user) {
        final userEmail = user['primaryEmail'] ?? user['docId'] ?? '';
        return {
          ...user,
          'alreadyFriend': friendEmails.contains(userEmail),
          'alreadyRequested': requestedEmails.contains(userEmail),
        };
      }).toList(),
    );
  }

  // ═══════════════════════════════════
  //  SEND FRIEND REQUEST / DIRECT ADD
  // ═══════════════════════════════════

  Future<void> sendFriendRequest(Map<String, dynamic> targetUser) async {
    final targetEmail =
        targetUser['primaryEmail'] ?? targetUser['docId'] ?? '';
    final isPublic = targetUser['isPublicProfile'] ?? true;

    if (targetEmail.isEmpty || targetEmail == _myEmail) return;

    // Instantly remove from suggested list for responsive UI
    suggestedPlayers.removeWhere((p) =>
        (p['primaryEmail'] ?? p['docId']) == targetEmail ||
        p['docId'] == targetEmail);

    // Get my profile data
    final myDoc = await _firestore.collection('User').doc(_myEmail).get();
    final myData = myDoc.data() ?? {};
    final myName = myData['fullName'] ?? '';
    final myPic = myData['profileImageUrl'] ?? '';

    final targetName = targetUser['fullName'] ?? '';
    final targetPic = targetUser['profileImageUrl'] ?? '';
    final isOnline = targetUser['isOnline'] ?? false;

    if (isPublic) {
      // ── Direct add (public profile) ──
      await _addFriendBothSides(
        targetEmail: targetEmail,
        targetName: targetName,
        targetPic: targetPic,
        isOnline: isOnline,
        myName: myName,
        myPic: myPic,
      );
      await _createDMDoc(_myEmail, targetEmail);
    } else {
      // ── Send request (private profile) ──
      final request = FriendRequestModel(
        fromEmail: _myEmail,
        toEmail: targetEmail,
        fromName: myName,
        fromProfilePic: myPic,
        status: 'pending',
      );

      // Add to target user's friendRequests field
      await _firestore.collection('User').doc(targetEmail).update({
        'friendRequests': FieldValue.arrayUnion([request.toMap()]),
      });
    }

    // Refresh live data
    await fetchLiveData();
    // Invalidate search cache to update statuses
    _allUsersCache.clear();
  }

  // ═══════════════════════════════════
  //  APPROVE REQUEST
  // ═══════════════════════════════════

  Future<void> approveFriendRequest(FriendRequestModel request) async {
    // 1. Get requester's profile for friend data
    final requesterDoc =
        await _firestore.collection('User').doc(request.fromEmail).get();
    final requesterData = requesterDoc.data() ?? {};

    final myDoc = await _firestore.collection('User').doc(_myEmail).get();
    final myData = myDoc.data() ?? {};

    // 2. Add each other as friends
    await _addFriendBothSides(
      targetEmail: request.fromEmail,
      targetName: requesterData['fullName'] ?? request.fromName,
      targetPic: requesterData['profileImageUrl'] ?? request.fromProfilePic,
      isOnline: requesterData['isOnline'] ?? false,
      myName: myData['fullName'] ?? '',
      myPic: myData['profileImageUrl'] ?? '',
    );

    // 3. Remove the request from my friendRequests field
    await _firestore.collection('User').doc(_myEmail).update({
      'friendRequests': FieldValue.arrayRemove([request.toMap()]),
    });

    // 4. Create DM document
    await _createDMDoc(_myEmail, request.fromEmail);

    // 5. Refresh
    await fetchLiveData();
    _allUsersCache.clear();
  }

  // ═══════════════════════════════════
  //  REMOVE FRIEND
  // ═══════════════════════════════════

  Future<void> removeFriend(String targetEmail) async {
    if (_myEmail.isEmpty || targetEmail.isEmpty) return;

    try {
      // 1. Find the friend entries to remove
      final myDoc = await _firestore.collection('User').doc(_myEmail).get();
      final targetDoc = await _firestore.collection('User').doc(targetEmail).get();

      final myFriends = List<Map<String, dynamic>>.from(myDoc.data()?['friends'] ?? []);
      final targetFriends = List<Map<String, dynamic>>.from(targetDoc.data()?['friends'] ?? []);

      final myEntryToRemove = myFriends.firstWhereOrNull((f) => f['email'] == targetEmail);
      final targetEntryToRemove = targetFriends.firstWhereOrNull((f) => f['email'] == _myEmail);

      // 2. Remove from both users' friends arrays
      if (myEntryToRemove != null) {
        await _firestore.collection('User').doc(_myEmail).update({
          'friends': FieldValue.arrayRemove([myEntryToRemove])
        });
      }
      if (targetEntryToRemove != null) {
        await _firestore.collection('User').doc(targetEmail).update({
          'friends': FieldValue.arrayRemove([targetEntryToRemove])
        });
      }

      // 3. Delete DM document and subcollections
      final sorted = [_myEmail, targetEmail]..sort();
      final dmDocId = sorted.join('_');
      final dmRef = _firestore.collection('Direct_Message').doc(dmDocId);

      // Delete all Chats subcollection documents
      final chatsSnapshot = await dmRef.collection('Chats').get();
      final batch = _firestore.batch();
      for (final doc in chatsSnapshot.docs) {
        batch.delete(doc.reference);
      }
      batch.delete(dmRef);
      await batch.commit();

      // 4. Update local state and DB
      friends.removeWhere((f) => f.email == targetEmail);
      await FriendsSqflite.deleteFriend(targetEmail);
      await FriendsSqflite.deleteMessagesByDmId(dmDocId);

      _allUsersCache.clear();
      await fetchLiveData();

    } catch (e) {
      debugPrint('🔴 [FriendsController] Remove friend error: $e');
    }
  }

  // ═══════════════════════════════════
  //  DECLINE REQUEST
  // ═══════════════════════════════════

  Future<void> declineRequest(FriendRequestModel request) async {
    await _firestore.collection('User').doc(_myEmail).update({
      'friendRequests': FieldValue.arrayRemove([request.toMap()]),
    });
    await fetchLiveData();
  }

  // ═══════════════════════════════════
  //  HELPERS
  // ═══════════════════════════════════

  Future<void> _addFriendBothSides({
    required String targetEmail,
    required String targetName,
    required String targetPic,
    required bool isOnline,
    required String myName,
    required String myPic,
  }) async {
    final myFriendEntry = FriendModel(
      email: targetEmail,
      fullName: targetName,
      profileImageUrl: targetPic,
      isOnline: isOnline,
    );

    final theirFriendEntry = FriendModel(
      email: _myEmail,
      fullName: myName,
      profileImageUrl: myPic,
      isOnline: true, // I am assumed online if I'm doing this
    );

    // Update both users' friends field
    await _firestore.collection('User').doc(_myEmail).update({
      'friends': FieldValue.arrayUnion([myFriendEntry.toMap()]),
    });
    await _firestore.collection('User').doc(targetEmail).update({
      'friends': FieldValue.arrayUnion([theirFriendEntry.toMap()]),
    });

    // Award +2 XP to both users for adding a new friend
    await XpRewardService.awardBookingXp(
      userDocId: _myEmail,
      sport: 'general',
      xpAmount: 2,
    );
    await XpRewardService.awardBookingXp(
      userDocId: targetEmail,
      sport: 'general',
      xpAmount: 2,
    );
  }

  /// Creates DM doc with alphabetical email concat as ID
  Future<void> _createDMDoc(String email1, String email2) async {
    final sorted = [email1, email2]..sort();
    final dmDocId = sorted.join('_');

    final dmRef = _firestore.collection('Direct_Message').doc(dmDocId);
    final existing = await dmRef.get();

    if (!existing.exists) {
      await dmRef.set({
        'participants': sorted,
        'createdAt': FieldValue.serverTimestamp(),
        'lastMessage': '',
        'lastMessageAt': FieldValue.serverTimestamp(),
      });
    }
  }
}
