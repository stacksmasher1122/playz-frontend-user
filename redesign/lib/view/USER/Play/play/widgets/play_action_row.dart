import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redesign/theme/app_colors.dart';

class PlayActionRow extends StatelessWidget {
  const PlayActionRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          Text(
            'Host Game +',
            style: GoogleFonts.inter(
              color: AppColors.accent,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          Row(
            children: [
              const Icon(Icons.swap_vert, color: Colors.white, size: 16),
              const SizedBox(width: 4),
              Text('Sort', style: GoogleFonts.inter(color: Colors.white)),
            ],
          ),
        ],
      ),
    );
  }
}
