import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

class PlayerCounterSection extends StatelessWidget {
  final int maxPlayers;
  final ValueChanged<int> onPlayersChanged;

  const PlayerCounterSection({
    super.key,
    required this.maxPlayers,
    required this.onPlayersChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.groups_rounded, color: AppColors.accent, size: 18),
            const SizedBox(width: 8),
            Text(
              'Total Players Needed',
              style: GoogleFonts.inter(
                color: AppColors.accent,
                fontWeight: FontWeight.bold,
                fontSize: ResponsiveHelper.sp(14),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white12),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Decrement Button
                  Material(
                    color: maxPlayers > 2
                        ? AppColors.accent.withValues(alpha: 0.15)
                        : Colors.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: maxPlayers > 2
                          ? () => onPlayersChanged(maxPlayers - 1)
                          : null,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Icon(
                          Icons.remove,
                          color: maxPlayers > 2 ? AppColors.accent : Colors.white24,
                          size: 24,
                        ),
                      ),
                    ),
                  ),

                  // Current Count Display
                  Column(
                    children: [
                      Text(
                        '$maxPlayers',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: ResponsiveHelper.sp(26),
                        ),
                      ),
                      Text(
                        'Players',
                        style: GoogleFonts.inter(
                          color: AppColors.accent,
                          fontWeight: FontWeight.w600,
                          fontSize: ResponsiveHelper.sp(12),
                        ),
                      ),
                    ],
                  ),

                  // Increment Button
                  Material(
                    color: maxPlayers < 30
                        ? AppColors.accent
                        : Colors.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: maxPlayers < 30
                          ? () => onPlayersChanged(maxPlayers + 1)
                          : null,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Icon(
                          Icons.add,
                          color: maxPlayers < 30 ? Colors.black : Colors.white24,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(color: Colors.white10, height: 1),
              const SizedBox(height: 10),
              // Quick Format Presets
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildPresetChip('5v5 (10)', 10),
                  _buildPresetChip('7v7 (14)', 14),
                  _buildPresetChip('11v11 (22)', 22),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPresetChip(String label, int value) {
    final isSelected = maxPlayers == value;
    return GestureDetector(
      onTap: () => onPlayersChanged(value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.accent : Colors.white.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            color: isSelected ? Colors.black : Colors.white70,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            fontSize: ResponsiveHelper.sp(12),
          ),
        ),
      ),
    );
  }
}
