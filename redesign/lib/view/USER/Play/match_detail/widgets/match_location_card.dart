import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class MatchLocationCard extends StatelessWidget {
  final String venueName;
  final String address;
  final String locationType;

  const MatchLocationCard({
    super.key,
    this.venueName = "PlayZ Sports Arena",
    this.address = "FC Road, Shivajinagar, Pune, Maharashtra 411005",
    this.locationType = 'playz_turf',
  });

  Future<void> _launchGoogleMaps() async {
    final query = Uri.encodeComponent('$venueName $address'.trim());
    final uri = Uri.parse('https://www.google.com/maps/search/?api=1&query=$query');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    final bool isPlayZTurf = locationType == 'playz_turf';

    return Container(
      padding: EdgeInsets.all(context.widthPct(4.5)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(context.minDimensionPct(4.5)),
        border: Border.all(color: AppColors.borderDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(context.widthPct(2.5)),
                decoration: BoxDecoration(
                  color: isPlayZTurf
                      ? AppColors.accent.withValues(alpha: 0.15)
                      : AppColors.textPrimary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(context.minDimensionPct(3)),
                ),
                child: Icon(
                  isPlayZTurf ? Icons.stadium_rounded : Icons.location_on_rounded,
                  color: isPlayZTurf ? AppColors.accent : AppColors.textSecondary,
                  size: 22,
                ),
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
                            venueName,
                            style: AppTypography.headlineSm.copyWith(
                              fontSize: context.responsiveFont(16),
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: context.widthPct(1.5)),
                        if (isPlayZTurf)
                          const Icon(
                            Icons.verified_rounded,
                            color: Color(0xFF34D399),
                            size: 18,
                          ),
                      ],
                    ),
                    SizedBox(height: context.heightPct(0.5)),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.widthPct(2),
                        vertical: context.heightPct(0.3),
                      ),
                      decoration: BoxDecoration(
                        color: isPlayZTurf
                            ? const Color(0xFF059669).withValues(alpha: 0.2)
                            : AppColors.textPrimary.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(context.minDimensionPct(1.5)),
                        border: Border.all(
                          color: isPlayZTurf
                              ? const Color(0xFF059669).withValues(alpha: 0.4)
                              : AppColors.borderDark,
                        ),
                      ),
                      child: Text(
                        isPlayZTurf ? 'PLAYZ VERIFIED TURF' : 'UNOFFICIAL GROUND',
                        style: AppTypography.labelCaps10.copyWith(
                          fontSize: context.responsiveFont(10),
                          fontWeight: FontWeight.bold,
                          color: isPlayZTurf ? const Color(0xFF34D399) : AppColors.muted,
                        ),
                      ),
                    ),
                    SizedBox(height: context.heightPct(0.8)),
                    Text(
                      address,
                      style: AppTypography.bodySm.copyWith(
                        fontSize: context.responsiveFont(12),
                        color: AppColors.muted,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: context.heightPct(2)),
          SizedBox(
            width: double.infinity,
            height: context.heightPct(5.5).clamp(44.0, 52.0),
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.accent,
                side: BorderSide(color: AppColors.accent.withValues(alpha: 0.5)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(context.minDimensionPct(3)),
                ),
              ),
              onPressed: _launchGoogleMaps,
              icon: const Icon(Icons.map_outlined, size: 18),
              label: Text(
                'Open Location in Google Maps',
                style: AppTypography.headlineSm.copyWith(
                  fontSize: context.responsiveFont(13),
                  fontWeight: FontWeight.bold,
                  color: AppColors.accent,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
