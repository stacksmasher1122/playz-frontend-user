import 'package:flutter/material.dart';
import 'package:redesign/view/USER/Maps/maps_constants.dart';
import 'package:redesign/theme/responsive_helper.dart';
 // For kMuted constant

class SectionHeader extends StatelessWidget {
  final String title;

  SectionHeader({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(left: 4),
        child: Text(
          title,
          style: TextStyle(
            color: kMuted.withValues(alpha: 0.5),
            fontSize: ResponsiveHelper.sp(10),
            letterSpacing: 1.5,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
