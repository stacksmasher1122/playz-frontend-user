import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FaqSearchBar extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const FaqSearchBar({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: TextField(
        onChanged: onChanged,
        style: GoogleFonts.inter(color: Colors.white, fontSize: 14),
        decoration: InputDecoration(
          hintText: 'Search FAQs, scoreboards, bookings...',
          hintStyle: GoogleFonts.inter(color: Colors.white38, fontSize: 14),
          prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF00E676)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}
