import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';

class BadmintonCreateMatchAppBar extends StatelessWidget {
  const BadmintonCreateMatchAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              const SizedBox(width: 8),
              const Text(
                "MATCH CENTER",
                style: TextStyle(
                  color: AppColors.muted,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
          Row(
            children: [
              const Text(
                "NEW MATCH",
                style: TextStyle(
                  color: AppColors.muted,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.timer_outlined, color: AppColors.muted, size: 20),
            ],
          ),
        ],
      ),
    );
  }
}
