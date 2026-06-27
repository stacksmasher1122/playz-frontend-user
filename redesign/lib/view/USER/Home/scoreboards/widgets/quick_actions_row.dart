import 'package:flutter/material.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Cricket/previous_matches.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Cricket/live_matches.dart';

const kSurface = Color(0xFF0E0E0E);
const kRed = Color(0xFFE53935);

class QuickActionsRow extends StatelessWidget {
  const QuickActionsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 18),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: kSurface,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: Colors.white.withOpacity(0.05),
                    ),
                  ),
                ),
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const PreviousMatchesScreen())),
                icon: const Icon(Icons.history, size: 18),
                label: const Text(
                  'Previous Score',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: kSurface,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: Colors.white.withOpacity(0.05),
                    ),
                  ),
                ),
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const LiveMatchesScreen())),
                icon: const Icon(Icons.sensors, size: 18, color: kRed),
                label: const Text(
                  'Live Matches',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
