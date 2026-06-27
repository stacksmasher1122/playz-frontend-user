import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redesign/theme/app_colors.dart';

class SportFilters extends StatelessWidget {
  const SportFilters({super.key});

  @override
  Widget build(BuildContext context) {
    final sports = [
      ('Cricket', Icons.sports_cricket),
      ('Football', Icons.sports_soccer),
      ('Badminton', Icons.sports_tennis),
    ];

    return SizedBox(
      height: 44,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemBuilder: (_, i) {
          final active = i == 0;
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: active ? AppColors.accent : Colors.transparent,
              ),
              color: AppColors.surface,
            ),
            child: Row(
              children: [
                Icon(
                  sports[i].$2,
                  size: 16,
                  color: active ? AppColors.accent : Colors.white,
                ),
                const SizedBox(width: 6),
                Text(
                  sports[i].$1,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemCount: sports.length,
      ),
    );
  }
}
