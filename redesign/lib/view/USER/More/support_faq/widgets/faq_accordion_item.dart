import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/model/User_Models/More_Models/support_faq_model.dart';

class FaqAccordionItem extends StatelessWidget {
  final FaqItemModel item;
  final VoidCallback onToggle;
  final Function(bool) onVote;

  const FaqAccordionItem({
    super.key,
    required this.item,
    required this.onToggle,
    required this.onVote,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: context.widthPct(4),
        vertical: context.heightPct(0.8),
      ),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(context.minDimensionPct(4)),
        border: Border.all(
          color: item.isExpanded ? AppColors.accent.withValues(alpha: 0.5) : AppColors.borderDark,
        ),
      ),
      child: Column(
        children: [
          ListTile(
            onTap: onToggle,
            contentPadding: EdgeInsets.symmetric(
              horizontal: context.widthPct(4),
              vertical: context.heightPct(0.5),
            ),
            title: Text(
              item.question,
              style: AppTypography.headlineSm.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
                fontSize: context.responsiveFont(14),
              ),
            ),
            trailing: Icon(
              item.isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
              color: item.isExpanded ? AppColors.accent : AppColors.muted,
            ),
          ),
          if (item.isExpanded) ...[
            const Divider(color: AppColors.borderDark, height: 1),
            Padding(
              padding: EdgeInsets.all(context.widthPct(4)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.answer,
                    style: AppTypography.bodySm.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: context.responsiveFont(13),
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: context.heightPct(1.8)),
                  Row(
                    children: [
                      Text(
                        'Was this helpful?',
                        style: AppTypography.bodySm.copyWith(
                          color: AppColors.muted,
                          fontSize: context.responsiveFont(12),
                        ),
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: () => onVote(true),
                        borderRadius: BorderRadius.circular(context.minDimensionPct(2)),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: context.widthPct(2.5),
                            vertical: context.heightPct(0.5),
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.textPrimary.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(context.minDimensionPct(2)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.thumb_up_alt_outlined, color: AppColors.accent, size: 14),
                              SizedBox(width: context.widthPct(1)),
                              Text(
                                '${item.helpfulCount}',
                                style: AppTypography.bodySm.copyWith(
                                  color: AppColors.textSecondary,
                                  fontSize: context.responsiveFont(12),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: context.widthPct(2)),
                      InkWell(
                        onTap: () => onVote(false),
                        borderRadius: BorderRadius.circular(context.minDimensionPct(2)),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: context.widthPct(2.5),
                            vertical: context.heightPct(0.5),
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.textPrimary.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(context.minDimensionPct(2)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.thumb_down_alt_outlined, color: AppColors.muted, size: 14),
                              SizedBox(width: context.widthPct(1)),
                              Text(
                                '${item.unhelpfulCount}',
                                style: AppTypography.bodySm.copyWith(
                                  color: AppColors.textSecondary,
                                  fontSize: context.responsiveFont(12),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
