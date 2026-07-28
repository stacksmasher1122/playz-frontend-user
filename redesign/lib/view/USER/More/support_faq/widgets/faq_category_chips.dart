import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FaqCategoryChips extends StatelessWidget {
  final List<String> categories;
  final String selectedCategory;
  final ValueChanged<String> onSelected;

  const FaqCategoryChips({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final cat = categories[index];
          final isSelected = cat == selectedCategory;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(cat),
              selected: isSelected,
              selectedColor: const Color(0xFF00E676),
              backgroundColor: const Color(0xFF1E1E1E),
              labelStyle: GoogleFonts.inter(
                color: isSelected ? Colors.black : Colors.white70,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                fontSize: 13,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isSelected ? const Color(0xFF00E676) : Colors.white10,
                ),
              ),
              onSelected: (_) => onSelected(cat),
            ),
          );
        },
      ),
    );
  }
}
