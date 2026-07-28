import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

class LeaderboardScopeToggle extends StatelessWidget {
  final String selectedScope;
  final ValueChanged<String> onScopeChanged;

  const LeaderboardScopeToggle({
    super.key,
    required this.selectedScope,
    required this.onScopeChanged,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final scopes = ['Friends', 'City', 'Global'];

    return Container(
      margin: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16)),
      padding: EdgeInsets.all(ResponsiveHelper.w(4)),
      decoration: BoxDecoration(
        color: const Color(0xFF181818),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: scopes.map((scope) {
          final isSelected = scope == selectedScope;
          return Expanded(
            child: InkWell(
              onTap: () => onScopeChanged(scope),
              borderRadius: BorderRadius.circular(12),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(10)),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.accent : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    scope,
                    style: GoogleFonts.inter(
                      color: isSelected ? Colors.black : Colors.white70,
                      fontSize: ResponsiveHelper.sp(13),
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
