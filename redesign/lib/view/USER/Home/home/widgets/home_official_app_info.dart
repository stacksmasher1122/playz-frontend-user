import 'package:flutter/material.dart';
import '../home_screen.dart';

/* ============================================================
   OFFICIAL APP INFO / FOOTER
   ============================================================ */
class HomeOfficialAppInfo extends StatelessWidget {
  const HomeOfficialAppInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          Text(
            'PlayZ',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Play • Book • Compete',
            style: TextStyle(color: UserHomePage.muted, fontSize: 13),
          ),
          SizedBox(height: 10),
          Text(
            'Built for local sports, teams, and communities.',
            textAlign: TextAlign.center,
            style: TextStyle(color: UserHomePage.muted, fontSize: 12),
          ),
          SizedBox(height: 12),
          Text(
            '© 2026 PlayZ Technologies. All rights reserved.',
            style: TextStyle(color: UserHomePage.muted, fontSize: 11),
          ),
        ],
      ),
    );
  }
}
