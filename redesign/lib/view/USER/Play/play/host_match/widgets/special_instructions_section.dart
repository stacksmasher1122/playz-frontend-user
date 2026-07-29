import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
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
    ResponsiveHelper.init(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.sticky_note_2_outlined, color: AppColors.accent, size: 18),
            SizedBox(width: context.widthPct(2)),
            Text(
              'Host Special Instructions (Optional)',
              style: AppTypography.headlineSm.copyWith(
                color: AppColors.accent,
                fontWeight: FontWeight.bold,
                fontSize: context.responsiveFont(14),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        SizedBox(height: context.heightPct(1.2)),

        TextField(
          controller: instructionsController,
          maxLines: 3,
          style: AppTypography.bodySm.copyWith(
            color: AppColors.textPrimary,
            fontSize: context.responsiveFont(14),
          ),
          decoration: InputDecoration(
            hintText: 'Enter rules e.g., Arrive 15m early, non-marking shoes only...',
            hintStyle: AppTypography.bodySm.copyWith(
              color: AppColors.muted.withValues(alpha: 0.6),
              fontSize: context.responsiveFont(13),
            ),
            filled: true,
            fillColor: AppColors.card,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(context.minDimensionPct(3.5)),
              borderSide: const BorderSide(color: AppColors.borderDark),
            ),
          ),
        ),

        SizedBox(height: context.heightPct(1.2)),

        SizedBox(
          height: context.heightPct(4.5).clamp(34.0, 42.0),
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: instructionPresets.length,
            separatorBuilder: (_, __) => SizedBox(width: context.widthPct(2)),
            itemBuilder: (context, index) {
              final preset = instructionPresets[index];
              return ActionChip(
                label: Text(preset),
                backgroundColor: AppColors.card,
                labelStyle: AppTypography.bodySm.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: context.responsiveFont(11.5),
                  fontWeight: FontWeight.w500,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(context.minDimensionPct(4)),
                  side: const BorderSide(color: AppColors.borderDark),
                ),
                onPressed: () => onPresetTapped(preset),
              );
            },
          ),
        ),
      ],
    );
  }
}
