import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

class EliteBadge extends StatelessWidget {
  final String label;
  EliteBadge(this.label, {super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(6), vertical: ResponsiveHelper.h(2)),
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(8)),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: ResponsiveHelper.sp(10),
          fontWeight: FontWeight.w700,
          color: Colors.black,
        ),
      ),
    );
  }
}
