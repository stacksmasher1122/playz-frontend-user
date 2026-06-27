import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';

class ScoringConsole extends StatelessWidget {
  final VoidCallback onUndo;
  final VoidCallback onWicket;
  final VoidCallback onExtras;
  final Function(int) onNormalRun;

  const ScoringConsole({
    super.key,
    required this.onUndo,
    required this.onWicket,
    required this.onExtras,
    required this.onNormalRun,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                _actionButton(
                  'UNDO',
                  Icons.undo_rounded,
                  Colors.white24,
                  onUndo,
                ),
                const SizedBox(width: 12),
                _actionButton(
                  'WICKET',
                  Icons.close_rounded,
                  AppColors.error.withOpacity(0.2),
                  onWicket,
                  textColor: AppColors.error,
                ),
                const SizedBox(width: 12),
                _actionButton(
                  'EXTRAS',
                  Icons.add_circle_outline_rounded,
                  Colors.amber.withOpacity(0.2),
                  onExtras,
                  textColor: Colors.amber,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [0, 1, 2, 3, 4, 6].map((runs) {
                return _runButton(runs, () => onNormalRun(runs));
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionButton(
    String label,
    IconData icon,
    Color bg,
    VoidCallback onTap, {
    Color textColor = Colors.white,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            children: [
              Icon(icon, color: textColor, size: 20),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: textColor,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _runButton(int runs, VoidCallback onTap) {
    final isBound = runs == 4 || runs == 6;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: isBound ? AppColors.accent : Colors.white10,
          shape: BoxShape.circle,
          boxShadow: isBound
              ? [
                  BoxShadow(
                    color: AppColors.accent.withOpacity(0.3),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
        alignment: Alignment.center,
        child: Text(
          '$runs',
          style: TextStyle(
            color: isBound ? Colors.black : Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
