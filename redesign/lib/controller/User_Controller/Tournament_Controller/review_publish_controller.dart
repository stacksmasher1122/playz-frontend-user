import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:intl/intl.dart';

import '../../../shared_preferences/userPreferences.dart';
import 'create_tournament_controller.dart';
import 'venue_selection_controller.dart';
import 'format_setup_controller.dart';
import 'prize_pool_controller.dart';

class ReviewPublishController extends GetxController {
  final CreateTournamentController _createCtrl = Get.find<CreateTournamentController>();
  final VenueSelectionController _venueCtrl = Get.find<VenueSelectionController>();
  final FormatSetupController _formatCtrl = Get.find<FormatSetupController>();
  final PrizePoolController _prizeCtrl = Get.find<PrizePoolController>();

  // Publish Settings State
  final RxBool isPublic = true.obs;
  final RxBool isPublishing = false.obs;

  // Derived Tournament Data for Review
  String get tournamentName => _createCtrl.tournamentName.value;
  String get tournamentType => _createCtrl.selectedSport.value;
  String get tournamentCategory => _formatCtrl.teamMode.value; // singles, doubles, team
  String get bannerImageUrl => _createCtrl.coverImagePath.value.isNotEmpty
      ? _createCtrl.coverImagePath.value
      : "https://via.placeholder.com/600x300";

  String get venueName => _venueCtrl.selectedVenueName.value ?? "TBD";
  String get dateRange {
    final start = _createCtrl.startDate.value;
    final end = _createCtrl.endDate.value;
    if (start != null && end != null) {
      final formatter = DateFormat('MMM d, yyyy');
      return "${formatter.format(start)} - ${formatter.format(end)}";
    }
    return "TBD";
  }
  
  String get formatType => _formatCtrl.matchType.value.capitalizeFirst ?? "";
  String get formatDetails => "${_formatCtrl.participantCount.value} Teams Max";
  
  String get prizeTotal => _prizeCtrl.hasPrizePool.value ? "Yes" : "No";
  String get prizeDistribution => _prizeCtrl.hasPrizePool.value
    ? "${_prizeCtrl.prizeTiers.length} Tiers"
    : "No Prizes";


  void togglePublicSetting(bool value) {
    isPublic.value = value;
    _createCtrl.isPublicAccess.value = value; // keep in sync
  }

  void copyInviteLink() {
    Clipboard.setData(const ClipboardData(text: "https://playz.app/invite/mrv-2024"));
    Get.snackbar(
      "Link Copied",
      "Tournament invite link copied to clipboard",
      backgroundColor: Colors.black87,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      icon: const Icon(Icons.check_circle, color: Colors.green),
    );
  }

  void editAll(BuildContext context) {
    // Navigate back to the very first step in a real scenario
    Get.snackbar("Edit Mode", "Navigating to first step...");
  }


  void goBack(BuildContext context) {
    Navigator.pop(context);
  }

  Future<void> publishTournament(BuildContext context) async {
    isPublishing.value = true;
    try {
      final docId = await UserPreferences.getDocId();
      if (docId == null || docId.isEmpty) {
        throw Exception("User not logged in");
      }

      final tournamentId = const Uuid().v4();
      String coverImageUrl = "";

      // 1. Upload Cover Image (with compression)
      if (_createCtrl.coverImagePath.value.isNotEmpty) {
        final File imageFile = File(_createCtrl.coverImagePath.value);
        final compressedImage = await FlutterImageCompress.compressWithFile(
          imageFile.absolute.path,
          minWidth: 1600,
          minHeight: 1600,
          quality: 80,
        );

        if (compressedImage != null) {
          final ref = FirebaseStorage.instance.ref().child('tournament_covers/$tournamentId.jpg');
          final uploadTask = await ref.putData(compressedImage, SettableMetadata(contentType: 'image/jpeg'));
          coverImageUrl = await uploadTask.ref.getDownloadURL();
        }
      }

      // 2. Assemble the document
      final Map<String, dynamic> tournamentData = {
        'organizerId': docId,
        'sport': _createCtrl.selectedSport.value,
        'name': _createCtrl.tournamentName.value,
        'description': _createCtrl.description.value,
        'coverImageUrl': coverImageUrl,
        'startDate': _createCtrl.startDate.value != null ? Timestamp.fromDate(_createCtrl.startDate.value!) : null,
        'endDate': _createCtrl.endDate.value != null ? Timestamp.fromDate(_createCtrl.endDate.value!) : null,
        'timing': _createCtrl.selectedTiming.value,
        'access': _createCtrl.isPublicAccess.value ? 'public' : 'private',
        'venue': {
          'source': _venueCtrl.selectedTab.value == "PlayZ Venues" ? 'playz' : 'other',
          'name': _venueCtrl.selectedVenueName.value,
          'latitude': _venueCtrl.selectedVenueLatitude.value,
          'longitude': _venueCtrl.selectedVenueLongitude.value,
          'fullAddress': _venueCtrl.selectedVenueAddress.value,
        },
        'format': {
          'teamMode': _formatCtrl.teamMode.value,
          'teamSize': _formatCtrl.teamSize.value,
          'matchType': _formatCtrl.matchType.value,
          'sportRules': _formatCtrl.sportRules,
          if (_formatCtrl.matchType.value == 'groupToKnockout')
            'advancingTeamsPerGroup': _formatCtrl.advancingTeamsPerGroup.value,
        },
        'entryFee': {
          'isFree': !_prizeCtrl.hasEntryFee.value,
          'amount': _prizeCtrl.hasEntryFee.value ? num.tryParse(_prizeCtrl.entryFeeController.text) : null,
        },
        'prizePool': {
          'hasPrizePool': _prizeCtrl.hasPrizePool.value,
          'tiers': _prizeCtrl.prizeTiers.map((t) => t.toMap()).toList(),
        },
        'status': 'registration_open',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'teamCount': 0,
      };

      // 3. Write to Firestore
      await FirebaseFirestore.instance.collection('tournaments').doc(tournamentId).set(tournamentData);

      Get.snackbar(
        "Tournament Published!",
        "Your tournament is now live.",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
      );

      // Navigate to detail screen (stub for now until Step 6 is done)
      // Get.offAll(() => TournamentDetailScreen(tournamentId: tournamentId));

    } catch (e) {
      Get.snackbar(
        "Publish Failed",
        "Error: ${e.toString()}",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 5),
      );
    } finally {
      isPublishing.value = false;
    }
  }
}
