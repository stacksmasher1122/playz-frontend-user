import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

class SeriesFormatSection extends StatelessWidget {
  final String selectedFormat;
  final ValueChanged<String> onFormatChanged;

  SeriesFormatSection({
    super.key,
    required this.selectedFormat,
    required this.onFormatChanged,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.w(20)),
      decoration: BoxDecoration(
        color: Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "SERIES FORMAT",
            style: TextStyle(
              color: Colors.white,
              fontSize: ResponsiveHelper.sp(12),
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          SizedBox(height: 20),
          Row(
            children: [
              _buildRadioOption("Best of 1"),
              SizedBox(width: 24),
              _buildRadioOption("Best of 3"),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              _buildRadioOption("Best of 5"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRadioOption(String title) {
    bool isSelected = selectedFormat == title;
    return GestureDetector(
      onTap: () => onFormatChanged(title),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: ResponsiveHelper.w(20),
            height: ResponsiveHelper.h(20),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? AppColors.accent : AppColors.muted,
                width: ResponsiveHelper.w(2),
              ),
            ),
            child: isSelected
                ? Center(
                    child: Container(
                      width: ResponsiveHelper.w(10),
                      height: ResponsiveHelper.h(10),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.accent,
                      ),
                    ),
                  )
                : null,
          ),
          SizedBox(width: 12),
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: ResponsiveHelper.sp(16),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
