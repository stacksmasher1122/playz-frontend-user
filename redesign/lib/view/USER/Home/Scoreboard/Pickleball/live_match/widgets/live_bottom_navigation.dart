import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class LiveBottomNavigation extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabSelected;

  LiveBottomNavigation({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
      decoration: BoxDecoration(
        color: AppColors.card,
        border: Border(top: BorderSide(color: AppColors.outlineVariant, width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavBarItem(
            icon: Icons.emoji_events_outlined,
            label: 'Scoring',
            isSelected: selectedIndex == 0,
            onTap: () => onTabSelected(0),
          ),
          _NavBarItem(
            icon: Icons.bar_chart,
            label: 'Stats',
            isSelected: selectedIndex == 1,
            onTap: () => onTabSelected(1),
          ),
          _NavBarItem(
            icon: Icons.people_outline,
            label: 'Players',
            isSelected: selectedIndex == 2,
            onTap: () => onTabSelected(2),
          ),
          _NavBarItem(
            icon: Icons.settings_outlined,
            label: 'Settings',
            isSelected: selectedIndex == 3,
            onTap: () => onTabSelected(3),
          ),
        ],
      ),
    );
  }
}

class _NavBarItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  _NavBarItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_NavBarItem> createState() => _NavBarItemState();
}

class _NavBarItemState extends State<_NavBarItem> with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(vsync: this, duration: Duration(milliseconds: 100));
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return GestureDetector(
      onTapDown: (_) => _scaleController.forward(),
      onTapUp: (_) {
        _scaleController.reverse();
        widget.onTap();
      },
      onTapCancel: () => _scaleController.reverse(),
      behavior: HitTestBehavior.opaque,
      child: ScaleTransition(
        scale: Tween<double>(begin: 1.0, end: 0.9).animate(_scaleController),
        child: SizedBox(
          width: ResponsiveHelper.w(70),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: Duration(milliseconds: 200),
                height: ResponsiveHelper.h(3),
                width: widget.isSelected ? 24 : 0,
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.circular(ResponsiveHelper.w(1.5)),
                ),
              ),
              SizedBox(height: 8),
              Icon(
                widget.icon,
                color: widget.isSelected ? AppColors.accent : AppColors.muted,
                size: 24,
              ),
              SizedBox(height: 4),
              Text(
                widget.label,
                style: AppTypography.labelCaps10.copyWith(
                  color: widget.isSelected ? AppColors.accent : AppColors.muted,
                  fontWeight: widget.isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
