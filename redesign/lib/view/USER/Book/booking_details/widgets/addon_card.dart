import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';

class AddonCard extends StatelessWidget {
  final String title;
  final String price;
  final bool isSelected;
  final VoidCallback onTap;

  const AddonCard({
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        clipBehavior: Clip.antiAlias, // 🔑 CONTAINS SPLASH
        child: InkWell(
          onTap: onTap,
          splashColor: _kGreen.withOpacity(0.15),
          highlightColor: _kGreen.withOpacity(0.08),
          child: Ink(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black, // Spotify dark base
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? _kGreen : Colors.grey.shade800,
                width: 1.2,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Text(
                  price,
                  style: const TextStyle(
                    color: _kGreen,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 8),
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
