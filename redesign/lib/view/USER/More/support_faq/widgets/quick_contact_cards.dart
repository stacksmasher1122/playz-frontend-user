import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class QuickContactCards extends StatelessWidget {
  final VoidCallback onLiveChatTap;
  final VoidCallback onCallTap;
  final VoidCallback onRaiseTicketTap;

  const QuickContactCards({
    super.key,
    required this.onLiveChatTap,
    required this.onCallTap,
    required this.onRaiseTicketTap,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.widthPct(4),
        vertical: context.heightPct(1),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildContactItem(
              context: context,
              icon: Icons.support_agent_rounded,
              title: 'Live Chat',
              subtitle: '24/7 Support',
              color: AppColors.accent,
              onTap: onLiveChatTap,
            ),
          ),
          SizedBox(width: context.widthPct(2.5)),
          Expanded(
            child: _buildContactItem(
              context: context,
              icon: Icons.phone_in_talk_rounded,
              title: 'Call Us',
              subtitle: 'Mon-Sat 9-7',
              color: AppColors.infoBlue,
              onTap: onCallTap,
            ),
          ),
          SizedBox(width: context.widthPct(2.5)),
          Expanded(
            child: _buildContactItem(
              context: context,
              icon: Icons.confirmation_number_outlined,
              title: 'Raise Ticket',
              subtitle: 'Track Issue',
              color: AppColors.coinsGold,
              onTap: onRaiseTicketTap,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(context.minDimensionPct(4)),
        border: Border.all(color: AppColors.borderDark),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(context.minDimensionPct(4)),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: context.heightPct(1.8),
              horizontal: context.widthPct(2),
            ),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(context.widthPct(2.5)),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: 22),
                ),
                SizedBox(height: context.heightPct(1)),
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.headlineSm.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: context.responsiveFont(13),
                  ),
                ),
                SizedBox(height: context.heightPct(0.3)),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.muted,
                    fontSize: context.responsiveFont(11),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
