import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';

class SportSelector extends StatelessWidget {
  final String? selectedSport;
  final ValueChanged<String> onSportSelected;

  const SportSelector({
    super.key,
    required this.selectedSport,
    required this.onSportSelected,
  });

  @override
  Widget build(BuildContext context) {
    final sports = ['Football', 'Cricket', 'Tennis'];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: sports.map((sport) {
          final bool isActive = selectedSport == sport;

          return _SportPill(
            label: sport,
            active: isActive,
            onTap: () => onSportSelected(sport),
          );
        }).toList(),
      ),
    );
  }
}

class _SportPill extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _SportPill({
    required this.label,
    required this.active,
    required this.onTap,
  });

  static const _kGreen = AppColors.accent;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(30),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: active ? _kGreen.withOpacity(0.15) : Colors.black,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: active ? _kGreen : Colors.grey.shade700,
            width: active ? 1.4 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: active ? _kGreen : Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
      ),
    );
  }
}
