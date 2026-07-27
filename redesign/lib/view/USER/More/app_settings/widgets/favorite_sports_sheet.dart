import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FavoriteSportsSheet extends StatelessWidget {
  final List<String> allSports;
  final List<String> selectedSports;
  final ValueChanged<String> onToggle;

  const FavoriteSportsSheet({
    super.key,
    required this.allSports,
    required this.selectedSports,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Color(0xFF1E1E1E),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const Icon(Icons.sports_soccer, color: Color(0xFF00E676), size: 24),
              const SizedBox(width: 10),
              Text(
                'Customize Favorite Sports',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Select sports to customize your home feed and match recommendations.',
            style: GoogleFonts.inter(color: Colors.white54, fontSize: 13),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: allSports.map((sport) {
              final isSelected = selectedSports.contains(sport);
              return StatefulBuilder(
                builder: (context, setState) {
                  return ChoiceChip(
                    label: Text(sport),
                    selected: isSelected,
                    selectedColor: const Color(0xFF00E676),
                    backgroundColor: Colors.white.withValues(alpha: 0.06),
                    labelStyle: GoogleFonts.inter(
                      color: isSelected ? Colors.black : Colors.white,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: isSelected ? const Color(0xFF00E676) : Colors.transparent,
                      ),
                    ),
                    onSelected: (_) {
                      onToggle(sport);
                      (context as Element).markNeedsBuild();
                    },
                  );
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00E676),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Text(
                'Done',
                style: GoogleFonts.inter(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
