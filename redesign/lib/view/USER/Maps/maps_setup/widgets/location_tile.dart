import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class LocationTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String? tag;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const LocationTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.tag,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      margin: EdgeInsets.only(bottom: context.heightPct(1.5)),
      padding: EdgeInsets.all(context.widthPct(3.5)),
      decoration: BoxDecoration(
        color: AppColors.card.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(context.minDimensionPct(4)),
        border: Border.all(color: AppColors.borderDark),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(context.widthPct(2.5)),
            decoration: BoxDecoration(
              color: AppColors.textPrimary.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(context.minDimensionPct(2.5)),
            ),
            child: Icon(icon, color: AppColors.muted, size: 20),
          ),
          SizedBox(width: context.widthPct(3.5)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        title,
                        style: AppTypography.headlineSm.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                          fontSize: context.responsiveFont(14),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (tag != null) ...[
                      SizedBox(width: context.widthPct(2)),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: context.widthPct(1.5),
                          vertical: context.heightPct(0.3),
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.accent.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(context.minDimensionPct(1)),
                        ),
                        child: Text(
                          tag!,
                          style: AppTypography.labelCaps10.copyWith(
                            color: AppColors.accent,
                            fontSize: context.responsiveFont(8),
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                SizedBox(height: context.heightPct(0.4)),
                Text(
                  subtitle,
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.muted,
                    fontSize: context.responsiveFont(12),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (onEdit != null || onDelete != null)
            PopupMenuButton<String>(
              icon: const Icon(
                Icons.more_vert,
                color: AppColors.muted,
                size: 20,
              ),
              color: AppColors.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(context.minDimensionPct(3)),
                side: const BorderSide(color: AppColors.borderDark),
              ),
              onSelected: (val) {
                if (val == 'edit') {
                  onEdit?.call();
                } else if (val == 'delete') {
                  onDelete?.call();
                }
              },
              itemBuilder: (context) => [
                if (onEdit != null)
                  PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        const Icon(
                          Icons.edit_outlined,
                          color: AppColors.accent,
                          size: 18,
                        ),
                        SizedBox(width: context.widthPct(2.5)),
                        Text(
                          'Edit',
                          style: AppTypography.bodySm.copyWith(
                            color: AppColors.textPrimary,
                            fontSize: context.responsiveFont(13),
                          ),
                        ),
                      ],
                    ),
                  ),
                if (onDelete != null)
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        const Icon(
                          Icons.delete_outline,
                          color: AppColors.error,
                          size: 18,
                        ),
                        SizedBox(width: context.widthPct(2.5)),
                        Text(
                          'Delete',
                          style: AppTypography.bodySm.copyWith(
                            color: AppColors.error,
                            fontSize: context.responsiveFont(13),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}
