import 'package:flutter/material.dart';
import 'package:redesign/theme/responsive_helper.dart';

class FootballCreateMatchAppbar extends StatelessWidget implements PreferredSizeWidget {
  FootballCreateMatchAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.menu, color: Colors.white),
        onPressed: () {},
      ),
      title: Text(
        'PRO SCOUT LIVE',
        style: TextStyle(
          color: Color(0xFFC6FF00), // Lime Green
          fontSize: ResponsiveHelper.sp(14),
          fontWeight: FontWeight.w900,
          letterSpacing: 1.5,
        ),
      ),
      centerTitle: true,
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 16.0),
          child: CircleAvatar(
            radius: 16,
            backgroundColor: Colors.grey.shade800,
            child: Icon(
              Icons.person,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
      ],
      flexibleSpace: Container(
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.5),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
