import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

Color kBg = AppColors.background;

class SportMatchSetupScreen extends StatelessWidget {
  final String sport;

  SportMatchSetupScreen({super.key, required this.sport});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        backgroundColor: kBg,
        elevation: 0,
        title: Text('$sport Match Setup'),
      ),
      body: Center(
        child: Text(
          'Setup screen for $sport',
          style: TextStyle(
            color: Colors.white,
            fontSize: ResponsiveHelper.sp(18),
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
