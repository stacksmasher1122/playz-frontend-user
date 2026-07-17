import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class ResultHeaderWidget extends StatelessWidget implements PreferredSizeWidget {
  ResultHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      automaticallyImplyLeading: false, // NO back button
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.sports_tennis, color: AppColors.accent, size: 24),
          SizedBox(width: 8),
          Text('MATCH CENTER', style: AppTypography.headlineMd),
        ],
      ),
      centerTitle: false,
      titleSpacing: 16,
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 16.0),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.accent, width: 1.5),
            ),
            child: CircleAvatar(
              radius: 16,
              backgroundImage: NetworkImage('https://i.pravatar.cc/100'),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
