import 'package:flutter/material.dart';
import 'package:redesign/theme/responsive_helper.dart';

Color kSurface = Color(0xFF0E0E0E);
Color kMuted = Color(0xFFA7A7A7);
Color kGold = Color(0xFFFFC107);

class SeasonPrizeCard extends StatelessWidget {
  SeasonPrizeCard({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 14, 16, 6),
      child: Container(
        padding: EdgeInsets.all(ResponsiveHelper.w(14)),
        decoration: BoxDecoration(
          color: kSurface,
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(18)),
        ),
        child: Row(
          children: [
            Icon(Icons.card_giftcard, color: kGold),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Season 12 Prize Pool: ₹1 Lakh',
                    style: TextStyle(
                        color: kGold, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Top 10 players win cash & exclusive merch',
                    style: TextStyle(color: kMuted, fontSize: 12),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: kMuted),
          ],
        ),
      ),
    );
  }
}
