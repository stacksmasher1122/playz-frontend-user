import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../../../../theme/app_colors.dart';
import '../../../../../../../theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class PmBottomNavWidget extends StatefulWidget {
  PmBottomNavWidget({super.key});

  @override
  State<PmBottomNavWidget> createState() => _PmBottomNavWidgetState();
}

class _PmBottomNavWidgetState extends State<PmBottomNavWidget> {
  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      height: ResponsiveHelper.h(80),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer.withValues(alpha: 0.9),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(ResponsiveHelper.w(24)),
          topRight: Radius.circular(ResponsiveHelper.w(24)),
        ),
        border: Border(top: BorderSide(color: Colors.white10, width: 1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 20,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(ResponsiveHelper.w(24)),
          topRight: Radius.circular(ResponsiveHelper.w(24)),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildTabItem('Setup', Icons.settings_applications, true),
              _buildTabItem('Live', Icons.sports_tennis, false),
              _buildTabItem('Stats', Icons.equalizer, false),
              _buildTabItem('Summary', Icons.description, false),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabItem(String label, IconData icon, bool isActive) {
    return _TabItem(label: label, icon: icon, isActive: isActive);
  }
}

class _TabItem extends StatefulWidget {
  final String label;
  final IconData icon;
  final bool isActive;

  _TabItem({
    required this.label,
    required this.icon,
    required this.isActive,
  });

  @override
  State<_TabItem> createState() => _TabItemState();
}

class _TabItemState extends State<_TabItem> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          if (widget.isActive) {
            Navigator.pop(context);
          } else {
            debugPrint("Navigating to ${widget.label}");
          }
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          width: ResponsiveHelper.w(80),
          decoration: BoxDecoration(
            color: isHovered && !widget.isActive
                ? Colors.white.withValues(alpha: 0.05)
                : Colors.transparent,
            border: Border(
              top: BorderSide(
                color: widget.isActive
                    ? AppColors.primaryContainer
                    : Colors.transparent,
                width: ResponsiveHelper.w(2),
              ),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                widget.icon,
                size: 24,
                color: widget.isActive
                    ? AppColors.primaryContainer
                    : AppColors.onSurfaceVariant,
              ),
              SizedBox(height: 4),
              Text(
                widget.label,
                style: AppTypography.labelCaps10.copyWith(
                  color: widget.isActive
                      ? AppColors.primaryContainer
                      : AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
