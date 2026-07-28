import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

class SpecialInstructionsSection extends StatelessWidget {
  final TextEditingController instructionsController;
  final List<String> instructionPresets;
  final ValueChanged<String> onPresetTapped;

  const SpecialInstructionsSection({
    super.key,
    required this.instructionsController,
    required this.instructionPresets,
    required this.onPresetTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.sticky_note_2_rounded, color: AppColors.accent, size: 18),
            const SizedBox(width: 8),
            Text(
              'Special Instructions / Notes',
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
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: instructionsController,
                maxLines: 3,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText:
                      'Add instructions for players (e.g. Bring non-marking shoes, arrive 15 min early, carry ID)...',
                  hintStyle: TextStyle(color: Colors.white38, fontSize: 13),
                  border: InputBorder.none,
                ),
              ),
              const Divider(color: Colors.white10, height: 1),
              const SizedBox(height: 8),
              Text(
                'Quick Presets:',
                style: GoogleFonts.inter(
                  color: Colors.white54,
                  fontSize: ResponsiveHelper.sp(11),
                ),
              ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: instructionPresets.map((preset) {
                  return GestureDetector(
                    onTap: () => onPresetTapped(preset),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.add, color: AppColors.accent, size: 12),
                          const SizedBox(width: 4),
                          Text(
                            preset,
                            style: GoogleFonts.inter(
                              color: Colors.white70,
                              fontSize: ResponsiveHelper.sp(11),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
