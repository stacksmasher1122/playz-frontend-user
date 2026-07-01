import 'package:flutter/material.dart';
import 'package:redesign/theme/responsive_helper.dart';

class KickoffBallWidget extends StatelessWidget {
  KickoffBallWidget({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      width: ResponsiveHelper.w(24),
      height: ResponsiveHelper.h(24),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFFC6FF00), // Lime Green
        border: Border.all(color: Colors.black, width: 2),
        boxShadow: [
          BoxShadow(
            color: Color(0xFFC6FF00).withValues(alpha: 0.6),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
    );
  }
}
