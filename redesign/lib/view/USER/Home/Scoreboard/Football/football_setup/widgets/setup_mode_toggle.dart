import 'package:redesign/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'setup_constants.dart';
import 'setup_models.dart';
import 'package:redesign/theme/responsive_helper.dart';

class SetupModeToggle extends StatelessWidget {
  final MatchMode mode;
  final Function(MatchMode) onModeChanged;

  SetupModeToggle({super.key, required this.mode, required this.onModeChanged});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: Container(
        height: ResponsiveHelper.h(50),
        decoration: BoxDecoration(
          color: kSurfaceHighlight,
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(25)),
        ),
        child: Stack(
          children: [
            AnimatedAlign(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeOutBack,
              alignment: mode == MatchMode.friendly
                  ? Alignment.centerLeft
                  : Alignment.centerRight,
              child: Container(
                width: (MediaQuery.of(context).size.width - 48) / 2,
                decoration: BoxDecoration(
                  color: kAccent,
                  borderRadius: BorderRadius.circular(ResponsiveHelper.w(25)),
                  boxShadow: [
                    BoxShadow(
                      color: kAccent.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                _buildToggleItem("Friendly", MatchMode.friendly),
                _buildToggleItem("Tournament", MatchMode.tournament),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleItem(String label, MatchMode itemMode) {
    bool isSelected = mode == itemMode;
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          HapticFeedback.lightImpact();
          onModeChanged(itemMode);
        },
        child: Center(
          child: AnimatedDefaultTextStyle(
            duration: Duration(milliseconds: 200),
            style: TextStyle(
              color: isSelected ? AppColors.background : kTextSecondary,
              fontWeight: FontWeight.bold,
              fontSize: ResponsiveHelper.sp(14),
            ),
            child: Text(label),
          ),
        ),
      ),
    );
  }
}
