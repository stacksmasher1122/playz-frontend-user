import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

/// A reusable, standardized Sport Arena Title text widget for setup screens.
/// Automatically formats the sport name into uppercase "[SPORT] ARENA"
/// with italicized bold accent styling.
/// 
/// Example Usage:
/// ```dart
/// const ArenaTitleText(sportName: 'Cricket') // Renders "CRICKET ARENA"
/// const ArenaTitleText(sportName: 'Basketball') // Renders "BASKETBALL ARENA"
/// ```
class ArenaTitleText extends StatelessWidget {
  /// Name of the sport (e.g., "Cricket", "Football", "Basketball", "Hockey")
  /// or full custom arena title string.
  final String sportName;

  /// Optional custom text color. Defaults to [AppColors.accent].
  final Color? color;

  /// Optional custom font size. Defaults to `ResponsiveHelper.sp(16.0)`.
  final double? fontSize;

  const ArenaTitleText({
    super.key,
    required this.sportName,
    this.color,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    // Format text: Append "ARENA" if not already present
    final String trimmed = sportName.trim().toUpperCase();
    final String fullTitle = trimmed.endsWith('ARENA')
        ? trimmed
        : '$trimmed ARENA';

    return Text(
      fullTitle,
      style: AppTypography.headlineSm.copyWith(
        color: color ?? AppColors.accent,
        fontSize: fontSize ?? ResponsiveHelper.sp(16.0),
        fontWeight: FontWeight.w900,
        letterSpacing: 1.2,
        fontStyle: FontStyle.italic,
      ).responsive(context),
    );
  }
}
