import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:redesign/theme/responsive_helper.dart';

const kMuted = Color(0xFFA7A7A7);

class LiveMatchesEmptyState extends StatelessWidget {
  LiveMatchesEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(24.0)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 40),
            Lottie.network(
              'https://lottie.host/77d43ff5-2fda-40e0-b208-533e7788caff/tGiSgVZpJ6.json',
              height: ResponsiveHelper.h(180),
              fit: BoxFit.contain,
            ),
            SizedBox(height: 20),
            Text(
              'No live scoreboard or match,\ncreate your own scoreboard',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: kMuted,
                fontSize: ResponsiveHelper.sp(16),
                height: ResponsiveHelper.h(1.4),
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 60),
          ],
        ),
      ),
    );
  }
}
