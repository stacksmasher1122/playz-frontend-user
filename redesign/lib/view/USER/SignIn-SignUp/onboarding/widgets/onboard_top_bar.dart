import 'package:flutter/material.dart';
import 'package:redesign/theme/responsive_helper.dart';

class OnboardTopBar extends StatelessWidget {
  final VoidCallback onSkip;

  OnboardTopBar({super.key, required this.onSkip});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(20), vertical: ResponsiveHelper.h(12)),
      child: Row(
        children: [
          Row(
            children: [
              Image.asset(
                'assets/logo.png',
                height: ResponsiveHelper.h(24),
                width: ResponsiveHelper.w(24),
                fit: BoxFit.contain,
              ),
              SizedBox(width: 8),
              Text(
                'PlayZ',
                style: TextStyle(fontSize: ResponsiveHelper.sp(20), fontWeight: FontWeight.w800, color: Colors.white),
              ),
            ],
          ),
          Spacer(),
          TextButton(
            onPressed: onSkip,
            child: Text('Skip', style: TextStyle(color: Colors.white70)),
          ),
        ],
      ),
    );
  }
}
