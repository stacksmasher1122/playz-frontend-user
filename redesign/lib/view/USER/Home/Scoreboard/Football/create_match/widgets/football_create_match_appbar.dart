import 'package:redesign/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:redesign/theme/responsive_helper.dart';

class FootballCreateMatchAppbar extends StatelessWidget
    implements PreferredSizeWidget {
  const FootballCreateMatchAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: AppColors.accent),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        'MATCH ARENA',
        style: TextStyle(
          color: AppColors.accent, // Lime Green
          fontSize: ResponsiveHelper.sp(16),
          fontWeight: FontWeight.w900,
          letterSpacing: 1.5,
        ),
      ),
      centerTitle: false,
      flexibleSpace: Container(
        decoration: BoxDecoration(color: Color(0xFF121212)),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
