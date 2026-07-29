import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../../model/User_Models/Tournament_Model/venue_model.dart';

class VenueCard extends StatefulWidget {
  final VenueModel venue;
  final VoidCallback onSelect;

  const VenueCard({
    super.key,
    required this.venue,
    required this.onSelect,
  });

  @override
  State<VenueCard> createState() => _VenueCardState();
}

class _VenueCardState extends State<VenueCard> {
  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    final imageSize = context.minDimensionPct(20).clamp(72.0, 88.0);

    return GestureDetector(
      onTap: widget.onSelect,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: EdgeInsets.only(bottom: context.heightPct(1.8)),
        padding: EdgeInsets.all(context.widthPct(3)),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(context.minDimensionPct(4)),
          border: Border.all(
            color: widget.venue.isSelected ? AppColors.accent : AppColors.card,
            width: widget.venue.isSelected ? 1.5 : 1,
          ),
          boxShadow: widget.venue.isSelected
              ? [
                  BoxShadow(
                    color: AppColors.accent.withValues(alpha: 0.1),
                    blurRadius: 8,
                    spreadRadius: 1,
                  )
                ]
              : [],
        ),
        child: Row(
          children: [
            // Venue Image
            ClipRRect(
              borderRadius: BorderRadius.circular(context.minDimensionPct(3)),
              child: CachedNetworkImage(
                imageUrl: widget.venue.image,
                width: imageSize,
                height: imageSize,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  width: imageSize,
                  height: imageSize,
                  color: AppColors.surface,
                  child: const Center(
                    child: CircularProgressIndicator(color: AppColors.accent, strokeWidth: 2),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  width: imageSize,
                  height: imageSize,
                  color: AppColors.surface,
                  child: Icon(
                    Icons.image_not_supported_rounded,
                    color: AppColors.muted,
                    size: context.responsiveFont(24),
                  ),
                ),
              ),
            ),
            SizedBox(width: context.widthPct(3.5)),
            // Venue Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.venue.name,
                    style: AppTypography.headlineSm.copyWith(
                      color: AppColors.textPrimary,
                      fontSize: context.responsiveFont(14.5),
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: context.heightPct(0.5)),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        color: AppColors.muted,
                        size: context.responsiveFont(14),
                      ),
                      SizedBox(width: context.widthPct(1)),
                      Expanded(
                        child: Text(
                          "${widget.venue.distance} km away",
                          style: AppTypography.bodySm.copyWith(
                            color: AppColors.muted,
                            fontSize: context.responsiveFont(12),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: context.heightPct(0.5)),
                  Row(
                    children: [
                      Icon(
                        Icons.star_outline_rounded,
                        color: AppColors.accent,
                        size: context.responsiveFont(16),
                      ),
                      SizedBox(width: context.widthPct(1)),
                      Text(
                        "${widget.venue.rating}",
                        style: AppTypography.bodySm.copyWith(
                          color: AppColors.textPrimary,
                          fontSize: context.responsiveFont(12),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: context.widthPct(1)),
                      Expanded(
                        child: Text(
                          "(${widget.venue.reviewCount} reviews)",
                          style: AppTypography.bodySm.copyWith(
                            color: AppColors.muted,
                            fontSize: context.responsiveFont(11.5),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: context.widthPct(2)),
            // Select Button / Badge
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: widget.venue.isSelected
                  ? Container(
                      key: const ValueKey('selected'),
                      padding: EdgeInsets.symmetric(
                        horizontal: context.widthPct(2),
                        vertical: context.heightPct(0.5),
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.accent.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(context.minDimensionPct(1.5)),
                      ),
                      child: Text(
                        "SELECTED",
                        style: AppTypography.bodySm.copyWith(
                          color: AppColors.accent,
                          fontWeight: FontWeight.bold,
                          fontSize: context.responsiveFont(10),
                        ),
                      ),
                    )
                  : Container(
                      key: const ValueKey('unselected'),
                      padding: EdgeInsets.symmetric(
                        horizontal: context.widthPct(3.5),
                        vertical: context.heightPct(1),
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(context.minDimensionPct(2)),
                      ),
                      child: Text(
                        "Select",
                        style: AppTypography.bodySm.copyWith(
                          color: AppColors.textPrimary,
                          fontSize: context.responsiveFont(12.5),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
