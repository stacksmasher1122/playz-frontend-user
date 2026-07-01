import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

class SportsRow extends StatelessWidget {
  SportsRow({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final sports = [
      ('Cricket', Icons.sports_cricket),
      ('Football', Icons.sports_soccer),
      ('Badminton', Icons.sports_tennis),
      ('Basketball', Icons.sports_basketball),
    ];

    return SizedBox(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16)),
        physics: BouncingScrollPhysics(),
        child: Row(
          children: [
            for (int i = 0; i < sports.length; i++) ...[
              _SportCard(name: sports[i].$1, icon: sports[i].$2),
              if (i != sports.length - 1) SizedBox(width: 12),
            ],
          ],
        ),
      ),
    );
  }
}

class _SportCard extends StatelessWidget {
  final String name;
  final IconData icon;

  _SportCard({required this.name, required this.icon});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: 140,
        maxWidth: 170, // slightly tighter = better density
      ),
      child: Container(
        padding: EdgeInsets.all(ResponsiveHelper.w(12)), // reduced padding
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min, // 🔑
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// HEADER
            Row(
              children: [
                Icon(icon, color: Colors.white, size: 18),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: ResponsiveHelper.sp(14),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 10),

            /// ACTIONS
            _SportButton('Find Game', filled: true),
            SizedBox(height: 6),
            _SportButton('Join Group', filled: false),
          ],
        ),
      ),
    );
  }
}

class _SportButton extends StatelessWidget {
  final String label;
  final bool filled;

  _SportButton(this.label, {required this.filled});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: filled ? AppColors.accent : Colors.transparent,
          foregroundColor: filled ? Colors.black : Colors.white,
          side: filled ? BorderSide.none : BorderSide(color: Colors.white24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ResponsiveHelper.w(18)),
          ),
          padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(10)),
        ),
        onPressed: () {},
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.inter(fontSize: ResponsiveHelper.sp(12), fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
