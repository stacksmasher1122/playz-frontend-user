import 'package:flutter/material.dart';
import 'package:redesign/theme/responsive_helper.dart';

class LoginSignupPrompt extends StatelessWidget {
  final VoidCallback onSignupTap;

  LoginSignupPrompt({super.key, required this.onSignupTap});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    const spotifyGreen = Color(0xFF1DB954);

    return Padding(
      padding: EdgeInsets.only(bottom: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Don't have an account?",
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.6),
              fontSize: ResponsiveHelper.sp(13),
            ),
          ),
          SizedBox(width: 6),
          GestureDetector(
            onTap: onSignupTap,
            child: Text(
              'Register here',
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
