import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redesign/theme/app_colors.dart';

class RegisterBackground extends StatelessWidget {
  const RegisterBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Stack(
      children: [
        /// TOP GRADIENT
        Container(
          height: size.height * 0.45,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(48),
              bottomRight: Radius.circular(48),
            ),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.accent,
                Color(0x801DB954),
                Color(0x001DB954),
              ],
              stops: [0.0, 0.4, 1.0],
            ),
          ),
        ),

        /// ABSTRACT BACKGROUND SHAPE
        Positioned(
          top: -10,
          left: 30,
          right: -50,
          child: Opacity(
            opacity: 0.6,
            child: Transform.rotate(
              angle: -0.5,
              child: Text(
                'Z',
                textAlign: TextAlign.center,
                style: GoogleFonts.luckiestGuy(
                  fontSize: size.width * 1.1,
                  color: Colors.white,
                  height: 1,
                  letterSpacing: -8,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
