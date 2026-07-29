import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class SearchBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const SearchBarWidget({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(
        context.widthPct(4),
        context.heightPct(1),
        context.widthPct(4),
        context.heightPct(1.5),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: context.widthPct(3.5)),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(context.minDimensionPct(6)),
          border: Border.all(color: AppColors.borderDark),
        ),
        child: TextField(
          controller: controller,
          focusNode: focusNode,
          onChanged: onChanged,
          style: AppTypography.bodySm.copyWith(
            color: AppColors.textPrimary,
            fontSize: context.responsiveFont(14),
          ),
          decoration: InputDecoration(
            icon: const Icon(Icons.search, color: AppColors.muted),
            hintText: 'Find friends, squads, or nearby players...',
            hintStyle: AppTypography.bodySm.copyWith(
              color: AppColors.muted,
              fontSize: context.responsiveFont(13),
            ),
            border: InputBorder.none,
            suffixIcon: ValueListenableBuilder<TextEditingValue>(
              valueListenable: controller,
              builder: (_, value, __) {
                if (value.text.isEmpty) return const SizedBox.shrink();
                return IconButton(
                  icon: const Icon(Icons.close, color: AppColors.muted, size: 20),
                  onPressed: onClear,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
