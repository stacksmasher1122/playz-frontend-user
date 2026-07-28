import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redesign/model/User_Models/More_Models/reward_center_model.dart';

class EarnCoinsSection extends StatelessWidget {
  final List<EarnCoinTaskModel> tasks;
  final VoidCallback onInviteTap;

  const EarnCoinsSection({
    super.key,
    required this.tasks,
    required this.onInviteTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
          child: Text(
            'WAYS TO EARN Z-COINS',
            style: GoogleFonts.inter(
              color: const Color(0xFF00E676),
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
        ),
        ...tasks.map((t) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.amberAccent.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.add_task_rounded, color: Colors.amberAccent, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        t.title,
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(Icons.monetization_on_rounded, color: Colors.amberAccent, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            '+${t.coinReward} Coins',
                            style: GoogleFonts.inter(
                              color: Colors.amberAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                OutlinedButton(
                  onPressed: () {
                    if (t.actionText == 'Invite Friends') {
                      onInviteTap();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Task "${t.title}" activated! Earn +${t.coinReward} coins on completion.'),
                          backgroundColor: const Color(0xFF1E1E1E),
                        ),
                      );
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF00E676)),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text(
                    t.actionText,
                    style: GoogleFonts.inter(color: const Color(0xFF00E676), fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
