import 'package:flutter/material.dart';
import 'package:redesign/view/USER/Home/Bookings/qr_in_bookings/qr_in_bookings_screen.dart';
import '../bookings_screen.dart';
import 'action_chip.dart';
import 'status_badge.dart';
import 'package:redesign/theme/responsive_helper.dart';

class BookingCardUpcoming extends StatelessWidget {
  BookingCardUpcoming({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 6, 16, 12),

      /// 🔹 CARD TAP (ONLY THIS navigates)
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(18)),
          onTap: () {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => BookingQrScreen()));
          },

          child: Container(
            padding: EdgeInsets.all(ResponsiveHelper.w(14)),
            decoration: BoxDecoration(
              color: MyBookingsConstants.surface,
              borderRadius: BorderRadius.circular(ResponsiveHelper.w(18)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// TOP ROW
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
                      child: Image.network(
                        'https://images.unsplash.com/photo-1517927033932-b3d18e61fb3a',
                        height: ResponsiveHelper.h(56),
                        width: ResponsiveHelper.w(56),
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: 12),

                    Expanded(
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

                SizedBox(height: 10),

                Text(
                  '20:00 – 21:00 · 60 mins',
                  style: TextStyle(color: MyBookingsConstants.muted, fontSize: 12),
                ),

                SizedBox(height: 6),

                Text(
                  '📍 Shivajinagar, Pune · 2.5 km away',
                  style: TextStyle(color: MyBookingsConstants.muted, fontSize: 12),
                ),

                SizedBox(height: 12),

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
