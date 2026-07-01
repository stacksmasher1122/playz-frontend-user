import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:redesign/theme/responsive_helper.dart';

class SwipeHint extends StatelessWidget {
  SwipeHint({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Transform.translate(
      offset: Offset(0, -180),
      child: IgnorePointer(
        child: Lottie.network(
          "https://lottie.host/a1d11b19-208b-476f-b609-4024aa19346a/aM8n14FXfT.json",
          width: ResponsiveHelper.w(150),
          height: ResponsiveHelper.h(150),
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
