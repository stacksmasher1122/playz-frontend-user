import 'package:flutter/material.dart';

class LoginSignupPrompt extends StatelessWidget {
  final VoidCallback onSignupTap;

  const LoginSignupPrompt({super.key, required this.onSignupTap});

  @override
  Widget build(BuildContext context) {
    const spotifyGreen = Color(0xFF1DB954);

    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Don't have an account?",
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 13,
            ),
          ),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: onSignupTap,
            child: const Text(
              'Register here',
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
