import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class VenueBookingBar extends StatelessWidget {
  final double price;
  final VoidCallback onBookNow;

  const VenueBookingBar({
    super.key,
    required this.price,
    required this.onBookNow,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final displayPrice = price > 0 ? '₹${price.toInt()}/hr' : '₹--/hr';

    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: context.widthPct(4),
            vertical: context.heightPct(1.5),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(context.minDimensionPct(5)),
              topRight: Radius.circular(context.minDimensionPct(5)),
            ),
            color: AppColors.background.withValues(alpha: 0.9),
            border: const Border(
              top: BorderSide(color: AppColors.borderDark),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Starts from $displayPrice',
                  style: AppTypography.headlineSm.copyWith(
                    color: AppColors.accent,
                    fontSize: context.responsiveFont(16),
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: AppColors.background,
                  padding: EdgeInsets.symmetric(
                    horizontal: context.widthPct(6),
                    vertical: context.heightPct(1.5),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(context.minDimensionPct(8)),
                  ),
                ),
                onPressed: onBookNow,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'Book Now',
                    style: AppTypography.headlineSm.copyWith(
                      color: AppColors.background,
                      fontSize: context.responsiveFont(14),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
