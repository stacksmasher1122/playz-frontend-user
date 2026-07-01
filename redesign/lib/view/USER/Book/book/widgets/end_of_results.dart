import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:shimmer/shimmer.dart';
import 'package:redesign/theme/responsive_helper.dart';

class EndOfResults extends StatelessWidget {
  EndOfResults({super.key});

  static const _illustrationUrl =
      'https://illustrations.popsy.co/gray/sporty-man.svg';

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final width = MediaQuery.of(context).size.width;

    /// Responsive sizing
    final imageSize = width < 360
        ? 90.0
        : width < 600
        ? 120.0
        : 140.0;

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 36, 20, 48),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// ILLUSTRATION (CACHED + SHIMMER)
          CachedNetworkImage(
            imageUrl: _illustrationUrl,
            height: imageSize,
            width: imageSize,
            fit: BoxFit.contain,
            placeholder: (_, __) => Shimmer.fromColors(
              baseColor: Colors.grey.shade800,
              highlightColor: Colors.grey.shade700,
              child: Container(
                height: imageSize,
                width: imageSize,
                decoration: BoxDecoration(
                  color: Colors.grey.shade800,
                  borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
                ),
              ),
            ),
            errorWidget: (_, __, ___) => Icon(
              Icons.sports_soccer,
              size: imageSize * 0.6,
              color: AppColors.muted.withValues(alpha: 0.6),
            ),
          ),

          SizedBox(height: 20),

          /// TITLE
          Text(
            'You’ve reached the end!',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: ResponsiveHelper.sp(16),
              fontWeight: FontWeight.w700,
            ),
          ),

          SizedBox(height: 8),

          /// SUBTITLE
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 320),
            child: Text(
              'No more turfs nearby. Try exploring a new sport or adjust your filters.',
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                color: AppColors.muted,
                fontSize: ResponsiveHelper.sp(13),
                height: ResponsiveHelper.h(1.4),
              ),
            ),
          ),

          SizedBox(height: 18),

          /// CTA BUTTON (OPTIONAL, FUTURE READY)
          OutlinedButton(
            onPressed: () {
              // 🔮 Future upgrade:
              // - Reset filters
              // - Open sport selector
              // - Expand radius
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.accent,
              side: BorderSide(color: AppColors.accent),
              padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(18), vertical: ResponsiveHelper.h(10)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(ResponsiveHelper.w(22)),
              ),
            ),
            child: Text(
              'Explore Other Sports',
              style: GoogleFonts.inter(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
