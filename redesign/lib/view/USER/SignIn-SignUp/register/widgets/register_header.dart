import 'package:flutter/material.dart';

class RegisterHeader extends StatelessWidget {
  const RegisterHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          'assets/logo.png',
          height: 60,
          width: 60,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 16),
        const Text(
          'Create Account',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Join the PlayZ sports community',
          style: TextStyle(
            fontSize: 14,
            color: Colors.white.withOpacity(0.65),
          ),
        ),
      ],
    );
  }
}
