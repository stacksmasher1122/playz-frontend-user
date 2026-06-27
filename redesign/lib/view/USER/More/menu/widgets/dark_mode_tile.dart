import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redesign/theme/app_colors.dart';

class DarkModeTile extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const DarkModeTile({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SwitchListTile(
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.accent,
        title: Text('Dark Mode', style: GoogleFonts.inter(color: Colors.white)),
      ),
    );
  }
}
