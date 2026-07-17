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
    return Container(
      width: double.infinity,
      height: ResponsiveHelper.h(70),
      padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16)),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Tournament Access",
                style: AppTypography.headlineSm.copyWith(
                  color: AppColors.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: ResponsiveHelper.h(4)),
              Text(
                "Control who can join",
                style: AppTypography.bodySm.copyWith(
                  color: AppColors.muted,
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: widget.onToggle,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: ResponsiveHelper.w(48),
              height: ResponsiveHelper.h(28),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(ResponsiveHelper.w(14)),
                color: widget.isEnabled ? AppColors.accent : AppColors.card,
              ),
              child: Stack(
                children: [
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeIn,
                    top: ResponsiveHelper.h(2),
                    left: widget.isEnabled ? ResponsiveHelper.w(22) : ResponsiveHelper.w(2),
                    right: widget.isEnabled ? ResponsiveHelper.w(2) : ResponsiveHelper.w(22),
                    child: Container(
                      width: ResponsiveHelper.w(24),
                      height: ResponsiveHelper.w(24),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
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
