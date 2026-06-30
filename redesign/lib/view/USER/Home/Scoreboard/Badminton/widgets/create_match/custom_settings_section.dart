import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';

class CustomSettingsSection extends StatelessWidget {
  final int pointsPerGame;
  final bool winBy2;
  final int maxPointCap;
  final ValueChanged<bool?> onWinBy2Changed;

  const CustomSettingsSection({
    super.key,
    required this.pointsPerGame,
    required this.winBy2,
    required this.maxPointCap,
    required this.onWinBy2Changed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: true,
          iconColor: Colors.white,
          collapsedIconColor: Colors.white,
          title: const Text(
            "CUSTOM SETTINGS",
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
              child: Column(
                children: [
                  _buildSettingRow("Points Per Game", pointsPerGame.toString()),
                  const SizedBox(height: 16),
                  _buildSettingCheckbox("Win By 2 Rule", winBy2, onWinBy2Changed),
                  const SizedBox(height: 16),
                  _buildSettingRow("Max Point Cap", maxPointCap.toString()),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSettingRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(color: AppColors.muted, fontSize: 14)),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Colors.grey.shade800),
          ),
          child: Text(
            value,
            style: const TextStyle(
              color: AppColors.accent,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingCheckbox(String title, bool value, Function(bool?) onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(color: AppColors.muted, fontSize: 14)),
        SizedBox(
          height: 24,
          width: 24,
          child: Checkbox(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.accent,
            checkColor: Colors.black,
            side: BorderSide(color: Colors.grey.shade600),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          ),
        ),
      ],
    );
  }
}
