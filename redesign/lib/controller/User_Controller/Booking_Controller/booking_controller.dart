import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:redesign/model/User_Models/Booking_Models/turf_model.dart';
import 'package:redesign/model/User_Models/Booking_Models/ground_model.dart';
import 'package:redesign/model/User_Models/Booking_Models/slot_model.dart';

class BookingController extends GetxController {
  final _firestore = FirebaseFirestore.instance;

  // ── Reactive State ──────────────────────────────────────────
  final isLoadingTurfs = false.obs;
  final isLoadingGrounds = false.obs;
  final isLoadingSlots = false.obs;

  final allTurfs = <TurfModel>[].obs;
  final filteredTurfs = <TurfModel>[].obs;
  final grounds = <GroundModel>[].obs;
  final slots = <SlotModel>[].obs;

  final selectedTurf = Rxn<TurfModel>();
  final selectedGround = Rxn<GroundModel>();
  final selectedSport = RxnString();

  // ── Lifecycle ───────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    fetchAllTurfs();
  }

  // ── Fetch All Turfs ─────────────────────────────────────────
  /// Uses a Firestore **collection group query** on `turfs`
  /// to fetch all verified, active turfs across all owners.
  Future<void> fetchAllTurfs() async {
    isLoadingTurfs.value = true;
    try {
      final snapshot = await _firestore.collectionGroup('turfs').get();

      final turfs = snapshot.docs
          .map((doc) => TurfModel.fromFirestore(doc))
          .where((t) => t.turfName.isNotEmpty && !t.isDeleted)
          .toList();

      // Fetch lowest ground price for each turf asynchronously
      await Future.wait(turfs.map((turf) => _fetchLowestPrice(turf)));

      allTurfs.value = turfs;
      filteredTurfs.value = turfs;
    } catch (e) {
      debugPrint('🔴 [BookingController] fetchAllTurfs error: $e');
      Get.snackbar(
        'Error',
        'Failed to load turfs: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoadingTurfs.value = false;
    }
  }

  /// Fetch the lowest defaultPrice from grounds subcollection
  Future<void> _fetchLowestPrice(TurfModel turf) async {
    try {
      QuerySnapshot groundsSnap;
      if (turf.ownerId.isNotEmpty) {
        groundsSnap = await _firestore
            .collection('owners')
            .doc(turf.ownerId)
            .collection('turfs')
            .doc(turf.id)
            .collection('grounds')
            .get();
      } else {
        groundsSnap = await _firestore.collectionGroup('grounds').get();
      }

      if (groundsSnap.docs.isNotEmpty) {
        final prices = groundsSnap.docs
            .map((doc) => GroundModel.fromFirestore(doc))
            .map((g) => g.defaultPrice)
            .where((p) => p > 0);
        if (prices.isNotEmpty) {
          turf.lowestPrice = prices.reduce((a, b) => a < b ? a : b);
        }
      }
    } catch (_) {
      // Silently fail — price will show fallback
    }
  }

  // ── Fetch Grounds for a Turf ────────────────────────────────
  Future<void> fetchTurfGrounds(String ownerId, String turfId) async {
    isLoadingGrounds.value = true;
    grounds.clear();
    selectedGround.value = null;
    slots.clear();

    try {
      QuerySnapshot snapshot;
      if (ownerId.isNotEmpty) {
        snapshot = await _firestore
            .collection('owners')
            .doc(ownerId)
            .collection('turfs')
            .doc(turfId)
            .collection('grounds')
            .get();
      } else {
        snapshot = await _firestore.collectionGroup('grounds').get();
      }

      final fetchedGrounds = snapshot.docs
          .map((doc) => GroundModel.fromFirestore(doc))
          .toList();

      fetchedGrounds.sort((a, b) => a.groundIndex.compareTo(b.groundIndex));
      grounds.value = fetchedGrounds;

      // Auto-select first ground if available
      if (fetchedGrounds.isNotEmpty) {
        setSelectedGround(fetchedGrounds.first);
      }
    } catch (e) {
      debugPrint('🔴 [BookingController] fetchTurfGrounds error: $e');
      Get.snackbar(
        'Error',
        'Failed to load grounds: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoadingGrounds.value = false;
    }
  }

  // ── Fetch Slots for a Ground ────────────────────────────────
  Future<void> fetchGroundSlots(
    String ownerId,
    String turfId,
    String groundId, {
    String? dateStr,
  }) async {
    isLoadingSlots.value = true;
    slots.clear();

    try {
      QuerySnapshot snapshot;
      if (ownerId.isNotEmpty && turfId.isNotEmpty && groundId.isNotEmpty) {
        snapshot = await _firestore
            .collection('owners')
            .doc(ownerId)
            .collection('turfs')
            .doc(turfId)
            .collection('grounds')
            .doc(groundId)
            .collection('slots')
            .get();
      } else {
        snapshot = await _firestore.collectionGroup('slots').get();
      }

      final fetched = snapshot.docs
          .map((doc) => SlotModel.fromFirestore(doc))
          .toList();

      // Query existing bookings ONLY for the selected date
      if (dateStr != null && dateStr.isNotEmpty && ownerId.isNotEmpty && turfId.isNotEmpty) {
        try {
          final bookingsSnap = await _firestore
              .collection('owners')
              .doc(ownerId)
              .collection('turfs')
              .doc(turfId)
              .collection('bookings')
              .where('date', isEqualTo: dateStr)
              .get();

          final bookedHours = <int>{};
          for (final doc in bookingsSnap.docs) {
            final data = doc.data();
            final bGroundId = data['groundId'] ?? '';
            final status = (data['status'] ?? '').toString().toLowerCase();

            if ((bGroundId.isEmpty || bGroundId == groundId) &&
                (status == 'upcoming' || status == 'confirmed' || status == 'booked')) {
              final startTime = data['startTime'] ?? '';
              final endTime = data['endTime'] ?? '';

              final startH = _parseHourFromString(startTime);
              final endH = _parseHourFromString(endTime);

              if (startH != null && endH != null) {
                final duration = (endH > startH) ? (endH - startH) : (24 - startH + endH);
                for (int i = 0; i < duration; i++) {
                  bookedHours.add((startH + i) % 24);
                }
              }
            }
          }

          // Override slot availability strictly for THIS date
          final updatedList = <SlotModel>[];
          for (final slot in fetched) {
            final startH = slot.startHour;
            if (startH != null && bookedHours.contains(startH)) {
              updatedList.add(slot.copyWith(
                isBooked: true,
                isAvailable: false,
                status: 'booked',
              ));
            } else {
              updatedList.add(slot);
            }
          }
          fetched.clear();
          fetched.addAll(updatedList);
        } catch (e) {
          debugPrint('⚠️ Error fetching date-specific bookings for slots: $e');
        }
      }

      // Sort by start hour
      fetched.sort((a, b) {
        final aHour = a.startHour ?? 0;
        final bHour = b.startHour ?? 0;
        return aHour.compareTo(bHour);
      });

      slots.value = fetched;
    } catch (e) {
      debugPrint('🔴 [BookingController] fetchGroundSlots error: $e');
      Get.snackbar(
        'Error',
        'Failed to load slots: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoadingSlots.value = false;
    }
  }

  int? _parseHourFromString(String timeStr) {
    if (timeStr.isEmpty) return null;
    try {
      final parts = timeStr.trim().split(' ');
      final timeParts = parts[0].split(':');
      int hour = int.parse(timeParts[0]);

      if (parts.length > 1) {
        final period = parts[1].toUpperCase();
        if (period == 'PM' && hour < 12) hour += 12;
        if (period == 'AM' && hour == 12) hour = 0;
      }
      return hour;
    } catch (_) {
      return null;
    }
  }

  // ── Selection Helpers ───────────────────────────────────────
  void setSelectedTurf(TurfModel turf) {
    selectedTurf.value = turf;
    // Reset downstream selections
    selectedGround.value = null;
    grounds.clear();
    slots.clear();
  }

  void setSelectedGround(GroundModel ground, {String? dateStr}) {
    selectedGround.value = ground;
    slots.clear();

    // Auto-fetch slots for the selected ground
    final turf = selectedTurf.value;
    if (turf != null) {
      fetchGroundSlots(turf.ownerId, turf.id, ground.id, dateStr: dateStr);
    }
  }

  // ── Filter by Sport ─────────────────────────────────────────
  void filterTurfsBySport(String? sport) {
    selectedSport.value = sport;

    if (sport == null || sport.isEmpty || sport == 'All Sports') {
      filteredTurfs.value = allTurfs;
    } else {
      filteredTurfs.value = allTurfs
          .where((turf) => turf.sports
              .any((s) => s.toLowerCase() == sport.toLowerCase()))
          .toList();
    }
  }

  // ── Computed Helpers ────────────────────────────────────────

  /// Lowest price from currently fetched grounds
  double get lowestGroundPrice {
    if (grounds.isEmpty) return 0;
    return grounds
        .map((g) => g.defaultPrice)
        .reduce((a, b) => a < b ? a : b);
  }

  /// Available sports from the selected turf
  List<String> get turfSports => selectedTurf.value?.sports ?? [];

  /// Ground names for the dropdown
  List<String> get groundNames =>
      grounds.map((g) => g.name).toList();

  /// Dimension options from grounds
  List<String> get dimensionOptions =>
      grounds.map((g) => g.dimensions).where((d) => d.isNotEmpty).toSet().toList();
}
