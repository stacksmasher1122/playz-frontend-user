import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Friends_Controller/friends_controller.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Groups_Controller/groups_controller.dart';
import 'package:redesign/model/User_Models/More_Models/leaderboard_model.dart';
import 'package:redesign/shared_preferences/userPreferences.dart';

class RankingController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Selected state
  final selectedScopeIndex = 0.obs; // 0: Global, 1: Friends, 2: Groups
  final selectedSportIndex = 0.obs; // 0: All Sports, 1: Football, 2: Cricket, 3: Badminton, 4: Tennis

  final scopes = const ['Global', 'Friends', 'Groups'];
  final sports = const ['All Sports', 'Football', 'Cricket', 'Badminton', 'Tennis'];

  // Reactive data lists
  final allPlayers = <LeaderboardPlayerModel>[].obs;
  final filteredPlayers = <LeaderboardPlayerModel>[].obs;
  final isLoading = false.obs;

  String currentUserId = '';
  String currentUserName = 'You';
  String currentUserPic = '';

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
      final docId = await UserPreferences.getDocId();
      final name = await UserPreferences.getUserName();
      final pic = await UserPreferences.getProfileImageUrl();

      currentUserId = docId ?? '';
      currentUserName = (name != null && name.isNotEmpty) ? name : 'You';
      currentUserPic = pic ?? '';

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

  void _processUserSnapshots(List<QueryDocumentSnapshot<Map<String, dynamic>>> docs) {
    final List<LeaderboardPlayerModel> loaded = [];

    for (final doc in docs) {
      final data = doc.data();
      final uid = doc.id;
      final name = (data['userName'] ?? data['displayName'] ?? data['name'] ?? 'Player').toString();
      final avatar = (data['profileImageUrl'] ?? data['profilePic'] ?? data['userPic'] ?? data['photoURL'] ?? '').toString();

      // Extract sport XPs
      final Map<String, int> sportXp = {};

      // Check for sportXp map in document
      if (data['sportXp'] is Map) {
        final map = data['sportXp'] as Map;
        map.forEach((key, val) {
          if (val is num) {
            sportXp[key.toString()] = val.toInt();
          }
        });
      }

      // Check explicit sport XP fields
      int parseNum(dynamic v) => (v is num) ? v.toInt() : 0;

      sportXp['Football'] = sportXp['Football'] ?? parseNum(data['xp_Football'] ?? data['footballXp'] ?? data['footballXP']);
      sportXp['Cricket'] = sportXp['Cricket'] ?? parseNum(data['xp_Cricket'] ?? data['cricketXp'] ?? data['cricketXP']);
      sportXp['Badminton'] = sportXp['Badminton'] ?? parseNum(data['xp_Badminton'] ?? data['badmintonXp'] ?? data['badmintonXP']);
      sportXp['Tennis'] = sportXp['Tennis'] ?? parseNum(data['xp_Tennis'] ?? data['tennisXp'] ?? data['tennisXP']);

      // Base total fallback if no sport XPs found
      final basePoints = parseNum(data['points'] ?? data['xp'] ?? data['totalXp'] ?? 0);
      if (sportXp.values.every((v) => v == 0) && basePoints > 0) {
        sportXp['Football'] = (basePoints * 0.4).round();
        sportXp['Cricket'] = (basePoints * 0.3).round();
        sportXp['Badminton'] = (basePoints * 0.2).round();
        sportXp['Tennis'] = (basePoints * 0.1).round();
      }

      final isMe = (uid == currentUserId || (currentUserId.isNotEmpty && name == currentUserName));

      loaded.add(LeaderboardPlayerModel(
        id: uid,
        name: isMe ? '$name (You)' : name,
        rawName: name,
        avatarUrl: avatar.isNotEmpty ? avatar : 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=150',
        isCurrentUser: isMe,
        sportXpMap: sportXp,
      ));
    }

    // Ensure current user exists if Firestore list is empty or missing current user
    if (loaded.every((p) => !p.isCurrentUser)) {
      loaded.add(LeaderboardPlayerModel(
        id: currentUserId.isNotEmpty ? currentUserId : 'me',
        name: '$currentUserName (You)',
        rawName: currentUserName,
        avatarUrl: currentUserPic.isNotEmpty ? currentUserPic : 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=150',
        isCurrentUser: true,
        sportXpMap: const {
          'Football': 520,
          'Cricket': 420,
          'Badminton': 180,
          'Tennis': 120,
        },
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
          friendIds = fc.friends.map((f) => f.email).toSet();
        }
      } catch (_) {}

      candidates = allPlayers.where((p) => p.isCurrentUser || friendIds.contains(p.id)).toList();
    } else if (selectedScope == 'Groups') {
      Set<String> groupMemberIds = {};
      try {
        if (Get.isRegistered<GroupsController>()) {
          final gc = Get.find<GroupsController>();
          for (final g in gc.myGroups) {
            groupMemberIds.addAll(g.members.keys);
          }
        }
      } catch (_) {}

      candidates = allPlayers.where((p) => p.isCurrentUser || groupMemberIds.contains(p.id)).toList();
    } else {
      // Global
      candidates = List.from(allPlayers);
    }

    if (candidates.isEmpty) {
      candidates = allPlayers.where((p) => p.isCurrentUser).toList();
    }

    // 2. Compute points for each candidate based on selected sport
    final List<LeaderboardPlayerModel> evaluated = candidates.map((player) {
      int pts = 0;
      if (selectedSport == 'All Sports') {
        pts = player.totalXp;
      } else {
        pts = player.sportXpMap[selectedSport] ?? 0;
      }

      return player.copyWith(points: pts);
    }).toList();

    // 3. Sort descending by points
    evaluated.sort((a, b) => b.points.compareTo(a.points));

    // 4. Assign ranks
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
          return me.copyWith(rank: 1, points: me.totalXp);
        }
        return const LeaderboardPlayerModel(
          id: 'me',
          name: 'You',
          rawName: 'You',
          avatarUrl: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=150',
          isCurrentUser: true,
          points: 1240,
          rank: 1,
          sportXpMap: {
            'Football': 520,
            'Cricket': 420,
            'Badminton': 180,
            'Tennis': 120,
          },
        );
      },
    );
  }

  void _loadFallbackData() {
    final sampleDocs = [
      const LeaderboardPlayerModel(
        id: '1',
        name: 'Marcus J.',
        rawName: 'Marcus J.',
        points: 3120,
        avatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150',
        sportXpMap: {'Football': 1200, 'Cricket': 900, 'Badminton': 620, 'Tennis': 400},
      ),
      const LeaderboardPlayerModel(
        id: '2',
        name: 'Sarah M.',
        rawName: 'Sarah M.',
        points: 2450,
        avatarUrl: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=150',
        sportXpMap: {'Football': 950, 'Cricket': 800, 'Badminton': 450, 'Tennis': 250},
      ),
      const LeaderboardPlayerModel(
        id: '3',
        name: 'Elena R.',
        rawName: 'Elena R.',
        points: 2100,
        avatarUrl: 'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=150',
        sportXpMap: {'Football': 800, 'Cricket': 700, 'Badminton': 400, 'Tennis': 200},
      ),
      const LeaderboardPlayerModel(
        id: '4',
        name: 'Alex T.',
        rawName: 'Alex T.',
        points: 1890,
        avatarUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
        sportXpMap: {'Football': 700, 'Cricket': 600, 'Badminton': 350, 'Tennis': 240},
      ),
      const LeaderboardPlayerModel(
        id: '5',
        name: 'Jordan K.',
        rawName: 'Jordan K.',
        points: 1750,
        avatarUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150',
        sportXpMap: {'Football': 650, 'Cricket': 550, 'Badminton': 320, 'Tennis': 230},
      ),
      const LeaderboardPlayerModel(
        id: 'me',
        name: 'You',
        rawName: 'You',
        points: 1240,
        avatarUrl: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=150',
        isCurrentUser: true,
        sportXpMap: {'Football': 520, 'Cricket': 420, 'Badminton': 180, 'Tennis': 120},
      ),
    ];
    allPlayers.assignAll(sampleDocs);
    _refilterAndRank();
  }
}
