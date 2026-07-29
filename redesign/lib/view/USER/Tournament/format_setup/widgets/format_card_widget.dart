import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class FormatCardWidget extends StatefulWidget {
  final String title;
  final String description;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isFullWidth;

  const FormatCardWidget({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    this.isFullWidth = false,
  });

  @override
  State<FormatCardWidget> createState() => _FormatCardWidgetState();
}

class _FormatCardWidgetState extends State<FormatCardWidget> {
  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(context.widthPct(3.5)),
        decoration: BoxDecoration(
          color: widget.isSelected ? AppColors.accent.withValues(alpha: 0.08) : AppColors.card,
          borderRadius: BorderRadius.circular(context.minDimensionPct(3.5)),
          border: Border.all(
            color: widget.isSelected ? AppColors.accent : AppColors.card,
            width: 2,
          ),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: context.widthPct(10).clamp(38.0, 44.0),
                  height: context.widthPct(10).clamp(38.0, 44.0),
                  decoration: BoxDecoration(
                    color: widget.isSelected
                        ? AppColors.accent.withValues(alpha: 0.2)
                        : AppColors.surface,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    widget.icon,
                    color: widget.isSelected ? AppColors.accent : AppColors.muted,
                    size: context.responsiveFont(20),
                  ),
                ),
                SizedBox(height: context.heightPct(1.2)),
                Text(
                  widget.title,
                  style: AppTypography.headlineSm.copyWith(
                    color: widget.isSelected ? AppColors.accent : AppColors.textPrimary,
                    fontSize: context.responsiveFont(14),
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: context.heightPct(0.5)),
                Text(
                  widget.description,
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.muted,
                    fontSize: context.responsiveFont(12),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            if (widget.isSelected)
              Positioned(
                top: 0,
                right: 0,
                child: Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.accent,
                  size: context.responsiveFont(20),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
