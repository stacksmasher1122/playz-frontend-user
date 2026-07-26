import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

class MatchJoinBar extends StatelessWidget {
  final String price;
  final VoidCallback? onJoinPressed;

  const MatchJoinBar({
    super.key,
    this.price = '₹100',
    this.onJoinPressed,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: EdgeInsets.fromLTRB(
          ResponsiveHelper.w(20),
          ResponsiveHelper.h(16),
          ResponsiveHelper.w(20),
          ResponsiveHelper.h(28),
        ),
        decoration: BoxDecoration(
          color: const Color(0xFF0E0E0E),
          border: Border(
            top: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.8),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SizedBox(
          width: double.infinity,
          height: ResponsiveHelper.h(50),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accent,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(ResponsiveHelper.w(14)),
              ),
              elevation: 4,
            ),
            onPressed: onJoinPressed ?? () {},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Join Match Poll",
                  style: GoogleFonts.inter(
                    fontSize: ResponsiveHelper.sp(16),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      "Per Person",
                      style: GoogleFonts.inter(
                        fontSize: ResponsiveHelper.sp(11),
                        color: Colors.black54,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 6),
                    Text(
                      price,
                      style: GoogleFonts.inter(
                        fontSize: ResponsiveHelper.sp(18),
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
