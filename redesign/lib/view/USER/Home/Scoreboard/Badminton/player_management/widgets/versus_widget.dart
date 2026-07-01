import 'package:flutter/material.dart';
import 'package:redesign/theme/responsive_helper.dart';

class VersusWidget extends StatelessWidget {
  final String gamesLabel;

  VersusWidget({
    super.key,
    required this.gamesLabel,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            // Subtle diagonal green accent decoration
            Transform.rotate(
              angle: -0.2,
              child: Container(
                width: ResponsiveHelper.w(60),
                height: ResponsiveHelper.h(40),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFFC6FF00).withValues(alpha: 0.1),
                      Color(0xFFC6FF00).withValues(alpha: 0.0),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(ResponsiveHelper.w(8)),
                ),
              ),
            ),
            Text(
              'VS',
              style: TextStyle(
                color: Color(0xFFC6FF00), // Neon Yellow-Green
                fontSize: ResponsiveHelper.sp(32),
                fontWeight: FontWeight.w900,
                fontStyle: FontStyle.italic,
                letterSpacing: 2.0,
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(12), vertical: ResponsiveHelper.h(4)),
          decoration: BoxDecoration(
            color: Colors.grey.shade800,
            borderRadius: BorderRadius.circular(ResponsiveHelper.w(20)),
          ),
          child: Text(
            gamesLabel,
            style: TextStyle(
              color: Colors.white,
              fontSize: ResponsiveHelper.sp(10),
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
            ),
          ),
        ),
      ],
    );
  }
}
