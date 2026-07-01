import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

class MatchCategorySection extends StatelessWidget {
  final String selectedCategory;
  final ValueChanged<String> onCategoryChanged;

  MatchCategorySection({
    super.key,
    required this.selectedCategory,
    required this.onCategoryChanged,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader("MATCH CATEGORY"),
        SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildCategoryCard("MEN'S SINGLES", Icons.person_outline)),
            SizedBox(width: 12),
            Expanded(child: _buildCategoryCard("WOMEN'S SINGLES", Icons.person_3_outlined)),
          ],
        ),
        SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildCategoryCard("MEN'S DOUBLES", Icons.people_alt_outlined)),
            SizedBox(width: 12),
            Expanded(child: _buildCategoryCard("WOMEN'S DOUBLES", Icons.people_outline)),
          ],
        ),
        SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildCategoryCard("MIXED DOUBLES", Icons.wc_outlined)),
            SizedBox(width: 12),
            Expanded(child: SizedBox()), // Empty slot for grid alignment
          ],
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      children: [
        Container(width: ResponsiveHelper.w(3), height: ResponsiveHelper.h(16), color: AppColors.accent, margin: EdgeInsets.only(right: 8)),
        Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: ResponsiveHelper.sp(12),
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryCard(String title, IconData icon) {
    bool isSelected = selectedCategory == title;
    return GestureDetector(
      onTap: () => onCategoryChanged(title),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(16)),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.accent : Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(8)),
          border: Border.all(
            color: isSelected ? AppColors.accent : Colors.transparent,
            width: ResponsiveHelper.w(1),
          ),
          boxShadow: isSelected
              ? [BoxShadow(color: AppColors.accent.withValues(alpha: 0.2), blurRadius: 8)]
              : [],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: isSelected ? Colors.black : Colors.white, size: 24),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.black : Colors.white,
                fontSize: ResponsiveHelper.sp(10),
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
