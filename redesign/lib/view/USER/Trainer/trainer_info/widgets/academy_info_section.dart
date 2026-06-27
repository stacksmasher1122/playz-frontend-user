import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';

const Color kCard = Color(0xFF1A1A1A);
const Color kMuted = Color(0xFFA7A7A7);
const Color kGreen = AppColors.accent;
const Color kYellow = Color(0xFFFFC107);

class AcademyInfoSection extends StatelessWidget {
  const AcademyInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'PowerPlay Cricket Academy',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: kCard,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: const [
                  Icon(Icons.star, color: kYellow, size: 14),
                  SizedBox(width: 4),
                  Text('4.9', style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// LOCATION
            Row(
              children: const [
                Icon(Icons.location_on_outlined, size: 16, color: kMuted),
                SizedBox(width: 6),
                Text(
                  'Kothrud, Pune • 2.3 km away',
                  style: TextStyle(color: kMuted, fontSize: 14),
                ),
              ],
            ),

            const SizedBox(height: 6),

            /// OPEN STATUS (RichText)
            Row(
              children: [
                const Icon(Icons.access_time, size: 16, color: kMuted),
                const SizedBox(width: 6),
                RichText(
                  text: const TextSpan(
                    style: TextStyle(fontSize: 14, color: kMuted),
                    children: [
                      TextSpan(
                        text: 'Open Now',
                        style: TextStyle(
                          color: kGreen,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(
                        text: ' • Closes at 10:00 PM',
                        style: TextStyle(
                          color: kMuted,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 6),

            /// CERTIFICATION
            Row(
              children: const [
                Icon(Icons.verified_outlined, size: 16, color: kGreen),
                SizedBox(width: 6),
                Text(
                  'Govt. Certified Sports Facility',
                  style: TextStyle(color: kMuted, fontSize: 14),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        const Text(
          'A premier cricket training center equipped with turf wickets, bowling machines, and expert coaching staff. We focus on technique, fitness, and match temperament for aspiring cricketers.',
          style: TextStyle(color: kMuted, height: 1.45),
        ),
      ],
    );
  }
}
