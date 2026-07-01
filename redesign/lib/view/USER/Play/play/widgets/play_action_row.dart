import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

class PlayActionRow extends StatelessWidget {
  PlayActionRow({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(20), vertical: ResponsiveHelper.h(10)),
      child: Row(
        children: [
          Text(
            'Host Game +',
            style: GoogleFonts.inter(
              color: AppColors.accent,
              fontWeight: FontWeight.w600,
            ),
          ),
          Spacer(),
          Row(
            children: [
              Icon(Icons.swap_vert, color: Colors.white, size: 16),
              SizedBox(width: 4),
              Text('Sort', style: GoogleFonts.inter(color: Colors.white)),
            ],
          ),
        ],
      ),
    );
  }
}
