import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

class AddonCard extends StatelessWidget {
  final String title;
  final String price;
  final bool isSelected;
  final VoidCallback onTap;

  AddonCard({
    super.key,
    required this.title,
    required this.price,
    required this.isSelected,
    required this.onTap,
  });

  static const _kGreen = AppColors.accent;
  static const _kMuted = Color(0xFFA7A7A7);

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16), vertical: ResponsiveHelper.h(6)),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
        clipBehavior: Clip.antiAlias, // 🔑 CONTAINS SPLASH
        child: InkWell(
          onTap: onTap,
          splashColor: _kGreen.withValues(alpha: 0.15),
          highlightColor: _kGreen.withValues(alpha: 0.08),
          child: Ink(
            padding: EdgeInsets.all(ResponsiveHelper.w(16)),
            decoration: BoxDecoration(
              color: Colors.black, // Spotify dark base
              borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
              border: Border.all(
                color: isSelected ? _kGreen : Colors.grey.shade800,
                width: ResponsiveHelper.w(1.2),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: ResponsiveHelper.sp(14),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Text(
                  price,
                  style: TextStyle(
                    color: _kGreen,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: 8),
                Icon(
                  isSelected ? Icons.check_circle : Icons.circle_outlined,
                  color: isSelected ? _kGreen : _kMuted,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
