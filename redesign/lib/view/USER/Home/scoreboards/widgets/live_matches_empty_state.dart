import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

const kMuted = Color(0xFFA7A7A7);

class LiveMatchesEmptyState extends StatelessWidget {
  const LiveMatchesEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            Lottie.network(
              'https://lottie.host/77d43ff5-2fda-40e0-b208-533e7788caff/tGiSgVZpJ6.json',
              height: 180,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 20),
            const Text(
              'No live scoreboard or match,\ncreate your own scoreboard',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: kMuted,
                fontSize: 16,
                height: 1.4,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }
}
