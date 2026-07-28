import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redesign/theme/responsive_helper.dart';

class LeaderboardAppBar extends StatelessWidget implements PreferredSizeWidget {
  const LeaderboardAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Circular Back Button
            InkWell(
              onTap: () => Navigator.pop(context),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: Color(0xFF1E1E1E),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),

            // Centered Title
            Text(
              'Leaderboards',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: ResponsiveHelper.sp(20),
                fontWeight: FontWeight.bold,
              ),
            ),

            // Circular Right Avatar Placeholder
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Color(0xFF1E1E1E),
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
