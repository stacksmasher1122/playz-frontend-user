import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

class MyStatsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyStatsAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon(Icons.arrow_back, color: AppColors.accent, size: 22),
                  onPressed: () => Navigator.pop(context),
                ),
                SizedBox(width: ResponsiveHelper.w(12)),
                Text(
                  'PlayZ',
                  style: GoogleFonts.inter(
                    color: AppColors.accent,
                    fontSize: ResponsiveHelper.sp(20),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.accent.withValues(alpha: 0.6), width: 1.5),
                image: const DecorationImage(
                  image: NetworkImage('https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
