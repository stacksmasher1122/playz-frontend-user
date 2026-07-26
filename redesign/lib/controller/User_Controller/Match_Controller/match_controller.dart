import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:redesign/view/USER/Play/play/play_models.dart';
import 'package:redesign/controller/maps_controller.dart';

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
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return false;
    }
  }
}
