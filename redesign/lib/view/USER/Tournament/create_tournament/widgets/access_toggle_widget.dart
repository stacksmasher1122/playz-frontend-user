import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class AccessToggleWidget extends StatefulWidget {
  final bool isEnabled;
  final VoidCallback onToggle;

  const AccessToggleWidget({
    super.key,
    required this.isEnabled,
    required this.onToggle,
  });

  @override
  State<AccessToggleWidget> createState() => _AccessToggleWidgetState();
}

class _AccessToggleWidgetState extends State<AccessToggleWidget> {
  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return Container(
      width: double.infinity,
      height: context.heightPct(8.5).clamp(64.0, 76.0),
      padding: EdgeInsets.symmetric(horizontal: context.widthPct(4)),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(context.minDimensionPct(3.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Tournament Access",
                  style: AppTypography.headlineSm.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: context.responsiveFont(15),
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: context.heightPct(0.5)),
                Text(
                  "Control who can join",
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.muted,
                    fontSize: context.responsiveFont(12.5),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          SizedBox(width: context.widthPct(3)),
          GestureDetector(
            onTap: widget.onToggle,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: context.widthPct(12).clamp(44.0, 52.0),
              height: context.heightPct(3.5).clamp(24.0, 30.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(context.minDimensionPct(4)),
                color: widget.isEnabled ? AppColors.accent : AppColors.surface,
              ),
              child: Stack(
                children: [
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeIn,
                    top: 2,
                    left: widget.isEnabled ? context.widthPct(5.5).clamp(20.0, 26.0) : 2,
                    child: Container(
                      width: context.heightPct(3).clamp(20.0, 24.0),
                      height: context.heightPct(3).clamp(20.0, 24.0),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.background,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
