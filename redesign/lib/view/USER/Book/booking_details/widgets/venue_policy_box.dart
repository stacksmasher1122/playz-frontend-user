import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';

class VenuePolicyBox extends StatelessWidget {
  const VenuePolicyBox({super.key});

  static const _kGreen = AppColors.accent;
  static const _kMuted = Color(0xFFA7A7A7);
  static const _kCardColor = Color(0xFF1A1A1A);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _kCardColor, // Spotify dark surface
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade800),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          /// HEADER
          Row(
            children: const [
              Icon(Icons.info_outline, color: _kGreen, size: 18),
              SizedBox(width: 8),
              Text(
                'Venue Policy',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          /// POLICY ITEMS
          _policyItem('Non-refundable within 4 hours'),
          _policyItem('Steel studs are prohibited'),
        ],
      ),
    );
  }

  Widget _policyItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 6),
            child: Icon(Icons.circle, size: 6, color: _kMuted),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: _kMuted, fontSize: 13, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}
