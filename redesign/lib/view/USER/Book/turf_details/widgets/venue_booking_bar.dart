import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class VenueBookingBar extends StatelessWidget {
  final double price;
  final bool isActive;
  final VoidCallback onBookNow;

  const VenueBookingBar({
    super.key,
    required this.price,
    required this.isActive,
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
                  backgroundColor: isActive ? AppColors.accent : AppColors.card,
                  foregroundColor: isActive ? AppColors.background : AppColors.muted,
                  padding: EdgeInsets.symmetric(
                    horizontal: context.widthPct(6),
                    vertical: context.heightPct(1.5),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(context.minDimensionPct(8)),
                    side: isActive
                        ? BorderSide.none
                        : const BorderSide(color: AppColors.borderDark),
                  ),
                ),
                onPressed: () {
                  if (!isActive) {
                    Get.snackbar(
                      'Turf Closed',
                      'This turf is currently set closed by owner.',
                      backgroundColor: Colors.redAccent,
                      colorText: Colors.white,
                      duration: const Duration(seconds: 3),
                    );
                    return;
                  }
                  onBookNow();
                },
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    isActive ? 'Book Now' : 'Closed',
                    style: AppTypography.headlineSm.copyWith(
                      color: isActive ? AppColors.background : AppColors.muted,
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
