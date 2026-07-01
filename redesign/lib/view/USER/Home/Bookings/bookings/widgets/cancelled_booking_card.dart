import 'package:flutter/material.dart';
import '../bookings_screen.dart';
import 'action_chip.dart';
import 'status_badge.dart';
import 'package:redesign/theme/responsive_helper.dart';

class CancelledBookingCard extends StatelessWidget {
  CancelledBookingCard({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// VENUE IMAGE
              ClipRRect(
                borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
                child: Image.network(
                  'https://images.unsplash.com/photo-1521412644187-c49fa049e84d',
                  height: ResponsiveHelper.h(52),
                  width: ResponsiveHelper.w(52),
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 12),

              /// INFO
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Metro City Turf',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: ResponsiveHelper.sp(15),
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

          SizedBox(height: 14),

          /// BOTTOM ROW
          Row(
            children: [
              Icon(Icons.cancel_outlined, size: 16, color: MyBookingsConstants.red),
              SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Cancelled by you',
                  style: TextStyle(
                    color: MyBookingsConstants.red,
                    fontSize: ResponsiveHelper.sp(13),
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
