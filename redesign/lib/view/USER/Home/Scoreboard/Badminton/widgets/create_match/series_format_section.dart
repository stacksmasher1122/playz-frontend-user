import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';

class SeriesFormatSection extends StatelessWidget {
  final String selectedFormat;
  final ValueChanged<String> onFormatChanged;

  const SeriesFormatSection({
    super.key,
    required this.selectedFormat,
    required this.onFormatChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "SERIES FORMAT",
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _buildRadioOption("Best of 1"),
              const SizedBox(width: 24),
              _buildRadioOption("Best of 3"),
            ],
          ),
          const SizedBox(height: 16),
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
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? AppColors.accent : AppColors.muted,
                width: 2,
              ),
            ),
            child: isSelected
                ? Center(
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.accent,
                      ),
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
