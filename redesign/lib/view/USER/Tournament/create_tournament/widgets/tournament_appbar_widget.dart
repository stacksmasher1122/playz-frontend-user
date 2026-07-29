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
    ResponsiveHelper.init(context);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.widthPct(4),
        vertical: context.heightPct(1.2),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: widget.onBack,
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: AppColors.textPrimary,
              size: context.responsiveFont(18),
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              "Create Tournament",
              style: AppTypography.headlineMd.copyWith(
                color: AppColors.accent,
                fontSize: context.responsiveFont(18),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          IconButton(
            onPressed: widget.onClose,
            icon: Icon(
              Icons.close_rounded,
              color: AppColors.textPrimary,
              size: context.responsiveFont(22),
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}
