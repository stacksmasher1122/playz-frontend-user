import 'package:flutter/material.dart';
import 'package:redesign/theme/responsive_helper.dart';

class StartingLineupAppbar extends StatelessWidget implements PreferredSizeWidget {
  StartingLineupAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return AppBar(
      backgroundColor: Colors.black.withValues(alpha: 0.85),
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: Icon(Icons.menu, color: Colors.white),
        onPressed: () {},
      ),
      title: Text(
        'PRO SCOUT LIVE',
        style: TextStyle(
          color: Color(0xFFC6FF00), // Lime Green
          fontSize: ResponsiveHelper.sp(20),
          fontWeight: FontWeight.w900,
          letterSpacing: 1.0,
        ),
      ),
      actions: [
        IconButton(
          icon: Container(
            padding: EdgeInsets.all(ResponsiveHelper.w(4)),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade600),
            ),
            child: Icon(Icons.person_outline, color: Colors.white, size: 20),
          ),
          onPressed: () {},
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
