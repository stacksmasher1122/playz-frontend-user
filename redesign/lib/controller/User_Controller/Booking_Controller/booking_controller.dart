import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:redesign/model/User_Models/Booking_Models/turf_model.dart';
import 'package:redesign/model/User_Models/Booking_Models/ground_model.dart';
import 'package:redesign/model/User_Models/Booking_Models/slot_model.dart';
import 'package:redesign/utils/slot_overlap_helper.dart';

enum TurfSortOption {
  nearest,
  topRated,
  priceAsc,
  priceDesc,
  nameAsc,
}

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

  // Search & Filter State
  final searchQuery = ''.obs;
  final sortOption = TurfSortOption.nearest.obs;
  final distanceRadiusKm = 50.0.obs;

  // ── Lifecycle ───────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    fetchAllTurfs();

    everAll([searchQuery, sortOption, distanceRadiusKm, selectedSport], (_) {
      applyFilters();
    });
  }

  // ── Apply Filters & Sorting ──────────────────────────────────
  void applyFilters() {
    List<TurfModel> result = List.from(allTurfs);

    // 1. Search Query Filter
    final query = searchQuery.value.trim().toLowerCase();
    if (query.isNotEmpty) {
      result = result.where((turf) {
        final nameMatch = turf.turfName.toLowerCase().contains(query);
        final addressMatch = turf.fullAddress.toLowerCase().contains(query) ||
            turf.city.toLowerCase().contains(query) ||
            turf.state.toLowerCase().contains(query);
        final sportMatch = turf.sports.any((s) => s.toLowerCase().contains(query));
        return nameMatch || addressMatch || sportMatch;
      }).toList();
    }

    // 2. Sport Filter
    final sport = selectedSport.value;
    if (sport != null && sport.isNotEmpty && sport != 'All Sports') {
      result = result
          .where((turf) => turf.sports.any((s) => s.toLowerCase() == sport.toLowerCase()))
          .toList();
    }

    // 3. Sort Options
    switch (sortOption.value) {
      case TurfSortOption.priceAsc:
        result.sort((a, b) => (a.lowestPrice ?? 0.0).compareTo(b.lowestPrice ?? 0.0));
        break;
      case TurfSortOption.priceDesc:
        result.sort((a, b) => (b.lowestPrice ?? 0.0).compareTo(a.lowestPrice ?? 0.0));
        break;
      case TurfSortOption.topRated:
        result.sort((a, b) => (b.isVerified ? 1 : 0).compareTo(a.isVerified ? 1 : 0));
        break;
      case TurfSortOption.nameAsc:
        result.sort((a, b) => a.turfName.compareTo(b.turfName));
        break;
      case TurfSortOption.nearest:
        break;
    }

    filteredTurfs.value = result;
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
      applyFilters();
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

      // Query existing bookings AND active match polls for the selected date
      if (dateStr != null && dateStr.isNotEmpty && ownerId.isNotEmpty && turfId.isNotEmpty) {
        try {
          final bookedHours = <int>{};

          // Helper to extract hours from a time interval and add to bookedHours
          void addIntervalHours(TimeInterval? interval) {
            if (interval == null) return;
            final startH = (interval.startMinutes / 60).floor();
            final endH = (interval.endMinutes / 60).ceil();
            for (int h = startH; h < endH; h++) {
              bookedHours.add(h % 24);
            }
          }

          // Helper to extract time string from booking data (handles all field formats)
          String? extractTimeStr(Map<String, dynamic> data) {
            final time = (data['time'] ?? '').toString().trim();
            if (time.isNotEmpty && (time.contains('-') || time.contains('–') || time.contains('—'))) return time;
            final timeSlot = (data['timeSlot'] ?? '').toString().trim();
            if (timeSlot.isNotEmpty) return timeSlot;
            final startTime = (data['startTime'] ?? '').toString().trim();
            final endTime = (data['endTime'] ?? '').toString().trim();
            if (startTime.isNotEmpty && endTime.isNotEmpty) return '$startTime - $endTime';
            return null;
          }

          // 1. Process confirmed bookings
          final bookingsSnap = await _firestore
              .collection('owners')
              .doc(ownerId)
              .collection('turfs')
              .doc(turfId)
              .collection('bookings')
              .where('date', isEqualTo: dateStr)
              .get();

          for (final doc in bookingsSnap.docs) {
            final data = doc.data();
            final bGroundId = (data['groundId'] ?? '').toString();
            final status = (data['status'] ?? '').toString().toLowerCase();
            if (status == 'cancelled') continue;
            if (bGroundId.isNotEmpty && bGroundId != groundId) continue;

            final timeStr = extractTimeStr(data);
            if (timeStr != null) {
              addIntervalHours(SlotOverlapHelper.parseTimeRange(timeStr));
            }
          }

          // 2. Process ALL active match polls on the same ground & date
          final matchesSnap = await _firestore
              .collection('matches')
              .where('turfId', isEqualTo: turfId)
              .where('groundId', isEqualTo: groundId)
              .where('date', isEqualTo: dateStr)
              .get();

          for (final doc in matchesSnap.docs) {
            final data = doc.data();
            final status = (data['status'] ?? '').toString().toLowerCase();
            if (status == 'cancelled' || status == 'expired') continue;
            if (data['isSlotBooked'] != true) continue;

            final timeStr = extractTimeStr(data);
            if (timeStr != null) {
              addIntervalHours(SlotOverlapHelper.parseTimeRange(timeStr));
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
