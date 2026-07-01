import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'venue_policy_box.dart';
import 'package:redesign/theme/responsive_helper.dart';

class BookingSummary extends StatelessWidget {
  BookingSummary({super.key});

  static const _kGreen = AppColors.accent;
  static const _kMuted = Color(0xFFA7A7A7);
  static const _kCardColor = Color(0xFF1A1A1A);

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle(text: 'Additional Notes'),
          _textArea('Write any special requests...'),
          SizedBox(height: 16),

          VenuePolicyBox(),
          SizedBox(height: 24),

          _priceRow('Slot Price (1 hr)', '₹1000'),
          _priceRow('Add-ons', '₹200'),
          Divider(color: Colors.grey),
          _priceRow('Total Amount', '₹1200', highlight: true),
        ],
      ),
    );
  }

  Widget _textArea(String hint) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(ResponsiveHelper.w(16)),
      decoration: BoxDecoration(
        color: _kCardColor,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
      ),
      child: TextField(
        maxLines: 3,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration.collapsed(hintText: hint),
      ),
    );
  }

  Widget _priceRow(String label, String value, {bool highlight = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(6)),
      child: Row(
        children: [
          Text(label, style: TextStyle(color: _kMuted)),
          Spacer(),
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
  _SectionTitle({required this.text});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Text(
      text,
      style: TextStyle(
        color: Colors.white,
        fontSize: ResponsiveHelper.sp(18),
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
