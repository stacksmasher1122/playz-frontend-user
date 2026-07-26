import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

class EquipmentStatusCard extends StatelessWidget {
  final String option; // 'carry_own', 'provided', or 'none'

  const EquipmentStatusCard({
    super.key,
    required this.option,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    if (option == 'none' || option.isEmpty) return const SizedBox.shrink();

    final isProvided = option == 'provided';
    final title = isProvided ? 'Equipment Provided' : 'Carry Your Own Equipment';
    final subtitle = isProvided
        ? 'The host or venue will provide sports equipment.'
        : 'Please bring your own sports equipment to the match.';
    final icon = isProvided ? Icons.inventory_2_outlined : Icons.backpack_outlined;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(ResponsiveHelper.w(16)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(18)),
        border: Border.all(color: AppColors.accent.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.accent, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: ResponsiveHelper.sp(14),
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: ResponsiveHelper.sp(11.5),
                    color: Colors.white60,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
