import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
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
                  foregroundColor: AppColors.background,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(context.minDimensionPct(3.5)),
                  ),
                  elevation: 4,
                ),
                onPressed: onHostBookSlotPressed,
                icon: const Icon(Icons.bolt_rounded, size: 20),
                label: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'Book Slot Now',
                    style: AppTypography.headlineSm.copyWith(
                      fontSize: context.responsiveFont(14),
                      fontWeight: FontWeight.bold,
                      color: AppColors.background,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: context.widthPct(2.5)),
            IconButton(
              style: IconButton.styleFrom(
                backgroundColor: AppColors.card,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(context.minDimensionPct(3)),
                  side: const BorderSide(color: AppColors.borderDark),
                ),
              ),
              onPressed: onHostChangeSlotPressed,
              icon: const Icon(Icons.edit_calendar_rounded, color: AppColors.textPrimary),
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
              borderRadius: BorderRadius.circular(context.minDimensionPct(3.5)),
              side: const BorderSide(color: Color(0xFF059669)),
            ),
            elevation: 0,
          ),
          onPressed: null,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              'You are Host (Slot Booked ⚡)',
              style: AppTypography.headlineSm.copyWith(
                fontSize: context.responsiveFont(15),
                fontWeight: FontWeight.bold,
                color: const Color(0xFF34D399),
              ),
            ),
          ),
        );
      } else {
        childWidget = ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.card,
            foregroundColor: AppColors.muted,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(context.minDimensionPct(3.5)),
            ),
            elevation: 0,
          ),
          onPressed: null,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              'You are the Host (Included in Poll)',
              style: AppTypography.headlineSm.copyWith(
                fontSize: context.responsiveFont(14),
                fontWeight: FontWeight.w600,
                color: AppColors.muted,
              ),
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
            borderRadius: BorderRadius.circular(context.minDimensionPct(3.5)),
            side: const BorderSide(color: Color(0xFF059669)),
          ),
          elevation: 0,
        ),
        onPressed: null,
        icon: const Icon(Icons.check_circle_rounded, color: Color(0xFF34D399), size: 18),
        label: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            'Already Joined Match Poll',
            style: AppTypography.headlineSm.copyWith(
              fontSize: context.responsiveFont(15),
              fontWeight: FontWeight.bold,
              color: const Color(0xFF34D399),
            ),
          ),
        ),
      );
    } else if (isFull) {
      childWidget = ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.error.withValues(alpha: 0.2),
          foregroundColor: AppColors.error,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(context.minDimensionPct(3.5)),
            side: BorderSide(color: AppColors.error.withValues(alpha: 0.5)),
          ),
          elevation: 0,
        ),
        onPressed: null,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            'Match Poll Full 🔒',
            style: AppTypography.headlineSm.copyWith(
              fontSize: context.responsiveFont(15),
              fontWeight: FontWeight.bold,
              color: AppColors.error,
            ),
          ),
        ),
      );
    } else {
      childWidget = ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accent,
          foregroundColor: AppColors.background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(context.minDimensionPct(3.5)),
          ),
          elevation: 4,
        ),
        onPressed: onJoinPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Join Match Poll",
              style: AppTypography.headlineSm.copyWith(
                fontSize: context.responsiveFont(16),
                fontWeight: FontWeight.bold,
                color: AppColors.background,
              ),
            ),
            Row(
              children: [
                Text(
                  "Per Person",
                  style: AppTypography.bodySm.copyWith(
                    fontSize: context.responsiveFont(11),
                    color: AppColors.background.withValues(alpha: 0.7),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: context.widthPct(1.5)),
                Text(
                  price,
                  style: AppTypography.displayLg.copyWith(
                    fontSize: context.responsiveFont(18),
                    fontWeight: FontWeight.w900,
                    color: AppColors.background,
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
          context.widthPct(5),
          context.heightPct(2),
          context.widthPct(5),
          context.heightPct(3.5),
        ),
        decoration: BoxDecoration(
          color: AppColors.background,
          border: const Border(
            top: BorderSide(color: AppColors.borderDark),
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
          height: context.heightPct(6).clamp(48.0, 56.0),
          child: childWidget,
        ),
      ),
    );
  }
}
