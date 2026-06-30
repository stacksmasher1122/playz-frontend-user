import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';

class MatchCategorySection extends StatelessWidget {
  final String selectedCategory;
  final ValueChanged<String> onCategoryChanged;

  const MatchCategorySection({
    super.key,
    required this.selectedCategory,
    required this.onCategoryChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader("MATCH CATEGORY"),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildCategoryCard("MEN'S SINGLES", Icons.person_outline)),
            const SizedBox(width: 12),
            Expanded(child: _buildCategoryCard("WOMEN'S SINGLES", Icons.person_3_outlined)),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildCategoryCard("MEN'S DOUBLES", Icons.people_alt_outlined)),
            const SizedBox(width: 12),
            Expanded(child: _buildCategoryCard("WOMEN'S DOUBLES", Icons.people_outline)),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildCategoryCard("MIXED DOUBLES", Icons.wc_outlined)),
            const SizedBox(width: 12),
            const Expanded(child: SizedBox()), // Empty slot for grid alignment
          ],
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      children: [
        Container(width: 3, height: 16, color: AppColors.accent, margin: const EdgeInsets.only(right: 8)),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
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
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.accent : const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.accent : Colors.transparent,
            width: 1,
          ),
          boxShadow: isSelected
              ? [BoxShadow(color: AppColors.accent.withOpacity(0.2), blurRadius: 8)]
              : [],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: isSelected ? Colors.black : Colors.white, size: 24),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.black : Colors.white,
                fontSize: 10,
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
