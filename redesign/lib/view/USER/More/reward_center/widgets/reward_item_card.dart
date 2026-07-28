import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redesign/model/User_Models/More_Models/reward_center_model.dart';

class RewardItemCard extends StatelessWidget {
  final RewardItemModel item;
  final VoidCallback onRedeem;

  const RewardItemCard({
    super.key,
    required this.item,
    required this.onRedeem,
  });

  IconData _getIcon() {
    switch (item.iconType) {
      case 'discount':
        return Icons.local_offer_rounded;
      case 'theme':
        return Icons.palette_rounded;
      case 'merch':
        return Icons.checkroom_rounded;
      case 'pass':
        return Icons.confirmation_number_rounded;
      default:
        return Icons.card_giftcard_rounded;
    }
  }

  Color _getIconColor() {
    switch (item.iconType) {
      case 'discount':
        return const Color(0xFF00E676);
      case 'theme':
        return Colors.purpleAccent;
      case 'merch':
        return Colors.orangeAccent;
      case 'pass':
        return Colors.lightBlueAccent;
      default:
        return const Color(0xFF00E676);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: item.isRedeemed ? Colors.white10 : const Color(0xFF00E676).withValues(alpha: 0.15),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _getIconColor().withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(_getIcon(), color: _getIconColor(), size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  item.subtitle,
                  style: GoogleFonts.inter(
                    color: Colors.white54,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.monetization_on_rounded, color: Colors.amberAccent, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '${item.coinCost} Coins',
                      style: GoogleFonts.inter(
                        color: Colors.amberAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: item.isRedeemed ? null : onRedeem,
            style: ElevatedButton.styleFrom(
              backgroundColor: item.isRedeemed ? Colors.white10 : const Color(0xFF00E676),
              disabledBackgroundColor: Colors.white12,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              item.isRedeemed ? 'Redeemed' : 'Redeem',
              style: GoogleFonts.inter(
                color: item.isRedeemed ? Colors.white38 : Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
