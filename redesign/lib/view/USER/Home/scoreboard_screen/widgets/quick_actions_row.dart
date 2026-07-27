import 'package:flutter/material.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Cricket/previous_matches.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Cricket/live_matches.dart';
import 'package:redesign/theme/responsive_helper.dart';

const kSurface = Color(0xFF0E0E0E);
const kRed = Color(0xFFE53935);

class QuickActionsRow extends StatelessWidget {
  QuickActionsRow({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 12, 16, 18),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: kSurface,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(14)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
                    side: BorderSide(
                      color: Colors.white.withValues(alpha: 0.05),
                    ),
                  ),
                ),
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => PreviousMatchesScreen())),
                icon: Icon(Icons.history, size: 18),
                label: Text(
                  'Previous Score',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: kSurface,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(14)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
                    side: BorderSide(
                      color: Colors.white.withValues(alpha: 0.05),
                    ),
                  ),
                ),
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => LiveMatchesScreen())),
                icon: Icon(Icons.sensors, size: 18, color: kRed),
                label: Text(
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
