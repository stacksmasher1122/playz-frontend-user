import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Friends_Controller/friends_controller.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Groups_Controller/groups_controller.dart';
import 'package:redesign/model/User_Models/More_Models/leaderboard_model.dart';
import 'package:redesign/services/xp_reward_service.dart';
import 'package:redesign/shared_preferences/userPreferences.dart';

class RankingController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Selected state
  final selectedScopeIndex = 0.obs; // 0: Global, 1: Friends, 2: Groups
  final selectedSportIndex = 0.obs; // 0: All Sports, 1: Football, 2: Cricket...

  final scopes = const ['Global', 'Friends', 'Groups'];
  final sports = const [
    'All Sports',
    'Football',
    'Cricket',
    'Badminton',
    'Tennis',
    'Basketball',
    'Volleyball',
    'Table Tennis',
    'Swimming',
    'Cycling',
    'Boxing',
    'Baseball',
    'Rugby',
  ];

  // Reactive data lists
  final allPlayers = <LeaderboardPlayerModel>[].obs;
  final filteredPlayers = <LeaderboardPlayerModel>[].obs;
  final isLoading = false.obs;

  String currentUserId = '';
  String currentUserName = 'You';
  String currentUserPic = '';

  String _myDocId = '';
  String _myEmail = '';
  String _myUid = '';

  StreamSubscription? _usersSub;

  @override
  void onInit() {
    super.onInit();
    _initRankingData();
  }

  @override
  void onClose() {
    _usersSub?.cancel();
    super.onClose();
  }

  Future<void> _initRankingData() async {
    isLoading.value = true;
    try {
      final authUser = FirebaseAuth.instance.currentUser;
      _myUid = authUser?.uid ?? '';
      _myEmail = authUser?.email?.toLowerCase().trim() ?? '';
      final docId = await UserPreferences.getDocId();
      _myDocId = (docId != null && docId.isNotEmpty) ? docId.trim() : _myEmail;

      final name = await UserPreferences.getUserName();
      final pic = await UserPreferences.getProfileImageUrl();

      currentUserId = _myDocId;
      currentUserName = (name != null && name.isNotEmpty)
          ? name
          : (authUser?.displayName ?? 'You');
      currentUserPic = (pic != null && (pic.startsWith('http://') || pic.startsWith('https://')))
          ? pic
          : (authUser?.photoURL ?? '');

      // Listen to real-time updates from User collection
      _usersSub?.cancel();
      _usersSub = _firestore.collection('User').snapshots().listen((snapshot) {
        _processUserSnapshots(snapshot.docs);
      }, onError: (e) {
        debugPrint('🔴 [RankingController] Firestore listener error: $e');
        _loadFallbackData();
      });
    } catch (e) {
      debugPrint('🔴 [RankingController] init error: $e');
      _loadFallbackData();
    } finally {
      isLoading.value = false;
    }
  }

  void setScope(int index) {
    if (index >= 0 && index < scopes.length) {
      selectedScopeIndex.value = index;
      _refilterAndRank();
    }
  }

  void setSport(int index) {
    if (index >= 0 && index < sports.length) {
      selectedSportIndex.value = index;
      _refilterAndRank();
    }
  }

  String _normalizeSportName(String raw) {
    if (raw.isEmpty) return raw;
    final clean = raw.trim().replaceAll('_', ' ');
    for (var s in sports) {
      if (s.toLowerCase() == clean.toLowerCase()) return s;
    }
    return clean.split(' ').map((w) => w.isNotEmpty ? w[0].toUpperCase() + w.substring(1).toLowerCase() : '').join(' ');
  }

  void _processUserSnapshots(List<QueryDocumentSnapshot<Map<String, dynamic>>> docs) {
    final List<LeaderboardPlayerModel> loaded = [];

    int parseNum(dynamic v) => (v is num) ? v.toInt() : 0;

    final authUser = FirebaseAuth.instance.currentUser;
    final activeEmail = _myEmail.isNotEmpty ? _myEmail : (authUser?.email?.toLowerCase().trim() ?? '');
    final activeUid = _myUid.isNotEmpty ? _myUid : (authUser?.uid ?? '');
    final activeDocId = _myDocId.isNotEmpty ? _myDocId.toLowerCase() : activeEmail;

    for (final doc in docs) {
      final data = doc.data();
      final uid = doc.id.trim();
      final primaryEmail = (data['primaryEmail'] ?? '').toString().toLowerCase().trim();
      final rawName = (data['fullName'] ?? data['userName'] ?? data['displayName'] ?? data['name'] ?? 'Player').toString().trim();
      final rawAvatar = (data['profileImageUrl'] ?? data['profilePic'] ?? data['userPic'] ?? data['photoURL'] ?? '').toString().trim();
      final avatar = (rawAvatar.startsWith('http://') || rawAvatar.startsWith('https://')) ? rawAvatar : '';

      final isMe = (
        (activeDocId.isNotEmpty && uid.toLowerCase() == activeDocId) ||
        (activeEmail.isNotEmpty && uid.toLowerCase() == activeEmail) ||
        (activeEmail.isNotEmpty && primaryEmail == activeEmail) ||
        (activeUid.isNotEmpty && uid == activeUid) ||
        (currentUserId.isNotEmpty && uid.toLowerCase() == currentUserId.toLowerCase())
      );

      // Extract special missions and rewards XP
      final missionsRewardsXp = parseNum(data['missionsRewardsXp'] ?? data['specialXp'] ?? data['rewardsXp']);

      // Extract sport XPs map from top level & gameStats
      final Map<String, int> sportXp = {};

      void extractFromMap(dynamic mapObj) {
        if (mapObj is Map) {
          mapObj.forEach((key, val) {
            if (val is num && val > 0) {
              final formattedKey = _normalizeSportName(key.toString());
              final existing = sportXp[formattedKey] ?? 0;
              if (val.toInt() > existing) {
                sportXp[formattedKey] = val.toInt();
              }
            }
          });
        }
      }

      extractFromMap(data['sportsXp']);
      if (data['gameStats'] is Map) {
        extractFromMap((data['gameStats'] as Map)['sportsXp']);
      }

      // Check top-level sport XP keys for all supported sports
      for (var s in sports) {
        if (s == 'All Sports') continue;
        final sLower = s.toLowerCase();
        final sSnake = sLower.replaceAll(' ', '_');
        final sCamel = sLower.replaceAllMapped(RegExp(r'\s+([a-z])'), (m) => m[1]!.toUpperCase());
        final existingVal = sportXp[s] ?? 0;
        if (existingVal == 0) {
          final val = parseNum(
            data['xp_$s'] ??
            data['xp_$sLower'] ??
            data['xp_$sSnake'] ??
            data['${sLower}Xp'] ??
            data['${sLower}XP'] ??
            data['${sSnake}Xp'] ??
            data['${sSnake}XP'] ??
            data['${sCamel}Xp'] ??
            data['${sCamel}XP'] ??
            data['${s}Xp']
          );
          if (val > 0) {
            sportXp[s] = val;
          }
        }
      }

      // Base overall XP fallback if no sport XPs found
      final basePoints = parseNum(data['xpPoints'] ?? data['points'] ?? data['xp'] ?? data['totalXp']);

      // If user has general XP from old bookings or overall basePoints, map dynamically
      // to user's preferred sport or active sport
      final userPrefSport = (data['preferredSport'] ?? data['favoriteSport'] ?? data['sport'] ?? '').toString().trim();
      final targetSport = userPrefSport.isNotEmpty ? _normalizeSportName(userPrefSport) : 'Cricket';

      final generalVal = sportXp['General'] ?? sportXp['general'] ?? 0;
      if (generalVal > 0) {
        final existingTarget = sportXp[targetSport] ?? 0;
        if (generalVal > existingTarget) {
          sportXp[targetSport] = generalVal;
        }
      }
      if (basePoints > 0 && (sportXp.isEmpty || sportXp.values.every((v) => v == 0))) {
        sportXp[targetSport] = basePoints;
      }

      // Automatically sync booking subcollection in the background for active user
      if (isMe) {
        XpRewardService.syncUserSportXpFromBookings(uid).then((syncedMap) {
          if (syncedMap.isNotEmpty) {
            bool updated = false;
            syncedMap.forEach((k, v) {
              final normalized = _normalizeSportName(k);
              if (v > (sportXp[normalized] ?? 0)) {
                sportXp[normalized] = v;
                updated = true;
              }
            });
            if (updated) {
              _refilterAndRank();
            }
          }
        });
      }

      loaded.add(LeaderboardPlayerModel(
        id: uid,
        name: isMe ? '$rawName (You)' : rawName,
        rawName: rawName,
        avatarUrl: avatar,
        isCurrentUser: isMe,
        sportXpMap: sportXp,
        missionsRewardsXp: missionsRewardsXp,
        points: basePoints,
      ));
    }

    // Ensure current user exists if Firestore list is empty or missing current user
    if (loaded.every((p) => !p.isCurrentUser) && (activeDocId.isNotEmpty || activeEmail.isNotEmpty)) {
      loaded.add(LeaderboardPlayerModel(
        id: activeDocId.isNotEmpty ? activeDocId : activeEmail,
        name: '$currentUserName (You)',
        rawName: currentUserName,
        avatarUrl: currentUserPic,
        isCurrentUser: true,
        points: 0,
        missionsRewardsXp: 0,
        sportXpMap: const {},
      ));
    }

    allPlayers.assignAll(loaded);
    _refilterAndRank();
  }

  void _refilterAndRank() {
    if (allPlayers.isEmpty) return;

    final selectedSport = sports[selectedSportIndex.value];
    final selectedScope = scopes[selectedScopeIndex.value];

    // 1. Filter candidates by scope
    List<LeaderboardPlayerModel> candidates = [];

    if (selectedScope == 'Friends') {
      Set<String> friendIds = {};
      try {
        if (Get.isRegistered<FriendsController>()) {
          final fc = Get.find<FriendsController>();
          friendIds = fc.friends.map((f) => f.email.toLowerCase().trim()).toSet();
        }
      } catch (_) {}

      candidates = allPlayers.where((p) => p.isCurrentUser || friendIds.contains(p.id.toLowerCase().trim())).toList();
    } else if (selectedScope == 'Groups') {
      Set<String> groupMemberIds = {};
      try {
        if (Get.isRegistered<GroupsController>()) {
          final gc = Get.find<GroupsController>();
          for (final g in gc.myGroups) {
            groupMemberIds.addAll(g.members.keys.map((k) => k.toLowerCase().trim()));
          }
        }
      } catch (_) {}

      candidates = allPlayers.where((p) => p.isCurrentUser || groupMemberIds.contains(p.id.toLowerCase().trim())).toList();
    } else {
      // Global
      candidates = List.from(allPlayers);
    }

    if (candidates.isEmpty) {
      candidates = allPlayers.where((p) => p.isCurrentUser).toList();
    }

    // 2. Compute points for each player
    // If "All Sports": total overall XP = Max of stored overall xpPoints or sum of per-sport XPs + Special Missions
    // If specific sport (e.g. Football): exact sport XP from sportsXp map
    final List<LeaderboardPlayerModel> evaluated = candidates.map((player) {
      int pts = 0;
      if (selectedSport == 'All Sports') {
        pts = player.totalOverallXp;
      } else {
        pts = player.sportXpMap[selectedSport] ??
              player.sportXpMap[selectedSport.toLowerCase()] ??
              player.sportXpMap[selectedSport.toLowerCase().replaceAll(' ', '_')] ??
              0;
      }

      return player.copyWith(points: pts);
    }).toList();

    // 3. Sort descending by points
    evaluated.sort((a, b) => b.points.compareTo(a.points));

    // 4. Assign dynamic ranks
    final List<LeaderboardPlayerModel> ranked = [];
    for (int i = 0; i < evaluated.length; i++) {
      ranked.add(evaluated[i].copyWith(rank: i + 1));
    }

    filteredPlayers.assignAll(ranked);
  }

  LeaderboardPlayerModel get currentUserModel {
    return filteredPlayers.firstWhere(
      (p) => p.isCurrentUser,
      orElse: () {
        if (allPlayers.isNotEmpty) {
          final me = allPlayers.firstWhere(
            (p) => p.isCurrentUser,
            orElse: () => allPlayers.first,
          );
          return me.copyWith(rank: 1, points: me.totalOverallXp);
        }
        return const LeaderboardPlayerModel(
          id: 'me',
          name: 'You',
          rawName: 'You',
          avatarUrl: '',
          isCurrentUser: true,
          points: 0,
          rank: 1,
          sportXpMap: {},
        );
      },
    );
  }

  void _loadFallbackData() {
    allPlayers.clear();
    _refilterAndRank();
  }
}
