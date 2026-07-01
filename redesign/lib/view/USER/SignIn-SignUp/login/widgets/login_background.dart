import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

class LoginBackground extends StatelessWidget {
  LoginBackground({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final size = MediaQuery.of(context).size;

    return Stack(
      children: [
        /// TOP GRADIENT BACKGROUND
        Container(
          height: size.height * 0.45,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(ResponsiveHelper.w(48)),
              bottomRight: Radius.circular(ResponsiveHelper.w(48)),
            ),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.accent, // Spotify green
                Color(0xFF15883E), // darker green
                Color(0xFF0B3D20), // deep green-black blend
              ],
              stops: [0.0, 0.45, 1.0],
            ),
          ),
        ),

        /// ABSTRACT BACKGROUND SHAPE
        Positioned(
          top: -10,
          left: ResponsiveHelper.w(30),
          right: -50,
          child: Opacity(
            opacity: 0.8,
            child: Transform.rotate(
              angle: -0.5,
              child: Text(
                'Z',
                textAlign: TextAlign.center,
                style: GoogleFonts.luckiestGuy(
                  fontSize: size.width * 1.1,
                  color: Colors.white,
                  height: ResponsiveHelper.h(1),
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
