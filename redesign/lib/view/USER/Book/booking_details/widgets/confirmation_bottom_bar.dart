import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';

class ConfirmationBottomBar extends StatelessWidget {
  final bool enabled;
  final int totalAmount;
  final VoidCallback? onPayPressed;

  const ConfirmationBottomBar({
    super.key,
    required this.enabled,
    required this.totalAmount,
    this.onPayPressed,
  });

  static const _kGreen = AppColors.accent;
  static const _kMuted = Color(0xFFA7A7A7);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
          decoration: const BoxDecoration(
            color: Color.fromRGBO(0, 0, 0, 0.8),
            border: Border(top: BorderSide(color: Color(0xFF1A1A1A))),
          ),
          child: ElevatedButton(
            onPressed: enabled ? onPayPressed : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: enabled ? _kGreen : const Color(0xFF2A2A2A),
              foregroundColor: Colors.black,
              elevation: enabled ? 2 : 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: Text(
              enabled ? 'Pay ₹$totalAmount' : 'Complete details to pay',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: enabled ? Colors.black : _kMuted,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
