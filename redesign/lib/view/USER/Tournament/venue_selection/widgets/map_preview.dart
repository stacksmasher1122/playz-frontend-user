import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MapPreview extends StatefulWidget {
  const MapPreview({super.key});

  @override
  State<MapPreview> createState() => _MapPreviewState();
}

class _MapPreviewState extends State<MapPreview> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16)),
      width: double.infinity,
      height: ResponsiveHelper.w(328) * (7 / 16), // Aspect ratio 16:7 approx
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
        border: Border.all(color: AppColors.card, width: 1),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
        child: CachedNetworkImage(
          imageUrl: "https://via.placeholder.com/600x260/1a1a1a/4ade80?text=Map+Preview",
          fit: BoxFit.cover,
          placeholder: (context, url) => const Center(
            child: CircularProgressIndicator(color: AppColors.accent),
          ),
          errorWidget: (context, url, error) => Center(
            child: Icon(Icons.map_outlined, color: AppColors.muted, size: ResponsiveHelper.w(40)),
          ),
        ),
      ),
    );
  }
}
