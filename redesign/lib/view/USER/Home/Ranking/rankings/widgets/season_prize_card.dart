import 'package:flutter/material.dart';

const Color kSurface = Color(0xFF0E0E0E);
const Color kMuted = Color(0xFFA7A7A7);
const Color kGold = Color(0xFFFFC107);

class SeasonPrizeCard extends StatelessWidget {
  const SeasonPrizeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: kSurface,
          borderRadius: BorderRadius.circular(18),
        ),
        child: const Row(
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
