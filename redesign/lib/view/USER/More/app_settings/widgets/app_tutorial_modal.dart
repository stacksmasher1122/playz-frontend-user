import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class AppTutorialModal extends StatefulWidget {
  const AppTutorialModal({super.key});

  @override
  State<AppTutorialModal> createState() => _AppTutorialModalState();
}

class _AppTutorialModalState extends State<AppTutorialModal> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _steps = const [
    {
      'title': 'Book Turfs & Courts',
      'desc': 'Discover top sports arenas nearby, select available slots, and book with split payments in seconds.',
      'icon': Icons.sports_tennis_rounded,
    },
    {
      'title': 'Live Scoreboards',
      'desc': 'Access real-time scoreboards 20 minutes before your slot. Track runs, overs, sets, and points live.',
      'icon': Icons.scoreboard_outlined,
    },
    {
      'title': 'Offline Recovery',
      'desc': 'Never lose match progress! Your live scoreboard progress is automatically preserved locally in SQFlite.',
      'icon': Icons.cloud_done_outlined,
    },
    {
      'title': 'Stats & Leaderboards',
      'desc': 'Track your match statistics, climb local player leaderboards, and unlock rewards with Z-Coins.',
      'icon': Icons.emoji_events_outlined,
    },
  ];

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final sliderHeight = context.heightPct(30).clamp(200.0, 260.0);

    return Dialog(
      backgroundColor: AppColors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(context.minDimensionPct(6)),
      ),
      child: Padding(
        padding: EdgeInsets.all(context.widthPct(5)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close, color: AppColors.muted),
              ),
            ),
            SizedBox(
              height: sliderHeight,
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (idx) => setState(() => _currentPage = idx),
                itemCount: _steps.length,
                itemBuilder: (context, index) {
                  final step = _steps[index];
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(context.widthPct(4.5)),
                        decoration: BoxDecoration(
                          color: AppColors.accent.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          step['icon'] as IconData,
                          size: context.minDimensionPct(10).clamp(32.0, 44.0),
                          color: AppColors.accent,
                        ),
                      ),
                      SizedBox(height: context.heightPct(2)),
                      Text(
                        step['title'] as String,
                        style: AppTypography.headlineSm.copyWith(
                          color: AppColors.textPrimary,
                          fontSize: context.responsiveFont(18),
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: context.heightPct(1)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: context.widthPct(4)),
                        child: Text(
                          step['desc'] as String,
                          textAlign: TextAlign.center,
                          style: AppTypography.bodySm.copyWith(
                            color: AppColors.muted,
                            fontSize: context.responsiveFont(13),
                            height: 1.4,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            SizedBox(height: context.heightPct(1.5)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _steps.length,
                (i) => Container(
                  margin: EdgeInsets.symmetric(horizontal: context.widthPct(1)),
                  width: _currentPage == i ? 20 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: _currentPage == i ? AppColors.accent : AppColors.borderDark,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ),
            SizedBox(height: context.heightPct(2.5)),
            Row(
              children: [
                if (_currentPage > 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        _pageController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.borderDark),
                        padding: EdgeInsets.symmetric(vertical: context.heightPct(1.5)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(context.minDimensionPct(3)),
                        ),
                      ),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'Back',
                          style: AppTypography.bodySm.copyWith(
                            color: AppColors.textPrimary,
                            fontSize: context.responsiveFont(14),
                          ),
                        ),
                      ),
                    ),
                  ),
                if (_currentPage > 0) SizedBox(width: context.widthPct(3)),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_currentPage < _steps.length - 1) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      foregroundColor: AppColors.background,
                      padding: EdgeInsets.symmetric(vertical: context.heightPct(1.5)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(context.minDimensionPct(3)),
                      ),
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        _currentPage == _steps.length - 1 ? 'Got It!' : 'Next',
                        style: AppTypography.headlineSm.copyWith(
                          color: AppColors.background,
                          fontWeight: FontWeight.bold,
                          fontSize: context.responsiveFont(14),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
