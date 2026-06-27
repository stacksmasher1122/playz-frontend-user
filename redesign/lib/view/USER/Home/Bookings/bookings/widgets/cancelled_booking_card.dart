import 'package:flutter/material.dart';
import '../bookings_screen.dart';
import 'action_chip.dart';
import 'status_badge.dart';

class CancelledBookingCard extends StatelessWidget {
  const CancelledBookingCard();

  @override
  Widget build(BuildContext context) {
    return Container(
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// VENUE IMAGE
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  'https://images.unsplash.com/photo-1521412644187-c49fa049e84d',
                  height: 52,
                  width: 52,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),

              /// INFO
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Metro City Turf',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '7-a-side · 60 mins',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Nov 28, 6:00 PM  •  Refunded',
                      style: TextStyle(color: Colors.white54, fontSize: 12),
                    ),
                  ],
                ),
              ),

              /// STATUS
              StatusBadge('CANCELLED', MyBookingsConstants.red),
            ],
          ),

          const SizedBox(height: 14),

          /// BOTTOM ROW
          Row(
            children: [
              const Icon(Icons.cancel_outlined, size: 16, color: MyBookingsConstants.red),
              const SizedBox(width: 6),
              const Expanded(
                child: Text(
                  'Cancelled by you',
                  style: TextStyle(
                    color: MyBookingsConstants.red,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              ActionChipWidget(Icons.info_outline, 'Details', onTap: () {}),
            ],
          ),
        ],
      ),
    );
  }
}
