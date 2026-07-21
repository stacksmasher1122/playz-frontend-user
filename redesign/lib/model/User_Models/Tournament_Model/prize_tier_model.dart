import 'package:flutter/material.dart';

class PrizeTierModel {
  final String id;
  final String type; // 'rank' or 'custom'
  int? rankPosition;
  String? title;
  TextEditingController amountController;
  IconData icon;
  final bool isDefault;

  PrizeTierModel({
    required this.id,
    required this.type,
    this.rankPosition,
    this.title,
    required this.amountController,
    required this.icon,
    this.isDefault = false,
  });

  void dispose() {
    amountController.dispose();
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      if (type == 'rank') 'rankPosition': rankPosition,
      if (type == 'custom') 'title': title,
      'amount': num.tryParse(amountController.text) ?? 0,
    };
  }
}
