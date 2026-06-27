import 'package:flutter/material.dart';

class PaymentSummaryCard extends StatelessWidget {
  const PaymentSummaryCard({super.key});

  static const _kCard = Color(0xFF1A1A1A);
  static const _kMuted = Color(0xFFA7A7A7);
  static const _kYellow = Color(0xFFFFC107);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _kCard,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _priceRow('Slot Price (1 hr)', '₹400.00'),
          _priceRow('Convenience Fee', '₹50.00'),
          _priceRow('Equipment (Ball)', 'Included'),
          const Divider(color: Colors.grey),
          Row(
            children: [
              const Text(
                'Total Paid',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              const Text(
                '₹450.00',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _kYellow.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text('+10 ZC', style: TextStyle(color: _kYellow)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _priceRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(label, style: const TextStyle(color: _kMuted)),
          const Spacer(),
          Text(value, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}
