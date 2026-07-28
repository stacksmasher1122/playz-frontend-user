import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:redesign/theme/app_colors.dart';
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
      padding: EdgeInsets.all(ResponsiveHelper.w(18)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(18)),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isPlayZTurf
                      ? AppColors.accent.withValues(alpha: 0.15)
                      : Colors.white.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  isPlayZTurf ? Icons.stadium_rounded : Icons.location_on_rounded,
                  color: isPlayZTurf ? AppColors.accent : Colors.white70,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            venueName,
                            style: GoogleFonts.inter(
                              fontSize: ResponsiveHelper.sp(16),
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 6),
                        if (isPlayZTurf)
                          const Icon(
                            Icons.verified_rounded,
                            color: Color(0xFF34D399),
                            size: 18,
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: isPlayZTurf
                            ? const Color(0xFF059669).withValues(alpha: 0.2)
                            : Colors.white.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: isPlayZTurf
                              ? const Color(0xFF059669).withValues(alpha: 0.4)
                              : Colors.white12,
                        ),
                      ),
                      child: Text(
                        isPlayZTurf ? 'PLAYZ VERIFIED TURF' : 'UNOFFICIAL GROUND',
                        style: GoogleFonts.inter(
                          fontSize: ResponsiveHelper.sp(10),
                          fontWeight: FontWeight.bold,
                          color: isPlayZTurf ? const Color(0xFF34D399) : Colors.white60,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      address,
                      style: GoogleFonts.inter(
                        fontSize: ResponsiveHelper.sp(12),
                        color: AppColors.muted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: ResponsiveHelper.h(44),
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.accent,
                side: BorderSide(color: AppColors.accent.withValues(alpha: 0.5)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
                ),
              ),
              onPressed: _launchGoogleMaps,
              icon: const Icon(Icons.map_outlined, size: 18),
              label: Text(
                'Open Location in Google Maps',
                style: GoogleFonts.inter(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
