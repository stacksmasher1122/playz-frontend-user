import 'package:flutter/material.dart';
import 'package:redesign/theme/responsive_helper.dart';

class RegisterSigninPrompt extends StatelessWidget {
  final VoidCallback onSigninTap;

  RegisterSigninPrompt({super.key, required this.onSigninTap});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    const spotifyGreen = Color(0xFF1DB954);

    return Padding(
      padding: EdgeInsets.only(bottom: ResponsiveHelper.h(24), top: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Already have an account?',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.6),
              fontSize: ResponsiveHelper.sp(13),
            ),
          ),
          SizedBox(width: 6),
          GestureDetector(
            onTap: onSigninTap,
            child: Text(
              'Sign in',
              style: TextStyle(
                color: spotifyGreen,
                fontSize: ResponsiveHelper.sp(13),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
