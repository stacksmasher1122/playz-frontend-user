import 'package:flutter/material.dart';

class PrizeTierModel {
  final String id;
  String title;
  TextEditingController amountController;
  IconData icon;
  final bool isDefault;

  PrizeTierModel({
    required this.id,
    required this.title,
    required this.amountController,
    required this.icon,
    this.isDefault = false,
  });

  void dispose() {
    amountController.dispose();
  }
}
