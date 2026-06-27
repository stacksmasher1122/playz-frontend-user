import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';

const kSurface = Color(0xFF0E0E0E);
const kMuted = Color(0xFFA7A7A7);
const kGreen = AppColors.accent;
const kCard = Color(0xFF1A1A1A);

class ProComparisonTable extends StatelessWidget {
  const ProComparisonTable({super.key});

  @override
  Widget build(BuildContext context) {
    const rows = [
      ComparisonRow(feature: 'Verified Badge', basic: false, pro: true),
      ComparisonRow(feature: 'Unlimited Students', basic: false, pro: true),
      ComparisonRow(feature: 'Secure Payments', basic: true, pro: true),
      ComparisonRow(feature: 'Priority Support', basic: false, pro: true),
      ComparisonRow(feature: 'Marketing Boost', basic: false, pro: true),
    ];

    return Container(
      decoration: BoxDecoration(
        color: kSurface,
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'FREE VS PRO COMPARISON',
            style: TextStyle(
              color: kMuted,
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 14),

          /// Header Row
          Row(
            children: const [
              Expanded(
                flex: 2,
                child: Text(
                  'Feature',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    'BASIC',
                    style: TextStyle(
                      color: kMuted,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    'PRO',
                    style: TextStyle(
                      color: kGreen,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),
          const Divider(color: kCard, height: 1),

          /// Rows
          ...rows.map(
            (row) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      row.feature,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13.5,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(child: CheckIcon(enabled: row.basic)),
                  ),
                  Expanded(
                    child: Center(
                      child: CheckIcon(enabled: row.pro, highlight: true),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ComparisonRow {
  final String feature;
  final bool basic;
  final bool pro;

  const ComparisonRow({
    required this.feature,
    required this.basic,
    required this.pro,
  });
}

class CheckIcon extends StatelessWidget {
  final bool enabled;
  final bool highlight;

  const CheckIcon({super.key, required this.enabled, this.highlight = false});

  @override
  Widget build(BuildContext context) {
    if (!enabled) {
      return const Icon(Icons.close_rounded, size: 18, color: kMuted);
    }

    return Icon(
      Icons.check_circle_rounded,
      size: 18,
      color: highlight ? kGreen : Colors.white,
    );
  }
}
