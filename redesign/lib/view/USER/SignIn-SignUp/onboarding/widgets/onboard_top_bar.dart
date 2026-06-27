import 'package:flutter/material.dart';

class OnboardTopBar extends StatelessWidget {
  final VoidCallback onSkip;

  const OnboardTopBar({super.key, required this.onSkip});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          Row(
            children: [
              Image.asset(
                'assets/logo.png',
                height: 24,
                width: 24,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 8),
              const Text(
                'PlayZ',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white),
              ),
            ],
          ),
          const Spacer(),
          TextButton(
            onPressed: onSkip,
            child: const Text('Skip', style: TextStyle(color: Colors.white70)),
          ),
        ],
      ),
    );
  }
}
