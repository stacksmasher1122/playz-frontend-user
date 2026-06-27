import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';

const Color kBg = AppColors.background;

class SportMatchSetupScreen extends StatelessWidget {
  final String sport;

  const SportMatchSetupScreen({super.key, required this.sport});

  @override
  Widget build(BuildContext context) {
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
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
