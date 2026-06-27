import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TossResultDisplay extends StatelessWidget {
  final Animation<Offset> slideAnimation;
  final Animation<double> opacityAnimation;
  final bool isHeads;

  const TossResultDisplay({
    super.key,
    required this.slideAnimation,
    required this.opacityAnimation,
    required this.isHeads,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: const Offset(0, 220),
      child: SlideTransition(
        position: slideAnimation,
        child: FadeTransition(
          opacity: opacityAnimation,
          child: Text(
            isHeads ? "HEADS" : "TAILS",
            style: GoogleFonts.outfit(
              color: const Color(0xFFF7E7A1),
              fontSize: 34,
              fontWeight: FontWeight.bold,
              letterSpacing: 10,
              shadows: [
                const Shadow(
                  color: Colors.black,
                  blurRadius: 15,
                  offset: Offset(3, 3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
