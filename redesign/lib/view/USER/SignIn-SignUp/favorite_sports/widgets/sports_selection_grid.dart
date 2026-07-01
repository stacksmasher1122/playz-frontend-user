import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

class SportsSelectionGrid extends StatelessWidget {
  final List<String> sports;
  final List<List<Color>> gradients;
  final Set<String> selectedSports;
  final Function(String) onSportToggle;

  SportsSelectionGrid({
    super.key,
    required this.sports,
    required this.gradients,
    required this.selectedSports,
    required this.onSportToggle,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    const kSpotifyGreen = AppColors.accent;

    return Expanded(
      child: GridView.builder(
        padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16), vertical: ResponsiveHelper.h(8)),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 0.75,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: sports.length,
        itemBuilder: (context, index) {
          final sport = sports[index];
          final isSelected = selectedSports.contains(sport);
          final gradient = gradients[index % gradients.length];

          return GestureDetector(
            onTap: () => onSportToggle(sport),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 200),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
                border: Border.all(
                  color: isSelected ? kSpotifyGreen : Colors.transparent,
                  width: ResponsiveHelper.w(2),
                ),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Blurred Gradient Background
                  ClipRRect(
                    borderRadius: BorderRadius.circular(ResponsiveHelper.w(14)),
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
                    bottom: ResponsiveHelper.h(0),
                    left: ResponsiveHelper.w(0),
                    right: ResponsiveHelper.w(0),
                    height: ResponsiveHelper.h(50),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(ResponsiveHelper.w(14)),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.8),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Soft overlay on the whole card
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(ResponsiveHelper.w(14)),
                      color: Colors.black.withValues(alpha: 0.1),
                    ),
                  ),
                  // Selection Icon
                  if (isSelected)
                    Positioned(
                      top: ResponsiveHelper.h(8),
                      right: ResponsiveHelper.w(8),
                      child: Container(
                        padding: EdgeInsets.all(ResponsiveHelper.w(2)),
                        decoration: BoxDecoration(
                          color: kSpotifyGreen,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.check,
                          color: Colors.black,
                          size: 14,
                          weight: 700,
                        ),
                      ),
                    ),
                  // Label text (pill shape behind text)
                  Positioned(
                    bottom: ResponsiveHelper.h(12),
                    left: ResponsiveHelper.w(8),
                    right: ResponsiveHelper.w(8),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(6)),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(ResponsiveHelper.w(8)),
                      ),
                      child: Text(
                        sport,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: ResponsiveHelper.sp(12),
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
