import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class ParticipantCounterWidget extends StatefulWidget {
  final int count;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const ParticipantCounterWidget({
    super.key,
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
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.w(16)),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Total Participants",
                  style: AppTypography.bodyLg.copyWith(
                    color: AppColors.onPrimary,
                  ),
                ),
                SizedBox(height: ResponsiveHelper.h(4)),
                Text(
                  "Must be an even number for optimal brackets",
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.muted,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: ResponsiveHelper.w(16)),
          Row(
            children: [
              _buildButton(Icons.remove, widget.onDecrement),
              SizedBox(width: ResponsiveHelper.w(16)),
              Text(
                "${widget.count}",
                style: AppTypography.headlineMd.copyWith(
                  color: AppColors.accent,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: ResponsiveHelper.w(16)),
              _buildButton(Icons.add, widget.onIncrement),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: ResponsiveHelper.w(40),
        height: ResponsiveHelper.w(40),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: AppColors.onPrimary,
          size: ResponsiveHelper.w(20),
        ),
      ),
    );
  }
}
