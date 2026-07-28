import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

class MatchJoinBar extends StatelessWidget {
  final String price;
  final bool isHost;
  final bool alreadyJoined;
  final bool isFull;
  final bool isSlotBooked;
  final double collectedAmount;
  final double targetAmount;
  final VoidCallback? onJoinPressed;
  final VoidCallback? onHostBookSlotPressed;
  final VoidCallback? onHostChangeSlotPressed;

  const MatchJoinBar({
    super.key,
    this.price = '₹100',
    this.isHost = false,
    this.alreadyJoined = false,
    this.isFull = false,
    this.isSlotBooked = false,
    this.collectedAmount = 0.0,
    this.targetAmount = 0.0,
    this.onJoinPressed,
    this.onHostBookSlotPressed,
    this.onHostChangeSlotPressed,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    final bool targetReached = (targetAmount > 0 && collectedAmount >= targetAmount) || isFull;

    Widget childWidget;

    if (isHost) {
      if (!isSlotBooked && targetReached) {
        // Poll funds collected! Host can book slot or change slot if taken
        childWidget = Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(ResponsiveHelper.w(14)),
                  ),
                  elevation: 4,
                ),
                onPressed: onHostBookSlotPressed,
                icon: const Icon(Icons.bolt_rounded, size: 20),
                label: Text(
                  'Book Slot Now',
                  style: GoogleFonts.inter(
                    fontSize: ResponsiveHelper.sp(14),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            IconButton(
              style: IconButton.styleFrom(
                backgroundColor: AppColors.card,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
                  side: const BorderSide(color: Colors.white24),
                ),
              ),
              onPressed: onHostChangeSlotPressed,
              icon: const Icon(Icons.edit_calendar_rounded, color: Colors.white),
              tooltip: 'Change Date or Time Slot',
            ),
          ],
        );
      } else if (isSlotBooked) {
        childWidget = ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF059669).withValues(alpha: 0.2),
            foregroundColor: const Color(0xFF34D399),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(ResponsiveHelper.w(14)),
              side: const BorderSide(color: Color(0xFF059669)),
            ),
            elevation: 0,
          ),
          onPressed: null,
          child: Text(
            'You are Host (Slot Booked ⚡)',
            style: GoogleFonts.inter(
              fontSize: ResponsiveHelper.sp(15),
              fontWeight: FontWeight.bold,
              color: const Color(0xFF34D399),
            ),
          ),
        );
      } else {
        childWidget = ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.card,
            foregroundColor: Colors.white54,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(ResponsiveHelper.w(14)),
            ),
            elevation: 0,
          ),
          onPressed: null,
          child: Text(
            'You are the Host (Included in Poll)',
            style: GoogleFonts.inter(
              fontSize: ResponsiveHelper.sp(14),
              fontWeight: FontWeight.w600,
              color: Colors.white60,
            ),
          ),
        );
      }
    } else if (alreadyJoined) {
      childWidget = ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF059669).withValues(alpha: 0.2),
          foregroundColor: const Color(0xFF34D399),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ResponsiveHelper.w(14)),
            side: const BorderSide(color: Color(0xFF059669)),
          ),
          elevation: 0,
        ),
        onPressed: null,
        icon: const Icon(Icons.check_circle_rounded, color: Color(0xFF34D399), size: 18),
        label: Text(
          'Already Joined Match Poll',
          style: GoogleFonts.inter(
            fontSize: ResponsiveHelper.sp(15),
            fontWeight: FontWeight.bold,
            color: const Color(0xFF34D399),
          ),
        ),
      );
    } else if (isFull) {
      childWidget = ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.redAccent.withValues(alpha: 0.2),
          foregroundColor: Colors.redAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ResponsiveHelper.w(14)),
            side: BorderSide(color: Colors.redAccent.withValues(alpha: 0.5)),
          ),
          elevation: 0,
        ),
        onPressed: null,
        child: Text(
          'Match Poll Full 🔒',
          style: GoogleFonts.inter(
            fontSize: ResponsiveHelper.sp(15),
            fontWeight: FontWeight.bold,
            color: Colors.redAccent,
          ),
        ),
      );
    } else {
      childWidget = ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accent,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ResponsiveHelper.w(14)),
          ),
          elevation: 4,
        ),
        onPressed: onJoinPressed,
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
                const SizedBox(width: 6),
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
      );
    }

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
          child: childWidget,
        ),
      ),
    );
  }
}
