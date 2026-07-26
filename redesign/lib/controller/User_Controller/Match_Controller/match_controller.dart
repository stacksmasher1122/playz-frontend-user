import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:redesign/view/USER/Play/play/play_models.dart';
import 'package:redesign/controller/maps_controller.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/utils/slot_overlap_helper.dart';

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
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((snapshot) {
      final docs = snapshot.docs.map((doc) => GameData.fromFirestore(doc)).toList();
      allMatches.value = docs;
      isLoading.value = false;
    }, onError: (err) {
      debugPrint('⚠️ Error fetching matches: $err');
      isLoading.value = false;
    });
  }

  /// Distance calculation using Haversine Formula (returns km)
  double _calculateDistanceKm(double lat1, double lon1, double lat2, double lon2) {
    if (lat1 == 0 || lon1 == 0 || lat2 == 0 || lon2 == 0) return 1.0;
    const p = 0.017453292519943295; // Math.PI / 180
    final a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a)); // 2 * R; R = 6371 km
  }

  /// Computed filtered and sorted match list
  List<GameData> get filteredMatches {
    final mapsCtrl = Get.isRegistered<MapsController>() ? Get.find<MapsController>() : null;
    final userLat = mapsCtrl?.currentLocation.value?.lat ?? 0.0;
    final userLng = mapsCtrl?.currentLocation.value?.lng ?? 0.0;

    var result = List<GameData>.from(allMatches);

    // 1. Sport Filter
    if (selectedSport.value != 'All' && selectedSport.value.isNotEmpty) {
      result = result
          .where((m) => m.sport.toLowerCase() == selectedSport.value.toLowerCase())
          .toList();
    }

    // 2. Filter out past day matches & apply Date Filter
    final now = DateTime.now();
    final todayMidnight = DateTime(now.year, now.month, now.day);

    result = result.where((m) {
      if (m.date.isNotEmpty) {
        final parsed = DateTime.tryParse(m.date);
        if (parsed != null) {
          final matchMidnight = DateTime(parsed.year, parsed.month, parsed.day);
          if (matchMidnight.isBefore(todayMidnight)) {
            return false; // Exclude past day matches
          }
        }
      }
      return true;
    }).toList();

    if (selectedDate.value != null) {
      final target = selectedDate.value!;
      result = result.where((m) {
        if (m.date.isEmpty) return true;
        final parsed = DateTime.tryParse(m.date);
        if (parsed != null) {
          return parsed.year == target.year &&
              parsed.month == target.month &&
              parsed.day == target.day;
        }
        return true;
      }).toList();
    }

    // 3. Distance Radius Filter
    if (userLat != 0.0 && userLng != 0.0) {
      result = result.where((m) {
        if (m.latitude == 0.0 || m.longitude == 0.0) return true;
        final dist = _calculateDistanceKm(userLat, userLng, m.latitude, m.longitude);
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
      final List<dynamic> playerIds = List<dynamic>.from(data['playerIds'] ?? []);

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
      final double collectedAmount = ((data['collectedAmount'] ?? 0.0) as num).toDouble() + pricePaid;
      final int maxPlayers = (data['maxPlayers'] as num?)?.toInt() ?? 10;
      final double targetAmount = ((data['targetAmount'] ?? 0.0) as num).toDouble();
      final bool isAlreadySlotBooked = data['isSlotBooked'] == true;
      final String locationType = (data['locationType'] ?? 'custom').toString();

      playerIds.add(userId);

      await docRef.update({
        'playerIds': playerIds,
        'currentPlayers': currentPlayers,
        'collectedAmount': collectedAmount,
      });

      // Auto-book check if all players joined & paid for PlayZ Turfs
      final bool isPollComplete = (currentPlayers >= maxPlayers) || (targetAmount > 0 && collectedAmount >= targetAmount);

      if (locationType == 'playz_turf' && isPollComplete && !isAlreadySlotBooked) {
        final turfId = (data['turfId'] ?? '').toString();
        final groundId = (data['groundId'] ?? '').toString();
        final ownerId = (data['ownerId'] ?? '').toString();
        final dateStr = (data['date'] ?? '').toString();
        final timeStr = (data['time'] ?? '').toString();
        final slotId = (data['slotId'] ?? '').toString();

        final parts = timeStr.split(',');
        final timeOnly = parts.length > 1 ? parts.last.trim() : timeStr;

        if (turfId.isNotEmpty && groundId.isNotEmpty && dateStr.isNotEmpty) {
          final isOverlapping = await SlotOverlapHelper.isSlotOverlappingInFirestore(
            ownerId: ownerId,
            turfId: turfId,
            groundId: groundId,
            dateStr: dateStr,
            newTimeRangeStr: timeOnly,
            currentMatchId: matchId,
          );

          if (!isOverlapping) {
            // NO CONFLICT: Auto-book slot in Firestore immediately
            final String finalOwnerId = ownerId.isNotEmpty ? ownerId : 'owner_$turfId';
            await _firestore
                .collection('owners')
                .doc(finalOwnerId)
                .collection('turfs')
                .doc(turfId)
                .collection('bookings')
                .add({
              'turfId': turfId,
              'groundId': groundId,
              'groundName': 'Main Ground',
              'date': dateStr,
              'time': timeOnly,
              'slotId': slotId,
              'status': 'confirmed',
              'createdAt': FieldValue.serverTimestamp(),
              'bookingType': 'match_poll_auto_booked',
            });

            await docRef.update({
              'isSlotBooked': true,
              'hasConflict': false,
            });

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
            await docRef.update({
              'hasConflict': true,
            });

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
      final isOverlapping = await SlotOverlapHelper.isSlotOverlappingInFirestore(
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

      // 2. Add booking record under turf owner
      await _firestore
          .collection('owners')
          .doc(ownerId)
          .collection('turfs')
          .doc(turfId)
          .collection('bookings')
          .add({
        'turfId': turfId,
        'groundId': groundId,
        'groundName': groundName,
        'date': dateStr,
        'time': timeStr,
        'slotId': slotId,
        'status': 'confirmed',
        'createdAt': FieldValue.serverTimestamp(),
        'bookingType': 'match_poll_gathered_full',
      });

      // 3. Mark match poll as slot booked & conflict resolved
      await _firestore.collection('matches').doc(matchId).update({
        'isSlotBooked': true,
        'hasConflict': false,
      });

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
  }) async {
    try {
      // 1. Check for overlapping slot booking in Firestore
      //    Pass currentMatchId so this poll doesn't self-block
      final isOverlapping = await SlotOverlapHelper.isSlotOverlappingInFirestore(
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

      // 2. Add booking record under turf owner with new date/time
      await _firestore
          .collection('owners')
          .doc(ownerId)
          .collection('turfs')
          .doc(turfId)
          .collection('bookings')
          .add({
        'turfId': turfId,
        'groundId': groundId,
        'groundName': groundName,
        'date': newDateStr,
        'time': newTimeStr,
        'slotId': newSlotId,
        'status': 'confirmed',
        'createdAt': FieldValue.serverTimestamp(),
        'bookingType': 'match_poll_gathered_full',
      });

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
      }

      await _firestore.collection('matches').doc(matchId).update(updateData);

      Get.snackbar(
        'Slot Updated & Booked! ⚽',
        'New time slot $newDateStr, $newTimeStr has been booked!',
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
}
