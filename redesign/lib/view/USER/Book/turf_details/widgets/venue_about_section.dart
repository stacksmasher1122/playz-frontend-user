import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class VenueAboutSection extends StatelessWidget {
  final String description;
  final bool isExpanded;
  final VoidCallback onToggleExpand;

  const VenueAboutSection({
    super.key,
    required this.description,
    required this.isExpanded,
    required this.onToggleExpand,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final mapHeight = context.heightPct(18).clamp(130.0, 170.0);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.widthPct(4)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About Venue',
            style: AppTypography.headlineSm.copyWith(
              color: AppColors.textPrimary,
              fontSize: context.responsiveFont(18),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: context.heightPct(0.8)),
          Text(
            description.isNotEmpty
                ? description
                : 'No description available for this venue.',
            maxLines: isExpanded ? null : 3,
            overflow: isExpanded ? null : TextOverflow.ellipsis,
            style: AppTypography.bodySm.copyWith(
              color: AppColors.muted,
              fontSize: context.responsiveFont(14),
              height: 1.4,
            ),
          ),
          if (description.length > 100)
            GestureDetector(
              onTap: onToggleExpand,
              child: Padding(
                padding: EdgeInsets.only(top: context.heightPct(0.5)),
                child: Text(
                  isExpanded ? 'Read less' : 'Read more',
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.accent,
                    fontSize: context.responsiveFont(13),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          SizedBox(height: context.heightPct(1.5)),
          ClipRRect(
            borderRadius: BorderRadius.circular(context.minDimensionPct(3)),
            child: Stack(
              children: [
                Image.network(
                  'https://images.unsplash.com/photo-1524661135-423995f22d0b?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8N3x8bWFwc3xlbnwwfHwwfHx8MA%3D%3D',
                  height: mapHeight,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  bottom: context.heightPct(1),
                  right: context.widthPct(2),
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      foregroundColor: AppColors.textPrimary,
                      backgroundColor: AppColors.background.withValues(alpha: 0.7),
                    ),
                    icon: const Icon(Icons.directions, size: 16),
                    label: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        'Get Directions',
                        style: AppTypography.bodySm.copyWith(
                          color: AppColors.textPrimary,
                          fontSize: context.responsiveFont(12),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
