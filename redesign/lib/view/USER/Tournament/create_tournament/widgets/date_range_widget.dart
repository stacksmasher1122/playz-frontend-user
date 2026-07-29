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
    ResponsiveHelper.init(context);

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                "Start Date",
                style: AppTypography.headlineSm.copyWith(
                  color: AppColors.textPrimary,
                  fontSize: context.responsiveFont(15),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(width: context.widthPct(4)),
            Expanded(
              child: Text(
                "End Date",
                style: AppTypography.headlineSm.copyWith(
                  color: AppColors.textPrimary,
                  fontSize: context.responsiveFont(15),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: context.heightPct(1)),
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
            SizedBox(width: context.widthPct(4)),
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
        height: context.heightPct(6.5).clamp(48.0, 56.0),
        padding: EdgeInsets.symmetric(horizontal: context.widthPct(3.5)),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(context.minDimensionPct(3.5)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                text,
                style: AppTypography.bodyMd.copyWith(
                  color: hasDate ? AppColors.textPrimary : AppColors.muted,
                  fontSize: context.responsiveFont(13.5),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(
              Icons.calendar_today_outlined,
              color: AppColors.textPrimary,
              size: context.responsiveFont(18),
            ),
          ],
        ),
      ),
    );
  }
}
