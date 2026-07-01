import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redesign/theme/responsive_helper.dart';

class FavoriteSportsHeader extends StatelessWidget {
  FavoriteSportsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 16, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select your favorites',
            style: GoogleFonts.inter(
              fontSize: ResponsiveHelper.sp(28),
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Choose at least 4 sports to personalize your feed',
            style: GoogleFonts.inter(fontSize: ResponsiveHelper.sp(15), color: Colors.white70),
          ),
        ],
      ),
    );
  }
}
