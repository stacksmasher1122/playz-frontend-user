import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

class GoalsMissionsAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int zCoinsBalance;

  const GoalsMissionsAppBar({
    super.key,
    required this.zCoinsBalance,
  });

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
            // Back Button
            InkWell(
              onTap: () => Navigator.pop(context),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: 38,
                height: 38,
                decoration: const BoxDecoration(
                  color: Color(0xFF1A1A1A),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),

            // Title
            Text(
              'Goals & Missions',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: ResponsiveHelper.sp(18),
                fontWeight: FontWeight.bold,
              ),
            ),

            // Top Right Z Coins Pill
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveHelper.w(12),
                vertical: ResponsiveHelper.h(6),
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF1E2B22),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.accent.withValues(alpha: 0.5),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: AppColors.accent,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.attach_money,
                      color: Colors.black,
                      size: 13,
                    ),
                  ),
                  SizedBox(width: ResponsiveHelper.w(6)),
                  Text(
                    '$zCoinsBalance',
                    style: GoogleFonts.inter(
                      color: AppColors.accent,
                      fontSize: ResponsiveHelper.sp(13),
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
