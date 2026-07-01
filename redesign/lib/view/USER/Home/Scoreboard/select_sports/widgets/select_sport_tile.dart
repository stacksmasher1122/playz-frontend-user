import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

Color kSurface = Color(0xFF0E0E0E);
Color kGreen = AppColors.accent;
Color kMuted = Color(0xFF9E9E9E);

class SportItem {
  final String name;
  final IconData icon;
  final VoidCallback onTap;

  SportItem(this.name, this.icon, {required this.onTap});
}

class SelectSportTile extends StatelessWidget {
  final SportItem sport;
  final bool selected;

  SelectSportTile({super.key, required this.sport, required this.selected});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Material(
      color: kSurface,
      borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
        onTap: sport.onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
            border: Border.all(
              color: selected ? kGreen : Colors.transparent,
              width: ResponsiveHelper.w(1.5),
            ),
          ),
          padding: EdgeInsets.all(ResponsiveHelper.w(12)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(sport.icon, color: selected ? kGreen : kMuted, size: 28),
              SizedBox(height: 8),
              Text(
                sport.name,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: selected ? kGreen : kMuted,
                  fontSize: ResponsiveHelper.sp(12),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
