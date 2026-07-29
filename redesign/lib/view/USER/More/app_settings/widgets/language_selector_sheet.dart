import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class LanguageSelectorSheet extends StatelessWidget {
  final List<String> languages;
  final String currentLanguage;
  final ValueChanged<String> onSelected;

  const LanguageSelectorSheet({
    super.key,
    required this.languages,
    required this.currentLanguage,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      padding: EdgeInsets.all(context.widthPct(6)),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.vertical(top: Radius.circular(context.minDimensionPct(6))),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: context.widthPct(10),
              height: context.heightPct(0.5),
              decoration: BoxDecoration(
                color: AppColors.borderDark,
                borderRadius: BorderRadius.circular(context.minDimensionPct(1)),
              ),
            ),
          ),
          SizedBox(height: context.heightPct(2.5)),
          Row(
            children: [
              const Icon(Icons.language_rounded, color: AppColors.accent, size: 24),
              SizedBox(width: context.widthPct(2.5)),
              Expanded(
                child: Text(
                  'Select Preferred Language',
                  style: AppTypography.headlineSm.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: context.responsiveFont(18),
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: context.heightPct(2)),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: languages.length,
              itemBuilder: (context, index) {
                final lang = languages[index];
                final isSelected = lang == currentLanguage;
                return Container(
                  margin: EdgeInsets.only(bottom: context.heightPct(1)),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.accent.withValues(alpha: 0.15)
                        : AppColors.textPrimary.withValues(alpha: 0.04),
                    borderRadius: BorderRadius.circular(context.minDimensionPct(3.5)),
                    border: Border.all(
                      color: isSelected ? AppColors.accent : Colors.transparent,
                    ),
                  ),
                  child: ListTile(
                    onTap: () {
                      onSelected(lang);
                      Navigator.pop(context);
                    },
                    title: Text(
                      lang,
                      style: AppTypography.bodySm.copyWith(
                        color: isSelected ? AppColors.accent : AppColors.textPrimary,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        fontSize: context.responsiveFont(14),
                      ),
                    ),
                    trailing: isSelected
                        ? const Icon(Icons.check_circle_rounded, color: AppColors.accent)
                        : null,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
