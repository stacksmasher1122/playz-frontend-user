import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

class MapPickerBottomCard extends StatelessWidget {
  final Widget addressPreview;
  final Widget confirmButton;

  const MapPickerBottomCard({
    super.key,
    required this.addressPreview,
    required this.confirmButton,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      padding: EdgeInsets.fromLTRB(
        context.widthPct(4),
        context.heightPct(1.2),
        context.widthPct(4),
        context.heightPct(2.5),
      ),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.vertical(top: Radius.circular(context.minDimensionPct(6))),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: context.widthPct(10),
            height: context.heightPct(0.5),
            margin: EdgeInsets.only(bottom: context.heightPct(2)),
            decoration: BoxDecoration(
              color: AppColors.borderDark,
              borderRadius: BorderRadius.circular(context.minDimensionPct(2)),
            ),
          ),

          // Location info with AnimatedSwitcher
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(context.widthPct(3)),
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(context.minDimensionPct(3)),
                ),
                child: const Icon(Icons.location_on, color: AppColors.accent),
              ),
              SizedBox(width: context.widthPct(3)),
              Expanded(child: addressPreview),
            ],
          ),

          SizedBox(height: context.heightPct(2.5)),

          // Confirm button with state logic
          confirmButton,
        ],
      ),
    );
  }
}
