import 'package:flutter/material.dart';
import '../home_screen.dart';
import 'package:redesign/theme/responsive_helper.dart';

/* ============================================================
   SECTION HEADER
   ============================================================ */
class HomeSectionHeader extends StatelessWidget {
  final String title;
  HomeSectionHeader(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: ResponsiveHelper.sp(18),
            fontWeight: FontWeight.w700,
          ),
        ),
        Spacer(),
        Text(
          'See All',
          style: TextStyle(color: UserHomePage.accent, fontSize: 13),
        ),
      ],
    );
  }
}
