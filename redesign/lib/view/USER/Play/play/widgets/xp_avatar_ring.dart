import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:shimmer/shimmer.dart';

enum XpTier {
  bronze,
  silver,
  gold,
  platinum,
  legend,
}

class XpAvatarRing extends StatelessWidget {
  final String imageUrl;
  final int xp;
  final double radius;
  final VoidCallback? onTap;

  const XpAvatarRing({
    super.key,
    required this.imageUrl,
    this.xp = 100,
    this.radius = 20,
    this.onTap,
  });

  XpTier get tier {
    if (xp >= 5000) return XpTier.legend;
    if (xp >= 3000) return XpTier.platinum;
    if (xp >= 1500) return XpTier.gold;
    if (xp >= 500) return XpTier.silver;
    return XpTier.bronze;
  }

  List<Color> get ringColors {
    switch (tier) {
      case XpTier.bronze:
        return [const Color(0xFFCD7F32), const Color(0xFFA55728)];
      case XpTier.silver:
        return [const Color(0xFFE0E0E0), const Color(0xFF9E9E9E)];
      case XpTier.gold:
        return [const Color(0xFFFFD700), const Color(0xFFFF9100)];
      case XpTier.platinum:
        return [const Color(0xFF00E5FF), const Color(0xFF2979FF)];
      case XpTier.legend:
        return [const Color(0xFFA855F7), const Color(0xFFEC4899), const Color(0xFFF59E0B)];
    }
  }

  String get tierLabel {
    switch (tier) {
      case XpTier.bronze:
        return 'BRONZE';
      case XpTier.silver:
        return 'SILVER';
      case XpTier.gold:
        return 'GOLD';
      case XpTier.platinum:
        return 'PLATINUM';
      case XpTier.legend:
        return 'LEGEND';
    }
  }

  @override
  Widget build(BuildContext context) {
    final ringWidth = radius > 24 ? 3.0 : 2.2;
    final size = radius * 2;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size + ringWidth * 3,
        height: size + ringWidth * 3,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: ringColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: ringColors.first.withValues(alpha: 0.35),
              blurRadius: 6,
              spreadRadius: 1,
            ),
          ],
        ),
        padding: EdgeInsets.all(ringWidth),
        child: Container(
          decoration: const BoxDecoration(
            color: AppColors.background,
            shape: BoxShape.circle,
          ),
          padding: const EdgeInsets.all(1.5),
          child: ClipOval(
            child: imageUrl.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: imageUrl,
                    width: size,
                    height: size,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Shimmer.fromColors(
                      baseColor: AppColors.surfaceElevated.withValues(alpha: 0.6),
                      highlightColor: AppColors.borderDark.withValues(alpha: 0.8),
                      child: CircleAvatar(radius: radius),
                    ),
                    errorWidget: (_, __, ___) => CircleAvatar(
                      radius: radius,
                      backgroundColor: AppColors.card,
                      child: Icon(Icons.person, color: AppColors.muted, size: radius),
                    ),
                  )
                : CircleAvatar(
                    radius: radius,
                    backgroundColor: AppColors.card,
                    child: Icon(Icons.person, color: AppColors.muted, size: radius),
                  ),
          ),
        ),
      ),
    );
  }
}
