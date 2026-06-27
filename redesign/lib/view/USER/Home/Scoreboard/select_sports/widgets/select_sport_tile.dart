import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';

const Color kSurface = Color(0xFF0E0E0E);
const Color kGreen = AppColors.accent;
const Color kMuted = Color(0xFF9E9E9E);

class SportItem {
  final String name;
  final IconData icon;
  final VoidCallback onTap;

  const SportItem(this.name, this.icon, {required this.onTap});
}

class SelectSportTile extends StatelessWidget {
  final SportItem sport;
  final bool selected;

  const SelectSportTile({super.key, required this.sport, required this.selected});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: kSurface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: sport.onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selected ? kGreen : Colors.transparent,
              width: 1.5,
            ),
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(sport.icon, color: selected ? kGreen : kMuted, size: 28),
              const SizedBox(height: 8),
              Text(
                sport.name,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: selected ? kGreen : kMuted,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
