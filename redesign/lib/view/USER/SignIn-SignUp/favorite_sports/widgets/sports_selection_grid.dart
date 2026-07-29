import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class SportsSelectionGrid extends StatelessWidget {
  final List<String> sports;
  final List<List<Color>> gradients;
  final Set<String> selectedSports;
  final Function(String) onSportToggle;

  const SportsSelectionGrid({
    super.key,
    required this.sports,
    required this.gradients,
    required this.selectedSports,
    required this.onSportToggle,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return Expanded(
      child: GridView.builder(
        padding: EdgeInsets.symmetric(
          horizontal: context.widthPct(4),
          vertical: context.heightPct(1),
        ),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 0.75,
          crossAxisSpacing: context.widthPct(3),
          mainAxisSpacing: context.heightPct(1.5),
        ),
        itemCount: sports.length,
        itemBuilder: (context, index) {
          final sport = sports[index];
          final isSelected = selectedSports.contains(sport);
          final gradient = gradients[index % gradients.length];

          return GestureDetector(
            onTap: () => onSportToggle(sport),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(context.minDimensionPct(4)),
                border: Border.all(
                  color: isSelected ? AppColors.accent : Colors.transparent,
                  width: context.widthPct(0.6).clamp(1.5, 3.0),
                ),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Gradient Background
                  ClipRRect(
                    borderRadius: BorderRadius.circular(context.minDimensionPct(3.5)),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: gradient,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                    ),
                  ),
                  // Dark overlay at bottom for text readability
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    height: context.heightPct(6),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(context.minDimensionPct(3.5)),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            AppColors.background.withValues(alpha: 0.8),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Soft overlay on the whole card
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(context.minDimensionPct(3.5)),
                      color: AppColors.background.withValues(alpha: 0.1),
                    ),
                  ),
                  // Selection Icon
                  if (isSelected)
                    Positioned(
                      top: context.heightPct(1),
                      right: context.widthPct(2),
                      child: Container(
                        padding: EdgeInsets.all(context.widthPct(0.8)),
                        decoration: const BoxDecoration(
                          color: AppColors.accent,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check_rounded,
                          color: AppColors.background,
                          size: 14,
                        ),
                      ),
                    ),
                  // Label text (pill shape behind text)
                  Positioned(
                    bottom: context.heightPct(1.2),
                    left: context.widthPct(2),
                    right: context.widthPct(2),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: context.heightPct(0.8),
                        horizontal: context.widthPct(1),
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.textPrimary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(context.minDimensionPct(2)),
                      ),
                      child: Text(
                        sport,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.bodySm.copyWith(
                          color: AppColors.textPrimary,
                          fontSize: context.responsiveFont(12),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
