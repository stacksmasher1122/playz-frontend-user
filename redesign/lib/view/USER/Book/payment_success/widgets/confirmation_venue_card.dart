import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/view/USER/Book/show_qr/show_qr_screen.dart';
import 'package:shimmer/shimmer.dart';
import 'notched_dashed_divider.dart';

class ConfirmationVenueCard extends StatelessWidget {
  final Size size;

  const ConfirmationVenueCard({super.key, required this.size});

  static const _kCard = Color(0xFF1A1A1A);
  static const _kGreen = AppColors.accent;
  static const _kMuted = Color(0xFFA7A7A7);
  static const _kYellow = Color(0xFFFFC107);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _kCard,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // IMAGE
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Stack(
              children: [
                CachedNetworkImage(
                  imageUrl:
                      'https://images.unsplash.com/photo-1546519638-68e109498ffc',
                  height: size.width * 0.45,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Shimmer.fromColors(
                    baseColor: Colors.grey.shade900,
                    highlightColor: Colors.grey.shade800,
                    child: Container(color: Colors.black),
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.sports_soccer, color: _kGreen, size: 16),
                        SizedBox(width: 6),
                        Text('Football', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: const Text(
                    'CrossFit Arena',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: const Text(
                    'ID: #PZ-883492',
                    style: TextStyle(color: _kMuted, fontFamily: 'monospace'),
                  ),
                ),

                const SizedBox(height: 16),

                /// 🔥 NOTCHED DASHED DIVIDER
                const NotchedDashedDivider(),

                const SizedBox(height: 16),

                _infoRow('Date', 'Thu, 4 Dec'),
                _infoRow('Time', '08:00 – 09:00 AM'),
                _infoRow('Players', '4 (Solo Queue)'),
                _infoRow('Location', 'Shivajinagar'),
                const SizedBox(height: 8),
                _weatherCard(),
                const SizedBox(height: 12),
                _qrBlock(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: const TextStyle(color: _kMuted)),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _weatherCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Row(
          children: [
            Icon(Icons.wb_sunny, color: _kYellow),
            SizedBox(width: 8),
            Text(
              '24°C • Partly Cloudy • Good conditions',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _qrBlock(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) {
                return ShowQrScreen();
              },
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Scan at Entry',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Show this code at reception',
                      style: TextStyle(color: _kMuted),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Colors.white,
                ),
                width: 56,
                height: 56,
                child: const Icon(Icons.qr_code, size: 40, color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
