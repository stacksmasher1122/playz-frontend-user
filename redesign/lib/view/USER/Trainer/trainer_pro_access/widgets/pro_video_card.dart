import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:redesign/theme/responsive_helper.dart';

class ProVideoCard extends StatelessWidget {
  ProVideoCard({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(ResponsiveHelper.w(18)),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Stack(
          alignment: Alignment.center,
          children: [
            CachedNetworkImage(
              imageUrl:
                  'https://images.unsplash.com/photo-1599058917212-d750089bc07c',
              fit: BoxFit.cover,
              placeholder: (_, __) => Shimmer.fromColors(
                baseColor: Colors.grey.shade900,
                highlightColor: Colors.grey.shade800,
                child: Container(color: Colors.black),
              ),
            ),
            Container(color: Colors.black45),
            Icon(Icons.play_circle_fill, size: 64, color: Colors.white),
            Positioned(
              left: ResponsiveHelper.w(12),
              bottom: ResponsiveHelper.h(12),
              right: ResponsiveHelper.w(12),
              child: Text(
                'See how top trainers are winning',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
