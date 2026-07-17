import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class TournamentAppbarWidget extends StatefulWidget {
  final VoidCallback onBack;
  final VoidCallback onClose;

  const TournamentAppbarWidget({
    super.key,
    required this.onBack,
    required this.onClose,
  });

  
  @override
  State<TournamentAppbarWidget> createState() => _TournamentAppbarWidgetState();
}

class _TournamentAppbarWidgetState extends State<TournamentAppbarWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.w(16),
        vertical: ResponsiveHelper.h(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: widget.onBack,
            icon: Icon(Icons.arrow_back_ios, color: AppColors.onPrimary, size: ResponsiveHelper.w(20)),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          Text(
            "Create Tournament",
            style: AppTypography.headlineMd.copyWith(
              color: AppColors.accent,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            onPressed: widget.onClose,
            icon: Icon(Icons.close, color: AppColors.onPrimary, size: ResponsiveHelper.w(24)),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}
