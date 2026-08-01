import 'package:cloud_firestore/cloud_firestore.dart' hide Type;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:redesign/shared_preferences/userPreferences.dart';
import 'package:redesign/controller/user_profile_controller.dart';
import 'package:redesign/theme/app_colors.dart';

class XpRewardService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> _refreshProfileIfCurrentUser(String targetUserDocId) async {
    try {
      final storedDocId = await UserPreferences.getDocId();
      final authUser = FirebaseAuth.instance.currentUser;
      final isCurrentUser = targetUserDocId == storedDocId ||
          targetUserDocId == authUser?.email ||
          targetUserDocId == authUser?.uid;

      if (isCurrentUser && Get.isRegistered<UserProfileController>()) {
        Get.find<UserProfileController>().fetchUserProfile(targetUserDocId);
      }
    } catch (_) {}
  }

  /// Sanitizes a sport string into a valid Firestore map key (e.g. "Cricket" -> "cricket").
  static String formatSportKey(String sport) {
    final clean = sport.trim().toLowerCase().replaceAll(' ', '_');
    return clean.isNotEmpty ? clean : 'general';
  }

  /// Inspects a user's `bookings` subcollection in Firestore and backfills any missing per-sport XPs
  /// into `sportsXp.{sportKey}` on the main User document.
  static Future<Map<String, int>> syncUserSportXpFromBookings(String userDocId) async {
    try {
      if (userDocId.isEmpty) return {};

      final bookingsSnap = await _firestore
          .collection('User')
          .doc(userDocId)
          .collection('bookings')
          .get();

      final userDoc = await _firestore.collection('User').doc(userDocId).get();
      final userData = userDoc.data() ?? {};
      final existingSportsXp = (userData['sportsXp'] as Map<String, dynamic>?) ?? {};

      final Map<String, int> bookingCounts = {};
      for (final doc in bookingsSnap.docs) {
        final bData = doc.data();
        final rawSport = (bData['sport'] ?? bData['selectedSport'] ?? '').toString().trim();
        if (rawSport.isNotEmpty) {
          final sportKey = formatSportKey(rawSport);
          bookingCounts[sportKey] = (bookingCounts[sportKey] ?? 0) + 1;
        }
      }

      final updates = <String, dynamic>{};
      final Map<String, int> syncedSportXp = {};

      bookingCounts.forEach((sportKey, count) {
        final calculatedXp = count * 50;
        final currentXp = (existingSportsXp[sportKey] as num?)?.toInt() ?? 0;
        if (calculatedXp > currentXp) {
          updates['sportsXp.$sportKey'] = calculatedXp;
          updates['gameStats.sportsXp.$sportKey'] = calculatedXp;
          syncedSportXp[sportKey] = calculatedXp;
        } else {
          syncedSportXp[sportKey] = currentXp;
        }
      });

      // Preserve all existing sport XPs
      existingSportsXp.forEach((key, val) {
        if (val is num && val > 0) {
          final current = syncedSportXp[key] ?? 0;
          if (val.toInt() > current) {
            syncedSportXp[key] = val.toInt();
          }
        }
      });

      if (updates.isNotEmpty) {
        await _firestore.collection('User').doc(userDocId).set(updates, SetOptions(merge: true));
        debugPrint('⚡ [XpRewardService] Synced sport XP from bookings for $userDocId: $updates');
      }

      return syncedSportXp;
    } catch (e) {
      debugPrint('🔴 [XpRewardService] Error syncing sport XP from bookings: $e');
      return {};
    }
  }

  /// Award XP for a successful slot booking, poll completion, or tournament event.
  /// Updates:
  /// - `xpPoints` (overall counter)
  /// - `missionsRewardsXp` (special missions & rewards counter)
  /// - `sportsXp.{sportKey}` (separate per-sport counter)
  /// - Nested `gameStats` equivalents for backwards compatibility.
  static Future<void> awardBookingXp({
    String? userDocId,
    required String sport,
    int xpAmount = 50,
  }) async {
    try {
      final docId = userDocId ?? await UserPreferences.getDocId();
      if (docId == null || docId.isEmpty) {
        debugPrint('⚠️ [XpRewardService] Empty docId, skipping XP award.');
        return;
      }

      final sportKey = formatSportKey(sport);

      // Fetch current XP to update Tier accurately
      final userDoc = await _firestore.collection('User').doc(docId).get();
      final currentXp = (userDoc.data()?['xpPoints'] as num?)?.toInt() ?? 100;
      final newXp = currentXp + xpAmount;
      final newTier = TierHelper.getTierFromXp(newXp);

      final updates = <String, dynamic>{
        'xpPoints': FieldValue.increment(xpAmount),
        'tier': newTier,
        'sportsXp.$sportKey': FieldValue.increment(xpAmount),
        'gameStats.xpPoints': FieldValue.increment(xpAmount),
        'gameStats.sportsXp.$sportKey': FieldValue.increment(xpAmount),
        'lastXpUpdated': FieldValue.serverTimestamp(),
      };

      await _firestore.collection('User').doc(docId).set(updates, SetOptions(merge: true));

      debugPrint('⚡ [XpRewardService] Awarded +$xpAmount XP for sport "$sportKey" to user: $docId');

      await _refreshProfileIfCurrentUser(docId);
    } catch (e) {
      debugPrint('🔴 [XpRewardService] Error awarding XP: $e');
    }
  }

  /// Award +5 XP for joining or creating a group, GUARANTEED ONLY ONCE per groupId.
  /// Prevents loophole where user leaves and re-joins same group to farm XP.
  static Future<void> awardGroupXpOnce({
    required String userDocId,
    required String groupId,
    int xpAmount = 5,
  }) async {
    try {
      if (userDocId.isEmpty || groupId.isEmpty) return;

      final userRef = _firestore.collection('User').doc(userDocId);
      final userDoc = await userRef.get();
      if (!userDoc.exists) return;

      final userData = userDoc.data() ?? {};
      final List rewardedGroups = userData['rewardedGroupIds'] as List<dynamic>? ?? [];

      // Check if user has ALREADY received XP for this group
      if (rewardedGroups.contains(groupId)) {
        debugPrint('ℹ️ [XpRewardService] User $userDocId already received XP for group $groupId.');
        return;
      }

      // Add groupId to rewardedGroupIds array & increment XP
      final currentXp = (userData['xpPoints'] as num?)?.toInt() ?? 100;
      final newXp = currentXp + xpAmount;
      final newTier = TierHelper.getTierFromXp(newXp);

      await userRef.set({
        'xpPoints': FieldValue.increment(xpAmount),
        'missionsRewardsXp': FieldValue.increment(xpAmount),
        'rewardedGroupIds': FieldValue.arrayUnion([groupId]),
        'tier': newTier,
        'gameStats.xpPoints': FieldValue.increment(xpAmount),
        'gameStats.missionsRewardsXp': FieldValue.increment(xpAmount),
        'lastXpUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      debugPrint('⚡ [XpRewardService] Awarded +$xpAmount XP to $userDocId for group $groupId (Once-only).');

      await _refreshProfileIfCurrentUser(userDocId);
    } catch (e) {
      debugPrint('🔴 [XpRewardService] Error awarding group XP: $e');
    }
  }

  /// Award +2 XP for adding a friend, GUARANTEED ONLY ONCE per target friend user ID.
  /// Prevents loophole where users unfriend and re-friend to farm XP.
  static Future<void> awardFriendXpOnce({
    required String userDocId,
    required String friendUserId,
    int xpAmount = 2,
  }) async {
    try {
      if (userDocId.isEmpty || friendUserId.isEmpty) return;

      final userRef = _firestore.collection('User').doc(userDocId);
      final userDoc = await userRef.get();
      if (!userDoc.exists) return;

      final userData = userDoc.data() ?? {};
      final List rewardedFriends = userData['rewardedFriendUserIds'] as List<dynamic>? ?? [];

      // Check if user has ALREADY received XP for this friend
      if (rewardedFriends.contains(friendUserId)) {
        debugPrint('ℹ️ [XpRewardService] User $userDocId already received XP for friend $friendUserId.');
        return;
      }

      // Add friendUserId to rewardedFriendUserIds array & increment XP
      final currentXp = (userData['xpPoints'] as num?)?.toInt() ?? 100;
      final newXp = currentXp + xpAmount;
      final newTier = TierHelper.getTierFromXp(newXp);

      await userRef.set({
        'xpPoints': FieldValue.increment(xpAmount),
        'missionsRewardsXp': FieldValue.increment(xpAmount),
        'rewardedFriendUserIds': FieldValue.arrayUnion([friendUserId]),
        'tier': newTier,
        'gameStats.xpPoints': FieldValue.increment(xpAmount),
        'gameStats.missionsRewardsXp': FieldValue.increment(xpAmount),
        'lastXpUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      debugPrint('⚡ [XpRewardService] Awarded +$xpAmount XP to $userDocId for friend $friendUserId (Once-only).');

      await _refreshProfileIfCurrentUser(userDocId);
    } catch (e) {
      debugPrint('🔴 [XpRewardService] Error awarding friend XP: $e');
    }
  }

  /// Award XP (+50 by default) to all players in a completed match poll.
  static Future<void> awardPollCompletionXp({
    required List<String> playerIds,
    required String sport,
    int xpAmount = 50,
  }) async {
    final uniqueIds = playerIds.where((id) => id.isNotEmpty).toSet();
    for (final id in uniqueIds) {
      await awardBookingXp(
        userDocId: id,
        sport: sport,
        xpAmount: xpAmount,
      );
    }
  }

  /// Award 100 XP to every participant in a tournament for that specific sport.
  static Future<void> awardTournamentParticipantXp({
    required List<String> playerIds,
    required String sport,
    int xpAmount = 100,
  }) async {
    final uniqueIds = playerIds.where((id) => id.isNotEmpty).toSet();
    for (final id in uniqueIds) {
      await awardBookingXp(
        userDocId: id,
        sport: sport,
        xpAmount: xpAmount,
      );
    }
  }

  /// Award XP to tournament ranked teams ONLY after the final round is completed
  /// and the tournament status is set to 'completed':
  /// - 1st Rank (Winner) team players -> +200 XP each
  /// - 2nd Rank (Runner-up) team players -> +100 XP each
  /// Sets `areRankXpAwarded: true` in Firestore to guarantee single execution.
  static Future<void> awardTournamentRankingsXp({
    required String tournamentId,
    required String winnerTeamId,
    required String runnerUpTeamId,
    required String sport,
  }) async {
    try {
      if (tournamentId.isEmpty) return;

      final tourneyRef = _firestore.collection('tournaments').doc(tournamentId);
      final tourneyDoc = await tourneyRef.get();
      if (!tourneyDoc.exists) return;

      final data = tourneyDoc.data()!;
      final status = (data['status'] ?? '').toString().toLowerCase();
      final bool alreadyAwarded = data['areRankXpAwarded'] == true;

      // Ensure tournament status is completed (final round done)
      if (status != 'completed') {
        debugPrint('ℹ️ [XpRewardService] Tournament $tournamentId status is "$status" (not completed). Rank XP will be awarded once tournament is completed.');
        return;
      }

      // Guard against duplicate execution
      if (alreadyAwarded) {
        debugPrint('ℹ️ [XpRewardService] Tournament $tournamentId rank XP already awarded previously.');
        return;
      }

      // Flag as awarded in Firestore
      await tourneyRef.update({'areRankXpAwarded': true});

      final teamsRef = tourneyRef.collection('teams');

      List<String> winnerPlayerIds = [];
      List<String> runnerUpPlayerIds = [];

      if (winnerTeamId.isNotEmpty && winnerTeamId != 'TBD') {
        final winnerDoc = await teamsRef.doc(winnerTeamId).get();
        if (winnerDoc.exists && winnerDoc.data() != null) {
          final players = winnerDoc.data()!['players'] as List<dynamic>? ?? [];
          winnerPlayerIds = players
              .map((p) => (p['userId'] ?? '').toString())
              .where((id) => id.isNotEmpty)
              .toList();

          if (winnerPlayerIds.isEmpty) {
            final regBy = (winnerDoc.data()!['registeredBy'] ?? '').toString();
            if (regBy.isNotEmpty) winnerPlayerIds.add(regBy);
          }
        }
      }

      if (runnerUpTeamId.isNotEmpty && runnerUpTeamId != 'TBD') {
        final runnerDoc = await teamsRef.doc(runnerUpTeamId).get();
        if (runnerDoc.exists && runnerDoc.data() != null) {
          final players = runnerDoc.data()!['players'] as List<dynamic>? ?? [];
          runnerUpPlayerIds = players
              .map((p) => (p['userId'] ?? '').toString())
              .where((id) => id.isNotEmpty)
              .toList();

          if (runnerUpPlayerIds.isEmpty) {
            final regBy = (runnerDoc.data()!['registeredBy'] ?? '').toString();
            if (regBy.isNotEmpty) runnerUpPlayerIds.add(regBy);
          }
        }
      }

      // Award +200 XP to 1st Rank (Winner) team players
      for (final userId in winnerPlayerIds.toSet()) {
        await awardBookingXp(
          userDocId: userId,
          sport: sport,
          xpAmount: 200,
        );
      }

      // Award +100 XP to 2nd Rank (Runner-up) team players
      for (final userId in runnerUpPlayerIds.toSet()) {
        await awardBookingXp(
          userDocId: userId,
          sport: sport,
          xpAmount: 100,
        );
      }

      debugPrint('🏆 [XpRewardService] Tournament $tournamentId FINALLY COMPLETED! Rankings XP awarded: 1st ($winnerTeamId: +200 XP), 2nd ($runnerUpTeamId: +100 XP)');
    } catch (e) {
      debugPrint('🔴 [XpRewardService] Error awarding tournament rankings XP: $e');
    }
  }
}
