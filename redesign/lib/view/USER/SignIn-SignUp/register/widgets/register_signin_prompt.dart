import 'package:flutter/material.dart';

class RegisterSigninPrompt extends StatelessWidget {
  final VoidCallback onSigninTap;

  const RegisterSigninPrompt({super.key, required this.onSigninTap});

  @override
  Widget build(BuildContext context) {
    const spotifyGreen = Color(0xFF1DB954);

    return Padding(
      padding: const EdgeInsets.only(bottom: 24, top: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Already have an account?',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.6),
              fontSize: 13,
            ),
          ),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: onSigninTap,
            child: const Text(
              'Sign in',
              style: TextStyle(
                color: spotifyGreen,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
