import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

class SearchBarWidget extends StatelessWidget {
  SearchBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(20)),
      child: Container(
        height: ResponsiveHelper.h(48),
        padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16)),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(14)),
        ),
        child: Row(
          children: [
            Icon(Icons.search, color: AppColors.muted),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'Search turfs, sports, or venues...',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(color: AppColors.muted, fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
