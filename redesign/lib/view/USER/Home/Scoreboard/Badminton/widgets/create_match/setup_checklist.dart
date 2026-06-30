import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';

class SetupChecklist extends StatelessWidget {
  const SetupChecklist({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader("SETUP CHECKLIST"),
          const SizedBox(height: 20),
          _buildChecklistItem("Match name defined", isDone: true),
          const SizedBox(height: 16),
          _buildChecklistItem("Standard category active", isDone: true),
          const SizedBox(height: 16),
          _buildChecklistItem("Player management (Next step)", isDone: false),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 12,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.5,
      ),
    );
  }

  Widget _buildChecklistItem(String text, {required bool isDone}) {
    return Row(
      children: [
        Icon(
          isDone ? Icons.check_circle_outline : Icons.radio_button_unchecked,
          color: isDone ? AppColors.accent : AppColors.muted,
          size: 20,
        ),
        const SizedBox(width: 12),
        Text(
          text,
          style: TextStyle(
            color: isDone ? Colors.white : AppColors.muted,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
