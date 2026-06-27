import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';

const kGreen = AppColors.accent;
const kCard = Color(0xFF1A1A1A);
const kMuted = Color(0xFFA7A7A7);
const kYellow = Color(0xFFFFC107);
const kSurface = AppColors.surface;

class PackagePurchasedCard extends StatelessWidget {
  const PackagePurchasedCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.circular(18),
        border: const Border(
          left: BorderSide(color: kGreen, width: 3),
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'PACKAGE PURCHASED',
            style: TextStyle(
              color: kGreen,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '1-Day Trial Access',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          const Row(
            children: [
              Icon(Icons.calendar_today, size: 14, color: kMuted),
              SizedBox(width: 6),
              Text('Valid for 24 Hours',
                  style: TextStyle(color: kMuted)),
            ],
          ),

          const Divider(color: Colors.grey),

          _infoRow('Amount Paid', '₹150.00'),
          _infoRow('Rewards Earned', '+15 Z Coins',
              valueColor: kYellow),

          const SizedBox(height: 8),

          Row(
            children: const [
              Text('Transaction ID',
                  style: TextStyle(color: kMuted, fontSize: 12)),
              Spacer(),
              Text(
                '#TXN882901',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'monospace',
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Wrap(
            spacing: 8,
            children: const [
              PackageFeatureChip(label: 'Kit Provided'),
              PackageFeatureChip(label: '1 Hr Net Practice'),
            ],
          )
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value,
      {Color valueColor = Colors.white}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(label, style: const TextStyle(color: kMuted)),
          const Spacer(),
          Text(value,
              style: TextStyle(
                  color: valueColor, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class PackageFeatureChip extends StatelessWidget {
  final String label;
  const PackageFeatureChip({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: kSurface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
        ),
      ),
    );
  }
}
