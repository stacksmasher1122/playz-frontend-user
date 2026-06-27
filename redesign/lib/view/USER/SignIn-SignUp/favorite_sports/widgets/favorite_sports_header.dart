import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FavoriteSportsHeader extends StatelessWidget {
  const FavoriteSportsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select your favorites',
            style: GoogleFonts.inter(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Choose at least 4 sports to personalize your feed',
            style: GoogleFonts.inter(fontSize: 15, color: Colors.white70),
          ),
        ],
      ),
    );
  }
}
