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
    return GestureDetector(
      onTap: widget.onSelect,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: EdgeInsets.only(bottom: ResponsiveHelper.h(16)),
        padding: EdgeInsets.all(ResponsiveHelper.w(12)),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
          border: Border.all(
            color: widget.venue.isSelected ? AppColors.accent : Colors.transparent,
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
              borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
              child: CachedNetworkImage(
                imageUrl: widget.venue.image,
                width: ResponsiveHelper.w(80),
                height: ResponsiveHelper.w(80),
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  width: ResponsiveHelper.w(80),
                  height: ResponsiveHelper.w(80),
                  color: AppColors.surface,
                  child: const Center(
                    child: CircularProgressIndicator(color: AppColors.accent, strokeWidth: 2),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  width: ResponsiveHelper.w(80),
                  height: ResponsiveHelper.w(80),
                  color: AppColors.surface,
                  child: Icon(Icons.image_not_supported, color: AppColors.muted),
                ),
              ),
            ),
            SizedBox(width: ResponsiveHelper.w(16)),
            // Venue Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.venue.name,
                    style: AppTypography.headlineSm.copyWith(
                      color: AppColors.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: ResponsiveHelper.h(4)),
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined, color: AppColors.muted, size: ResponsiveHelper.w(14)),
                      SizedBox(width: ResponsiveHelper.w(4)),
                      Text(
                        "${widget.venue.distance} km away",
                        style: AppTypography.bodySm.copyWith(color: AppColors.muted),
                      ),
                    ],
                  ),
                  SizedBox(height: ResponsiveHelper.h(4)),
                  Row(
                    children: [
                      Icon(Icons.star_outline, color: AppColors.accent, size: ResponsiveHelper.w(16)),
                      SizedBox(width: ResponsiveHelper.w(4)),
                      Text(
                        "${widget.venue.rating}",
                        style: AppTypography.bodySm.copyWith(
                          color: AppColors.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: ResponsiveHelper.w(4)),
                      Text(
                        "(${widget.venue.reviewCount} reviews)",
                        style: AppTypography.bodySm.copyWith(color: AppColors.muted),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Select Button / Badge
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: widget.venue.isSelected
                  ? Container(
                      key: const ValueKey('selected'),
                      padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveHelper.w(8),
                        vertical: ResponsiveHelper.h(4),
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.accent.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(ResponsiveHelper.w(4)),
                      ),
                      child: Text(
                        "SELECTED",
                        style: AppTypography.bodySm.copyWith(
                          color: AppColors.accent,
                          fontWeight: FontWeight.bold,
                          fontSize: ResponsiveHelper.sp(10),
                        ),
                      ),
                    )
                  : Container(
                      key: const ValueKey('unselected'),
                      padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveHelper.w(16),
                        vertical: ResponsiveHelper.h(8),
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(ResponsiveHelper.w(8)),
                      ),
                      child: Text(
                        "Select",
                        style: AppTypography.bodySm.copyWith(
                          color: AppColors.onPrimary,
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
