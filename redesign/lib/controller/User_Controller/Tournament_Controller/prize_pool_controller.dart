import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../../../model/User_Models/Tournament_Model/prize_tier_model.dart';
import '../../../view/USER/Tournament/create_tournament_team_builder/create_tournament_team_builder_page.dart';

class PrizePoolController extends GetxController {
  final _uuid = const Uuid();

  // Entry Fee Logic
  final RxBool hasEntryFee = false.obs;
  final TextEditingController entryFeeController = TextEditingController();

  // Prize Pool Logic
  final RxBool hasPrizePool = false.obs;
  
  // Dynamic Prize Tiers
  final RxList<PrizeTierModel> prizeTiers = <PrizeTierModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _initializeDefaultTiers();
  }

  @override
  void onClose() {
    entryFeeController.dispose();
    for (var tier in prizeTiers) {
      tier.dispose();
    }
    super.onClose();
  }

  void _initializeDefaultTiers() {
    prizeTiers.addAll([
      PrizeTierModel(
        id: _uuid.v4(),
        title: "Winner",
        amountController: TextEditingController(),
        icon: Icons.emoji_events,
        isDefault: true,
      ),
      PrizeTierModel(
        id: _uuid.v4(),
        title: "Runner-up",
        amountController: TextEditingController(),
        icon: Icons.military_tech,
        isDefault: true,
      ),
      PrizeTierModel(
        id: _uuid.v4(),
        title: "MVP / Best Player",
        amountController: TextEditingController(),
        icon: Icons.star,
        isDefault: true,
      ),
    ]);
  }

  void toggleEntryFee(bool value) {
    hasEntryFee.value = value;
    if (!value) {
      entryFeeController.clear();
    }
  }

  void togglePrizePool(bool value) {
    hasPrizePool.value = value;
    if (!value) {
      for (var tier in prizeTiers) {
        tier.amountController.clear();
      }
    }
  }

  void addCustomTier() {
    prizeTiers.add(
      PrizeTierModel(
        id: _uuid.v4(),
        title: "Custom Tier",
        amountController: TextEditingController(),
        icon: Icons.card_giftcard,
        isDefault: false,
      ),
    );
  }

  void removeTier(String id) {
    final index = prizeTiers.indexWhere((tier) => tier.id == id);
    if (index != -1 && !prizeTiers[index].isDefault) {
      prizeTiers[index].dispose();
      prizeTiers.removeAt(index);
    }
  }

  void updateCustomTierTitle(String id, String newTitle) {
    final index = prizeTiers.indexWhere((tier) => tier.id == id);
    if (index != -1 && !prizeTiers[index].isDefault) {
      prizeTiers[index].title = newTitle;
      prizeTiers.refresh();
    }
  }

  void goBack(BuildContext context) {
    Navigator.pop(context);
  }

  void goNext(BuildContext context) {
    // Validate required fields if switches are on
    if (hasEntryFee.value && entryFeeController.text.trim().isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Please enter a registration fee',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (hasPrizePool.value) {
      for (var tier in prizeTiers) {
        if (tier.amountController.text.trim().isEmpty) {
          Get.snackbar(
            'Validation Error',
            'Please enter an amount for ${tier.title}',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          return;
        }
      }
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CreateTournamentTeamBuilderPage()),
    );
  }
}
