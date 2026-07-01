import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class PickleballAppbar extends StatelessWidget implements PreferredSizeWidget {
  PickleballAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      leading: Padding(
        padding: EdgeInsets.all(ResponsiveHelper.w(12.0)),
        child: Icon(Icons.sports_tennis, color: AppColors.primaryContainer, size: 24),
      ),
      title: Text('MATCH CENTER', style: AppTypography.headlineMd),
      centerTitle: false,
      titleSpacing: 0,
      actions: [
        IconButton(
          icon: Icon(Icons.notifications_none, color: AppColors.primary),
          onPressed: () {},
        ),
        Padding(
          padding: EdgeInsets.only(right: ResponsiveHelper.w(16.0), left: 8.0),
          child: CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.surfaceContainerHighest,
            child: Icon(Icons.person, color: AppColors.onSurface, size: 20),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
