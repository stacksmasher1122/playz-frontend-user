import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class ParticipantCounterWidget extends StatefulWidget {
  final String title;
  final String subtitle;
  final int count;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const ParticipantCounterWidget({
    super.key,
    this.title = "Total Participants",
    this.subtitle = "Must be an even number for optimal brackets",
    required this.count,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  State<ParticipantCounterWidget> createState() => _ParticipantCounterWidgetState();
}

class _ParticipantCounterWidgetState extends State<ParticipantCounterWidget> {
  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return Container(
      padding: EdgeInsets.all(context.widthPct(4)),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(context.minDimensionPct(3.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: AppTypography.bodyLg.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: context.responsiveFont(14.5),
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: context.heightPct(0.5)),
                Text(
                  widget.subtitle,
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.muted,
                    fontSize: context.responsiveFont(12),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          SizedBox(width: context.widthPct(3)),
          Row(
            children: [
              _buildButton(context, Icons.remove_rounded, widget.onDecrement),
              SizedBox(width: context.widthPct(3)),
              Text(
                "${widget.count}",
                style: AppTypography.headlineMd.copyWith(
                  color: AppColors.accent,
                  fontSize: context.responsiveFont(18),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: context.widthPct(3)),
              _buildButton(context, Icons.add_rounded, widget.onIncrement),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildButton(BuildContext context, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: context.widthPct(10).clamp(36.0, 44.0),
        height: context.widthPct(10).clamp(36.0, 44.0),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: AppColors.textPrimary,
          size: context.responsiveFont(20),
        ),
      ),
    );
  }
}
