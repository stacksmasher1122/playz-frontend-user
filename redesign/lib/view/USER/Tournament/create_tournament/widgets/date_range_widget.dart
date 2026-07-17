import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class DateRangeWidget extends StatefulWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  final VoidCallback onStartTap;
  final VoidCallback onEndTap;

  const DateRangeWidget({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.onStartTap,
    required this.onEndTap,
  });

  String _formatDate(DateTime? date) {
    if (date == null) return "dd-mm-yyyy";
    return DateFormat('dd-MM-yyyy').format(date);
  }

  
  @override
  State<DateRangeWidget> createState() => _DateRangeWidgetState();
}

class _DateRangeWidgetState extends State<DateRangeWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                "Start Date",
                style: AppTypography.headlineSm.copyWith(
                  color: AppColors.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(width: ResponsiveHelper.w(16)),
            Expanded(
              child: Text(
                "End Date",
                style: AppTypography.headlineSm.copyWith(
                  color: AppColors.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: ResponsiveHelper.h(8)),
        Row(
          children: [
            Expanded(
              child: _buildDateBox(
                context,
                widget._formatDate(widget.startDate),
                widget.onStartTap,
                widget.startDate != null,
              ),
            ),
            SizedBox(width: ResponsiveHelper.w(16)),
            Expanded(
              child: _buildDateBox(
                context,
                widget._formatDate(widget.endDate),
                widget.onEndTap,
                widget.endDate != null,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDateBox(BuildContext context, String text, VoidCallback onTap, bool hasDate) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: ResponsiveHelper.h(52),
        padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16)),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: AppTypography.bodyMd.copyWith(
                color: hasDate ? AppColors.onPrimary : AppColors.muted,
              ),
            ),
            Icon(
              Icons.calendar_today_outlined,
              color: AppColors.onPrimary,
              size: ResponsiveHelper.w(18),
            ),
          ],
        ),
      ),
    );
  }
}
