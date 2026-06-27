import 'package:flutter/material.dart';
import '../home_screen.dart';

/* ============================================================
   SECTION HEADER
   ============================================================ */
class HomeSectionHeader extends StatelessWidget {
  final String title;
  const HomeSectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        const Spacer(),
        const Text(
          'See All',
          style: TextStyle(color: UserHomePage.accent, fontSize: 13),
        ),
      ],
    );
  }
}
