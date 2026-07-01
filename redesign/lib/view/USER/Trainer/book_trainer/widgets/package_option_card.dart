import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import '../package_model.dart';

const kCard = Color(0xFF1A1A1A);
const kGreen = AppColors.accent;
const kMuted = Color(0xFFA7A7A7);
const kSurface = AppColors.surface;
const kYellow = Color(0xFFF5C542);

class PackageOptionCard extends StatelessWidget {
  final PackageModel data;
  final bool selected;
  final VoidCallback onTap;

  const PackageOptionCard({
    super.key,
    required this.data,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: kCard,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: selected ? kGreen : Colors.transparent,
              width: 1.6,
            ),
            boxShadow: selected
                ? [BoxShadow(color: kGreen.withValues(alpha: 0.35), blurRadius: 16)]
                : [],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (data.badge != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: data.badgeColor ?? kGreen,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        data.badge!,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  const Spacer(),
                  Icon(
                    selected
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked,
                    color: selected ? kGreen : kMuted,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                data.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                data.desc,
                style: const TextStyle(color: kMuted, height: 1.4),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: data.chips
                    .map(
                      (e) => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: kSurface,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          e,
                          style: const TextStyle(color: kMuted, fontSize: 12),
                        ),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 12),
              const Divider(color: Colors.white10),
              Row(
                children: [
                  Text(
                    '₹${data.price}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '+${data.coins} Z Coins',
                    style: const TextStyle(
                      color: kYellow,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                data.billing,
                style: const TextStyle(color: kMuted, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
