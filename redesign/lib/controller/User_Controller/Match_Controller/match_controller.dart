import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:redesign/shared_preferences/userPreferences.dart';
import 'package:redesign/view/USER/Play/play/play_models.dart';
import 'package:redesign/controller/maps_controller.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/utils/slot_overlap_helper.dart';
import 'package:redesign/services/xp_reward_service.dart';

enum MatchSortOption {
  timeAsc,
  timeDesc,
  distanceAsc,
  distanceDesc,
  priceAsc,
  priceDesc,
}

class MatchController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final RxList<GameData> allMatches = <GameData>[].obs;
  final RxBool isLoading = true.obs;

  // Filters & Sorting State
  final RxString selectedSport = 'All'.obs;
  final Rxn<DateTime> selectedDate = Rxn<DateTime>();
  final Rx<MatchSortOption> sortOption = MatchSortOption.timeAsc.obs;
  final RxDouble distanceRadiusKm = 50.0.obs; // Default 50km surrounding radius

  StreamSubscription<QuerySnapshot>? _matchesSub;

  @override
  void onInit() {
    super.onInit();
    selectedDate.value = DateTime.now();
    startListeningMatches();
  }

  @override
  void onClose() {
    _matchesSub?.cancel();
    super.onClose();
  }

  void startListeningMatches() {
    isLoading.value = true;
    _matchesSub?.cancel();

    _matchesSub = _firestore
        .collection('matches')
        .snapshots()
        .listen(
          (snapshot) {
            final docs = snapshot.docs
                .map((doc) => GameData.fromFirestore(doc))
                .toList();
            docs.sort((a, b) {
              final dateA = a.createdAt ?? DateTime.now();
              final dateB = b.createdAt ?? DateTime.now();
              return dateB.compareTo(dateA);
            });
            allMatches.value = docs;
            isLoading.value = false;
            debugPrint(
              '📥 [MatchController] Fetched ${docs.length} matches from Firestore.',
            );
          },
          onError: (err) {
            debugPrint('⚠️ Error fetching matches: $err');
            isLoading.value = false;
          },
        );
  }

  /// Distance calculation using Haversine Formula (returns km)
  double _calculateDistanceKm(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    if (lat1 == 0 || lon1 == 0 || lat2 == 0 || lon2 == 0) return 1.0;
    const p = 0.017453292519943295; // Math.PI / 180
    final a =
        0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a)); // 2 * R; R = 6371 km
  }

  /// Computed filtered and sorted match list
  List<GameData> get filteredMatches {
    final mapsCtrl = Get.isRegistered<MapsController>()
        ? Get.find<MapsController>()
        : null;
    final userLat = mapsCtrl?.currentLocation.value?.lat ?? 0.0;
    final userLng = mapsCtrl?.currentLocation.value?.lng ?? 0.0;

    var result = List<GameData>.from(allMatches);

    // 1. Sport Filter
    if (selectedSport.value != 'All' && selectedSport.value.isNotEmpty) {
      result = result
          .where(
            (m) => m.sport.toLowerCase() == selectedSport.value.toLowerCase(),
          )
          .toList();
    }

    // 2. Filter out past day matches & apply Date Filter
    final now = DateTime.now();
    final todayMidnight = DateTime(now.year, now.month, now.day);

    result = result.where((m) {
      final parsed = GameData.parseDate(m.date) ?? m.createdAt;
      if (parsed != null) {
        final matchMidnight = DateTime(parsed.year, parsed.month, parsed.day);
        if (matchMidnight.isBefore(todayMidnight)) {
          return false; // Exclude past day matches
        }
      }
      return true;
    }).toList();

    if (selectedDate.value != null) {
      final target = selectedDate.value!;
      final targetMidnight = DateTime(target.year, target.month, target.day);

      result = result.where((m) {
        final parsed = GameData.parseDate(m.date) ?? m.createdAt;
        if (parsed != null) {
          final matchMidnight = DateTime(parsed.year, parsed.month, parsed.day);
          return matchMidnight.isAtSameMomentAs(targetMidnight);
        }
        return false; // Exclude matches that do not match the target selected date
      }).toList();
    }

    // 3. Distance Radius Filter
    if (userLat != 0.0 && userLng != 0.0) {
      result = result.where((m) {
        if (m.latitude == 0.0 || m.longitude == 0.0) return true;
        final dist = _calculateDistanceKm(
          userLat,
          userLng,
          m.latitude,
          m.longitude,
        );
        return dist <= distanceRadiusKm.value;
      }).toList();
    }

    // 4. Sorting
    result.sort((a, b) {
      switch (sortOption.value) {
        case MatchSortOption.timeAsc:
          return (a.time).compareTo(b.time);
        case MatchSortOption.timeDesc:
          return (b.time).compareTo(a.time);
        case MatchSortOption.distanceAsc:
          final distA = (userLat != 0.0 && userLng != 0.0 && a.latitude != 0.0)
              ? _calculateDistanceKm(userLat, userLng, a.latitude, a.longitude)
              : 1.0;
          final distB = (userLat != 0.0 && userLng != 0.0 && b.latitude != 0.0)
              ? _calculateDistanceKm(userLat, userLng, b.latitude, b.longitude)
              : 1.0;
          return distA.compareTo(distB);
        case MatchSortOption.distanceDesc:
          final distA = (userLat != 0.0 && userLng != 0.0 && a.latitude != 0.0)
              ? _calculateDistanceKm(userLat, userLng, a.latitude, a.longitude)
              : 1.0;
          final distB = (userLat != 0.0 && userLng != 0.0 && b.latitude != 0.0)
              ? _calculateDistanceKm(userLat, userLng, b.latitude, b.longitude)
              : 1.0;
          return distB.compareTo(distA);
        case MatchSortOption.priceAsc:
          return a.priceNum.compareTo(b.priceNum);
        case MatchSortOption.priceDesc:
          return b.priceNum.compareTo(a.priceNum);
      }
    });

    return result;
  }

  /// Create a new match in Firestore
  Future<bool> createMatch(Map<String, dynamic> matchMap) async {
    try {
      final docRef = _firestore.collection('matches').doc();
      matchMap['id'] = docRef.id;
      matchMap['createdAt'] = FieldValue.serverTimestamp();
      await docRef.set(matchMap);

      final hostId = matchMap['hostId'] as String?;
      if (hostId != null && hostId.isNotEmpty) {
        await _firestore.collection('User').doc(hostId).set({
          'gameStats': {
            'totalGamesPlayed': FieldValue.increment(1),
            'totalHosted': FieldValue.increment(1),
            'xpPoints': FieldValue.increment(100),
            'lastUpdated': FieldValue.serverTimestamp(),
          },
        }, SetOptions(merge: true));
      }

      return true;
    } catch (e) {
      debugPrint('🔴 Error creating match: $e');
      Get.snackbar(
        'Match Creation Failed',
        'Could not create match poll: $e',
        backgroundColor: AppColors.card,
        colorText: Colors.white,
      );
      return false;
    }
  }

  /// Join a match poll (Enforces: player can join ONLY ONCE and host is already included)
  Future<bool> joinMatchPoll({
    required String matchId,
    required String userId,
    required double pricePaid,
    String? paymentId,
  }) async {
    try {
      final docRef = _firestore.collection('matches').doc(matchId);
      final docSnap = await docRef.get();
      if (!docSnap.exists) return false;

      final data = docSnap.data()!;
      final List<dynamic> playerIds = List<dynamic>.from(
        data['playerIds'] ?? [],
      );

      // Prevent duplicate joins
      if (playerIds.contains(userId)) {
        Get.snackbar(
          'Already Joined',
          'You are already included in this match poll.',
          backgroundColor: AppColors.card,
          colorText: Colors.white,
        );
        return false;
      }

      final int currentPlayers = (data['currentPlayers'] ?? 1) + 1;
      final double collectedAmount =
          ((data['collectedAmount'] ?? 0.0) as num).toDouble() + pricePaid;
      final int maxPlayers = (data['maxPlayers'] as num?)?.toInt() ?? 10;
      final double targetAmount = ((data['targetAmount'] ?? 0.0) as num)
          .toDouble();
      final bool isAlreadySlotBooked = data['isSlotBooked'] == true;
      final String locationType = (data['locationType'] ?? 'custom').toString();

      playerIds.add(userId);

      await docRef.update({
        'playerIds': playerIds,
        'currentPlayers': currentPlayers,
        'collectedAmount': collectedAmount,
      });

      final matchSport = (data['sport'] ?? 'Football').toString();

      // Award +50 XP for joining match poll (stored in per-sport & missions/rewards counters)
      await XpRewardService.awardBookingXp(
        userDocId: userId,
        sport: matchSport,
        xpAmount: 50,
      );

      // Auto-book check if all players joined & paid for PlayZ Turfs
      final bool isPollComplete =
          (currentPlayers >= maxPlayers) ||
          (targetAmount > 0 && collectedAmount >= targetAmount);

      if (isPollComplete) {
        // Award +50 XP to all poll members upon successful poll completion & payment
        await XpRewardService.awardPollCompletionXp(
          playerIds: playerIds.map((e) => e.toString()).toList(),
          sport: matchSport,
          xpAmount: 50,
        );
      }

      if (locationType == 'playz_turf' &&
          isPollComplete &&
          !isAlreadySlotBooked) {
        final turfId = (data['turfId'] ?? '').toString();
        final groundId = (data['groundId'] ?? '').toString();
        final ownerId = (data['ownerId'] ?? '').toString();
        final dateStr = (data['date'] ?? '').toString();
        final timeStr = (data['time'] ?? '').toString();
        final slotId = (data['slotId'] ?? '').toString();

        final parts = timeStr.split(',');
        final timeOnly = parts.length > 1 ? parts.last.trim() : timeStr;

        if (turfId.isNotEmpty && groundId.isNotEmpty && dateStr.isNotEmpty) {
          final isOverlapping =
              await SlotOverlapHelper.isSlotOverlappingInFirestore(
                ownerId: ownerId,
                turfId: turfId,
                groundId: groundId,
                dateStr: dateStr,
                newTimeRangeStr: timeOnly,
                currentMatchId: matchId,
              );

          if (!isOverlapping) {
            // NO CONFLICT: Auto-book slot in Firestore immediately
            final String finalOwnerId = ownerId.isNotEmpty
                ? ownerId
                : 'owner_$turfId';

            final bookingId = 'PLZ_MATCH_${DateTime.now().millisecondsSinceEpoch}';
            final otp = (100000 + Random().nextInt(900000)).toString();
            final hostDocId = (data['hostId'] ?? data['createdBy'] ?? data['userDocId'] ?? '').toString();

            final rawPayload = jsonEncode({
              'bookingId': bookingId,
              'otp': otp,
              'turfId': turfId,
              'groundId': groundId,
              'date': dateStr,
              'timeSlot': timeOnly,
              'timestamp': DateTime.now().toIso8601String(),
            });
            final encodedQrText = 'PZSEC_${base64Encode(utf8.encode(rawPayload))}';

            final bookingMap = {
              'id': bookingId,
              'bookingId': bookingId,
              'otp': otp,
              'qrData': encodedQrText,
              'userId': hostDocId,
              'ownerId': finalOwnerId,
              'turfId': turfId,
              'turfName': data['turfName'] ?? data['venue'] ?? 'Booked Turf',
              'turfAddress': data['address'] ?? data['locality'] ?? '',
              'groundId': groundId,
              'groundName': 'Main Ground',
              'sport': data['sport'] ?? 'Football',
              'date': dateStr,
              'dateFormatted': dateStr,
              'time': timeOnly,
              'timeSlot': timeOnly,
              'slotId': slotId,
              'status': 'upcoming',
              'bookingType': 'Match Poll Booking',
              'createdAt': FieldValue.serverTimestamp(),
            };

            final batch = _firestore.batch();
            final ownerTurfRef = _firestore
                .collection('owners')
                .doc(finalOwnerId)
                .collection('turfs')
                .doc(turfId)
                .collection('bookings')
                .doc(bookingId);
            batch.set(ownerTurfRef, bookingMap, SetOptions(merge: true));

            final ownerRef = _firestore
                .collection('owners')
                .doc(finalOwnerId)
                .collection('bookings')
                .doc(bookingId);
            batch.set(ownerRef, bookingMap, SetOptions(merge: true));

            if (hostDocId.isNotEmpty) {
              final userBookingRef = _firestore
                  .collection('User')
                  .doc(hostDocId)
                  .collection('bookings')
                  .doc(bookingId);
              batch.set(userBookingRef, bookingMap, SetOptions(merge: true));
            }
            await batch.commit();

            final players = List<String>.from(data['playerIds'] ?? []);
            final matchSport = (data['sport'] ?? 'Football').toString();
            if (players.isNotEmpty) {
              await XpRewardService.awardPollCompletionXp(
                playerIds: players,
                sport: matchSport,
                xpAmount: 50,
              );
            }

            await docRef.update({'isSlotBooked': true, 'hasConflict': false});

            Get.snackbar(
              'Poll Full & Slot Booked! ⚡',
              'All players joined and the turf slot has been automatically booked!',
              backgroundColor: AppColors.accent,
              colorText: Colors.black,
              snackPosition: SnackPosition.BOTTOM,
              duration: const Duration(seconds: 4),
            );
          } else {
            // CONFLICT DETECTED: Slot was booked by someone else
            await docRef.update({'hasConflict': true});

            Get.snackbar(
              'Poll Full — Slot Conflict! ⚠️',
              'All players joined, but the original slot was booked by another user. Host can change the slot.',
              backgroundColor: Colors.orangeAccent,
              colorText: Colors.black,
              snackPosition: SnackPosition.BOTTOM,
              duration: const Duration(seconds: 5),
            );
          }
        }
      } else {
        Get.snackbar(
          'Successfully Joined! ⚽',
          'You have joined the match poll!',
          backgroundColor: AppColors.accent,
          colorText: Colors.black,
          snackPosition: SnackPosition.BOTTOM,
        );
      }

      return true;
    } catch (e) {
      debugPrint('🔴 Error joining match poll: $e');
      return false;
    }
  }

  /// Host confirms slot booking once poll target amount is gathered
  Future<bool> confirmSlotBookingByHost({
    required String matchId,
    required String ownerId,
    required String turfId,
    required String groundId,
    required String groundName,
    required String dateStr,
    required String timeStr,
    String slotId = '',
  }) async {
    try {
      // 1. Check for overlapping slot booking in Firestore
      //    Pass currentMatchId so this poll doesn't self-block
      final isOverlapping =
          await SlotOverlapHelper.isSlotOverlappingInFirestore(
            ownerId: ownerId,
            turfId: turfId,
            groundId: groundId,
            dateStr: dateStr,
            newTimeRangeStr: timeStr,
            currentMatchId: matchId,
          );

      if (isOverlapping) {
        await _firestore.collection('matches').doc(matchId).update({
          'hasConflict': true,
        });

        Get.snackbar(
          'Slot Unavailable',
          'The slot ($timeStr) overlaps with an existing booking! Please select another date or time slot.',
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
          duration: const Duration(seconds: 4),
        );
        return false;
      }

      // 2. Add booking record under turf owner & under host User collection
      final bookingId = 'PLZ_MATCH_${DateTime.now().millisecondsSinceEpoch}';
      final otp = (100000 + Random().nextInt(900000)).toString();

      final matchDoc = await _firestore.collection('matches').doc(matchId).get();
      final matchData = matchDoc.exists ? (matchDoc.data() ?? {}) : {};

      final hostUserId = (matchData['hostId'] ?? matchData['createdBy'] ?? matchData['userDocId'] ?? '').toString();
      final hostEmail = (matchData['hostEmail'] ?? '').toString();
      final targetUserDocId = hostUserId.isNotEmpty ? hostUserId : (hostEmail.isNotEmpty ? hostEmail : null);

      final rawPayload = jsonEncode({
        'bookingId': bookingId,
        'otp': otp,
        'turfId': turfId,
        'groundId': groundId,
        'date': dateStr,
        'timeSlot': timeStr,
        'timestamp': DateTime.now().toIso8601String(),
      });
      final encodedQrText = 'PZSEC_${base64Encode(utf8.encode(rawPayload))}';

      final bookingMap = {
        'id': bookingId,
        'bookingId': bookingId,
        'otp': otp,
        'qrData': encodedQrText,
        'userId': targetUserDocId ?? '',
        'ownerId': ownerId,
        'turfId': turfId,
        'turfName': matchData['turfName'] ?? matchData['venue'] ?? 'Booked Turf',
        'turfAddress': matchData['address'] ?? matchData['locality'] ?? '',
        'groundId': groundId,
        'groundName': groundName,
        'sport': matchData['sport'] ?? 'Football',
        'date': dateStr,
        'dateFormatted': dateStr,
        'time': timeStr,
        'timeSlot': timeStr,
        'slotId': slotId,
        'amount': (matchData['priceNum'] as num?)?.toInt() ?? 0,
        'status': 'upcoming',
        'bookingType': 'Match Poll Booking',
        'matchId': matchId,
        'createdAt': FieldValue.serverTimestamp(),
      };

      final batch = _firestore.batch();

      final ownerTurfRef = _firestore
          .collection('owners')
          .doc(ownerId)
          .collection('turfs')
          .doc(turfId)
          .collection('bookings')
          .doc(bookingId);
      batch.set(ownerTurfRef, bookingMap, SetOptions(merge: true));

      final ownerRef = _firestore
          .collection('owners')
          .doc(ownerId)
          .collection('bookings')
          .doc(bookingId);
      batch.set(ownerRef, bookingMap, SetOptions(merge: true));

      if (targetUserDocId != null && targetUserDocId.isNotEmpty) {
        final userBookingRef = _firestore
            .collection('User')
            .doc(targetUserDocId)
            .collection('bookings')
            .doc(bookingId);
        batch.set(userBookingRef, bookingMap, SetOptions(merge: true));
      }

      await batch.commit();

      // 3. Mark match poll as slot booked & conflict resolved
      await _firestore.collection('matches').doc(matchId).update({
        'isSlotBooked': true,
        'hasConflict': false,
      });

      // 4. Award +50 XP to all players in the poll
      if (matchDoc.exists && matchData.isNotEmpty) {
        final players = List<String>.from(matchData['playerIds'] ?? []);
        final matchSport = (matchData['sport'] ?? 'Football').toString();
        await XpRewardService.awardPollCompletionXp(
          playerIds: players,
          sport: matchSport,
          xpAmount: 50,
        );
      }

      Get.snackbar(
        'Slot Booked! ⚡',
        'Turf slot has been successfully booked for your match poll!',
        backgroundColor: AppColors.accent,
        colorText: Colors.black,
        snackPosition: SnackPosition.BOTTOM,
      );

      return true;
    } catch (e) {
      debugPrint('🔴 Error confirming turf slot booking: $e');
      return false;
    }
  }

  /// Host selects a new available slot/date if the original slot was already booked
  Future<bool> changeMatchSlotByHost({
    required String matchId,
    required String ownerId,
    required String turfId,
    required String groundId,
    required String groundName,
    required String newDateStr,
    required String newTimeStr,
    String newSlotId = '',
    double? newTurfCost,
    String? paymentId,
  }) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      final userDocId =
          await UserPreferences.getDocId() ??
          user?.email ??
          user?.uid ??
          'unknown_user';

      // 1. Check for overlapping bookings on the new slot
      final isOverlapping =
          await SlotOverlapHelper.isSlotOverlappingInFirestore(
            ownerId: ownerId,
            turfId: turfId,
            groundId: groundId,
            dateStr: newDateStr,
            newTimeRangeStr: newTimeStr,
            currentMatchId: matchId,
          );

      if (isOverlapping) {
        Get.snackbar(
          'Slot Unavailable',
          'The selected slot ($newTimeStr) overlaps with an existing booking! Please choose another slot.',
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
          duration: const Duration(seconds: 4),
        );
        return false;
      }

      final bookingId =
          'PLZ_RESCHEDULE_${DateTime.now().millisecondsSinceEpoch}';
      final otp = (100000 + Random().nextInt(900000)).toString();

      final rawPayload = jsonEncode({
        'bookingId': bookingId,
        'otp': otp,
        'turfId': turfId,
        'groundId': groundId,
        'date': newDateStr,
        'timeSlot': newTimeStr,
        'timestamp': DateTime.now().toIso8601String(),
      });

      final encodedQrText = 'PZSEC_${base64Encode(utf8.encode(rawPayload))}';

      final bookingData = {
        'id': bookingId,
        'bookingId': bookingId,
        'otp': otp,
        'qrData': encodedQrText,
        'turfId': turfId,
        'groundId': groundId,
        'groundName': groundName,
        'date': newDateStr,
        'timeSlot': newTimeStr,
        'time': newTimeStr,
        'slotId': newSlotId,
        'status': 'confirmed',
        'createdAt': FieldValue.serverTimestamp(),
        'bookingType': 'match_poll_rescheduled',
        'paymentId':
            paymentId ?? 'DEV_PASS_${DateTime.now().millisecondsSinceEpoch}',
        'amount': (newTurfCost ?? 0.0).toInt(),
        'userEmail': user?.email ?? '',
        'userName': user?.displayName ?? 'Host Player',
        'userPhone': user?.phoneNumber ?? 'N/A',
      };

      final batch = _firestore.batch();

      final ownerRef = _firestore
          .collection('owners')
          .doc(ownerId)
          .collection('turfs')
          .doc(turfId)
          .collection('bookings')
          .doc(bookingId);
      batch.set(ownerRef, bookingData, SetOptions(merge: true));

      final userRef = _firestore
          .collection('User')
          .doc(userDocId)
          .collection('bookings')
          .doc(bookingId);
      batch.set(userRef, bookingData, SetOptions(merge: true));

      // 3. Update match poll document
      final updateData = <String, dynamic>{
        'time': '$newDateStr, $newTimeStr',
        'date': newDateStr,
        'slotId': newSlotId,
        'isSlotBooked': true,
        'hasConflict': false,
      };

      if (newTurfCost != null && newTurfCost > 0) {
        updateData['turfSlotCost'] = newTurfCost;
        updateData['targetAmount'] = newTurfCost;
      }

      final matchRef = _firestore.collection('matches').doc(matchId);
      batch.update(matchRef, updateData);

      await batch.commit();

      Get.snackbar(
        'Slot Rescheduled & Booked! ⚽',
        'New time slot $newDateStr ($newTimeStr) has been booked!',
        backgroundColor: AppColors.accent,
        colorText: Colors.black,
        snackPosition: SnackPosition.BOTTOM,
      );

      return true;
    } catch (e) {
      debugPrint('🔴 Error updating match slot: $e');
      return false;
    }
  }

  /// Delete a match poll before it gets full (Host only)
  Future<bool> deleteMatchPoll(String matchId) async {
    try {
      await _firestore.collection('matches').doc(matchId).delete();
      Get.snackbar(
        'Match Poll Deleted',
        'Your match poll has been deleted.',
        backgroundColor: AppColors.card,
        colorText: AppColors.textPrimary,
        snackPosition: SnackPosition.BOTTOM,
      );
      return true;
    } catch (e) {
      debugPrint('🔴 Error deleting match poll: $e');
      Get.snackbar(
        'Delete Failed',
        'Could not delete match poll: $e',
        backgroundColor: AppColors.card,
        colorText: AppColors.textPrimary,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
  }

  /// Delete match entry from history (Host deletes match doc, player leaves match or removes record)
  Future<bool> deleteMatchFromHistory(String matchId, String userDocId) async {
    try {
      final docRef = _firestore.collection('matches').doc(matchId);
      final docSnap = await docRef.get();

      if (docSnap.exists) {
        final data = docSnap.data();
        final hostId = data?['hostId'] as String?;
        final List<dynamic> playerIds = List<dynamic>.from(
          data?['playerIds'] ?? [],
        );

        if (hostId == userDocId || playerIds.length <= 1) {
          // User is host or sole player: delete entire match document from Firestore
          await docRef.delete();
        } else {
          // User is participant: remove user ID from playerIds in Firestore
          await docRef.update({
            'playerIds': FieldValue.arrayRemove([userDocId]),
          });
        }
      }

      // Remove locally from allMatches list
      allMatches.removeWhere((m) => m.id == matchId);
      allMatches.refresh();

      // Update user stats in Firebase
      if (userDocId.isNotEmpty) {
        await _firestore.collection('User').doc(userDocId).set({
          'gameStats': {
            'totalGamesPlayed': FieldValue.increment(-1),
            'lastUpdated': FieldValue.serverTimestamp(),
          },
        }, SetOptions(merge: true));
      }

      return true;
    } catch (e) {
      debugPrint('🔴 [MatchController] Error deleting match history: $e');
      Get.snackbar(
        'Delete Failed',
        'Could not delete match entry: $e',
        backgroundColor: AppColors.card,
        colorText: AppColors.textPrimary,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
  }
}
