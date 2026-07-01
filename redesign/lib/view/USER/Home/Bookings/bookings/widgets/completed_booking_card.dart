import 'package:flutter/material.dart';
import '../bookings_screen.dart';
import 'action_chip.dart';
import 'status_badge.dart';
import 'package:redesign/theme/responsive_helper.dart';

class CompletedBookingCard extends StatelessWidget {
  CompletedBookingCard({super.key});

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
                  'https://images.unsplash.com/photo-1517649763962-0c623066013b',
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
                      'Smash Zone',
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
                      'Badminton · 60 mins',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Dec 2, 7:00 PM  •  ₹450 Paid',
                      style: TextStyle(color: Colors.white54, fontSize: 12),
                    ),
                  ],
                ),
              ),

              /// STATUS
              StatusBadge(
                'COMPLETED',
                Colors.white24,
                textColor: Colors.white70,
              ),
            ],
          ),

          SizedBox(height: 14),

          /// ACTIONS
          Row(
            children: [
              ActionChipWidget(Icons.download_outlined, 'Invoice', onTap: () {}),
              Spacer(),
              ActionChipWidget(
                Icons.refresh_rounded,
                'Book Again',
                outlined: true,
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
