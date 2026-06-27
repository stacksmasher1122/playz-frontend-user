import 'package:flutter/material.dart';
import 'package:redesign/view/USER/Home/Bookings/qr_in_bookings/qr_in_bookings_screen.dart';
import '../bookings_screen.dart';
import 'action_chip.dart';
import 'status_badge.dart';

class BookingCardUpcoming extends StatelessWidget {
  const BookingCardUpcoming();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 12),

      /// 🔹 CARD TAP (ONLY THIS navigates)
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const BookingQrScreen()));
          },

          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: MyBookingsConstants.surface,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// TOP ROW
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        'https://images.unsplash.com/photo-1517927033932-b3d18e61fb3a',
                        height: 56,
                        width: 56,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 12),

                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Neon Futsal Arena',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Court 4 · 5-a-side',
                            style: TextStyle(color: MyBookingsConstants.muted, fontSize: 12),
                          ),
                        ],
                      ),
                    ),

                    StatusBadge('CONFIRMED', MyBookingsConstants.green),
                  ],
                ),

                const SizedBox(height: 10),

                const Text(
                  '20:00 – 21:00 · 60 mins',
                  style: TextStyle(color: MyBookingsConstants.muted, fontSize: 12),
                ),

                const SizedBox(height: 6),

                const Text(
                  '📍 Shivajinagar, Pune · 2.5 km away',
                  style: TextStyle(color: MyBookingsConstants.muted, fontSize: 12),
                ),

                const SizedBox(height: 12),

                /// 🔹 ACTIONS (SEPARATE — DO NOT NAVIGATE)
                Wrap(
                  spacing: 10,
                  runSpacing: 8,
                  children: [
                    ActionChipWidget(
                      Icons.directions,
                      'Directions',
                      onTap: () {
                        // open maps
                      },
                    ),
                    ActionChipWidget(
                      Icons.chat_bubble_outline,
                      'Chat',
                      onTap: () {
                        // open chat
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
