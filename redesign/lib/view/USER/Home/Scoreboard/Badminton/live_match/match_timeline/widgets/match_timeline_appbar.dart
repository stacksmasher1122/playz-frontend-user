import 'package:flutter/material.dart';
import 'package:redesign/theme/responsive_helper.dart';

class MatchTimelineAppbar extends StatelessWidget implements PreferredSizeWidget {
  MatchTimelineAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_rounded, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        'MATCH CENTER',
        style: TextStyle(
          color: Color(0xFFC6FF00), // Neon Yellow-Green
          fontSize: ResponsiveHelper.sp(14),
          letterSpacing: 1.5,
          fontWeight: FontWeight.w900,
          fontStyle: FontStyle.italic,
        ),
      ),
      centerTitle: true,
      actions: [
        Container(
          margin: EdgeInsets.only(right: ResponsiveHelper.w(16.0), top: ResponsiveHelper.h(12), bottom: 12),
          padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(12), vertical: ResponsiveHelper.h(4)),
          decoration: BoxDecoration(
            color: Colors.grey.shade900,
            borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
            border: Border.all(color: Colors.grey.shade800),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.timer_outlined,
                color: Colors.white,
                size: 14,
              ),
              SizedBox(width: 6),
              Text(
                'FINAL RESULT',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: ResponsiveHelper.sp(10),
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
