import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../view/USER/Tournament/create_tournament_prize_pool/create_tournament_prize_pool_page.dart';

class FormatSetupController extends GetxController {
  final RxInt participantCount = 8.obs;
  final RxString selectedFormat = "Knockout".obs;
  
  final RxString halfLength = "45 mins (Full Regulation)".obs;
  final RxBool extraTime = true.obs;
  final RxBool penalties = true.obs;

  final List<String> halfLengthOptions = [
    "10 mins (Fast Paced)",
    "20 mins (Standard Rec)",
    "45 mins (Full Regulation)"
  ];

  void incrementParticipants() {
    participantCount.value += 2;
  }

  void decrementParticipants() {
    if (participantCount.value > 2) {
      participantCount.value -= 2;
    }
  }

  void selectFormat(String format) {
    selectedFormat.value = format;
  }

  void updateHalfLength(String? value) {
    if (value != null) {
      halfLength.value = value;
    }
  }

  void toggleExtraTime(bool value) {
    extraTime.value = value;
  }

  void togglePenalties(bool value) {
    penalties.value = value;
  }

  void goBack(BuildContext context) {
    Navigator.pop(context);
  }

  void goNext(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CreateTournamentPrizePoolPage()),
    );
  }
}
