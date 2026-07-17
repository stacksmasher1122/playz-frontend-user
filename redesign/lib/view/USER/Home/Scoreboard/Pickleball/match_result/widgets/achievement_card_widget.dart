import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class AchievementCardWidget extends StatefulWidget {
  final List<String> achievements;

  AchievementCardWidget({super.key, required this.achievements});

  @override
  State<AchievementCardWidget> createState() => _AchievementCardWidgetState();
}

class _AchievementCardWidgetState extends State<AchievementCardWidget> with SingleTickerProviderStateMixin {
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(vsync: this, duration: Duration(milliseconds: 300 + (widget.achievements.length * 80)));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.w(20)),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
        border: Border.all(color: AppColors.outlineVariant, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'MATCH ACHIEVEMENTS',
            style: AppTypography.labelCaps10.copyWith(color: AppColors.muted, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          ...List.generate(widget.achievements.length, (index) {
            double start = (index * 80) / (300 + (widget.achievements.length * 80));
            double end = start + (300 / (300 + (widget.achievements.length * 80)));
            if (end > 1.0) end = 1.0;
            
            return ScaleTransition(
              scale: Tween<double>(begin: 0.8, end: 1.0).animate(CurvedAnimation(
                parent: _animController,
                curve: Interval(start, end, curve: Curves.easeOutBack),
              )),
              child: FadeTransition(
                opacity: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                  parent: _animController,
                  curve: Interval(start, end, curve: Curves.easeIn),
                )),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(8)),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(ResponsiveHelper.w(8)),
                        decoration: BoxDecoration(
                          color: AppColors.card,
                          borderRadius: BorderRadius.circular(ResponsiveHelper.w(8)),
                        ),
                        child: Text(
                          widget.achievements[index].substring(0, 2),
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          widget.achievements[index].substring(3), // Assuming "emoji space text"
                          style: AppTypography.bodySm.copyWith(color: AppColors.accent),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
