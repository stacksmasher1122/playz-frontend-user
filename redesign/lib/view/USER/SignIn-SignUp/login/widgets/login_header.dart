import 'package:flutter/material.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    const kMuted = Color(0xFFA7A7A7);

    return Column(
      children: const [
        SizedBox(height: 16),
        Text(
          'Welcome back',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: -0.2,
          ),
        ),
        SizedBox(height: 6),
        Text(
          'Ready to get back on the field?',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13.5,
            color: kMuted,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}
