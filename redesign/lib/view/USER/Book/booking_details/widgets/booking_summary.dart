import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'venue_policy_box.dart';

class BookingSummary extends StatelessWidget {
  const BookingSummary({super.key});

  static const _kGreen = AppColors.accent;
  static const _kMuted = Color(0xFFA7A7A7);
  static const _kCardColor = Color(0xFF1A1A1A);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(text: 'Additional Notes'),
          _textArea('Write any special requests...'),
          const SizedBox(height: 16),

          const VenuePolicyBox(),
          const SizedBox(height: 24),

          _priceRow('Slot Price (1 hr)', '₹1000'),
          _priceRow('Add-ons', '₹200'),
          const Divider(color: Colors.grey),
          _priceRow('Total Amount', '₹1200', highlight: true),
        ],
      ),
    );
  }

  Widget _textArea(String hint) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _kCardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        maxLines: 3,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration.collapsed(hintText: hint),
      ),
    );
  }

  Widget _priceRow(String label, String value, {bool highlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(label, style: const TextStyle(color: _kMuted)),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              color: highlight ? _kGreen : Colors.white,
              fontWeight: highlight ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
