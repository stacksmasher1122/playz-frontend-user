import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:redesign/theme/app_colors.dart';

class QrBookingCard extends StatelessWidget {
  final Size size;

  const QrBookingCard({
    super.key,
    required this.size,
  });

  static const _kCard = Color(0xFF1A1A1A);
  static const _kGreen = AppColors.accent;
  static const _kMuted = Color(0xFFA7A7A7);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _kCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          _verifiedBadge(),
          const SizedBox(height: 20),

          /// QR PLACEHOLDER
          Container(
            width: size.width * 0.55,
            constraints: const BoxConstraints(maxWidth: 240),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: _kGreen.withValues(alpha: 0.15),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: AspectRatio(
              aspectRatio: 1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: QrImageView(
                  data: 'PZ-883492-QR|CrossFit Arena|08:00-09:00', // dynamic later
                  version: QrVersions.auto,
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  gapless: false,
                  errorCorrectionLevel: QrErrorCorrectLevel.H,
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            'CrossFit Arena',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),

          const Text(
            'Thu, 4 Dec · 08:00 AM – 09:00 AM',
            style: TextStyle(color: _kMuted),
          ),

          const SizedBox(height: 6),

          const Text(
            'Football · Solo Queue · 4 Players',
            style: TextStyle(color: _kMuted, fontSize: 13),
          ),

          const SizedBox(height: 14),

          _bookingId(),
        ],
      ),
    );
  }

  Widget _verifiedBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _kGreen.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.verified, color: _kGreen, size: 16),
          SizedBox(width: 6),
          Text(
            'Verified PlayZ Booking',
            style: TextStyle(color: _kGreen, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _bookingId() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white24,
          style: BorderStyle.solid,
        ),
      ),
      child: const Text(
        'Booking ID: PZ-883492-QR',
        style: TextStyle(color: _kMuted, fontSize: 12),
      ),
    );
  }
}
