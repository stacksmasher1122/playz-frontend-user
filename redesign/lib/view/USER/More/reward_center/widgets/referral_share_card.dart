import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class ReferralShareCard extends StatelessWidget {
  final String code;

  const ReferralShareCard({super.key, required this.code});

  void _copyToClipboard(BuildContext context) {
    Clipboard.setData(ClipboardData(text: code));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Referral Code "$code" copied to clipboard!'),
        backgroundColor: AppColors.accent,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _shareApp(BuildContext context) {
    final text = 'Hey! Join me on PlayZ to book turfs and track live scoreboards! Use my referral code $code to get 500 FREE Z-Coins!';
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Invitation link & code copied! Share with your friends via WhatsApp or Messages.'),
        backgroundColor: AppColors.accent,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: context.widthPct(4),
        vertical: context.heightPct(1),
      ),
      padding: EdgeInsets.all(context.widthPct(5)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(context.minDimensionPct(6)),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.card,
            AppColors.accent.withValues(alpha: 0.12),
          ],
        ),
        border: Border.all(color: AppColors.accent.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(context.widthPct(2.5)),
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.group_add_rounded, color: AppColors.accent, size: 24),
              ),
              SizedBox(width: context.widthPct(3)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Invite Friends & Earn 500 Coins',
                      style: AppTypography.headlineSm.copyWith(
                        color: AppColors.textPrimary,
                        fontSize: context.responsiveFont(15),
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: context.heightPct(0.3)),
                    Text(
                      'Your friend gets 500 coins on signup too!',
                      style: AppTypography.bodySm.copyWith(
                        color: AppColors.muted,
                        fontSize: context.responsiveFont(12),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: context.heightPct(2)),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: context.widthPct(4),
              vertical: context.heightPct(1.2),
            ),
            decoration: BoxDecoration(
              color: AppColors.background.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(context.minDimensionPct(4)),
              border: Border.all(color: AppColors.borderDark),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'YOUR REFERRAL CODE',
                        style: AppTypography.labelCaps10.copyWith(
                          color: AppColors.muted,
                          fontSize: context.responsiveFont(10),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: context.heightPct(0.3)),
                      Text(
                        code,
                        style: AppTypography.headlineSm.copyWith(
                          color: AppColors.accent,
                          fontSize: context.responsiveFont(16),
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.5,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                TextButton.icon(
                  onPressed: () => _copyToClipboard(context),
                  icon: const Icon(Icons.copy_rounded, color: AppColors.textSecondary, size: 16),
                  label: Text(
                    'Copy',
                    style: AppTypography.headlineSm.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: context.responsiveFont(12),
                    ),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: AppColors.textPrimary.withValues(alpha: 0.08),
                    padding: EdgeInsets.symmetric(
                      horizontal: context.widthPct(3),
                      vertical: context.heightPct(1),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(context.minDimensionPct(2.5)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: context.heightPct(1.8)),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _shareApp(context),
              icon: const Icon(Icons.share_rounded, color: AppColors.background, size: 18),
              label: Text(
                'Share PlayZ App Now',
                style: AppTypography.headlineSm.copyWith(
                  color: AppColors.background,
                  fontWeight: FontWeight.bold,
                  fontSize: context.responsiveFont(14),
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                padding: EdgeInsets.symmetric(vertical: context.heightPct(1.8)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(context.minDimensionPct(3.5)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
