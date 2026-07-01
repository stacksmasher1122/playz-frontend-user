import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

class TrainersToggle extends StatelessWidget {
  final bool isMyTrainers;
  final ValueChanged<bool> onChanged;

  TrainersToggle({
    super.key,
    required this.isMyTrainers,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      margin: EdgeInsets.fromLTRB(16, 8, 16, 12),
      padding: EdgeInsets.all(ResponsiveHelper.w(4)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(28)),
      ),
      child: Row(
        children: [
          _tab(
            label: 'My Trainers',
            active: isMyTrainers,
            onTap: () => onChanged(true),
          ),
          _tab(
            label: 'Other Trainers',
            active: !isMyTrainers,
            onTap: () => onChanged(false),
          ),
        ],
      ),
    );
  }

  Widget _tab({
    required String label,
    required bool active,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 220),
          curve: Curves.easeOut,
          padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(12)),
          decoration: BoxDecoration(
            color: active ? AppColors.accent : Colors.transparent,
            borderRadius: BorderRadius.circular(ResponsiveHelper.w(24)),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              color: active ? Colors.black : Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
