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
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: AppColors.accent),
        onPressed: () => Navigator.maybePop(context),
      ),
      title: Row(
        children: [
          Icon(Icons.sports_tennis, color: AppColors.accent, size: 24),
          SizedBox(width: 8),
          Text('MATCH CENTER', style: AppTypography.headlineMd),
        ],
      ),
      centerTitle: false,
      titleSpacing: 0,
      actions: [],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
