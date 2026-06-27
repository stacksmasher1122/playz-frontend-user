import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SwipeHint extends StatelessWidget {
  const SwipeHint({super.key});

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: const Offset(0, -180),
      child: IgnorePointer(
        child: Lottie.network(
          "https://lottie.host/a1d11b19-208b-476f-b609-4024aa19346a/aM8n14FXfT.json",
          width: 150,
          height: 150,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
