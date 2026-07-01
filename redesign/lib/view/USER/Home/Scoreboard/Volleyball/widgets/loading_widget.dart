import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black54,
      child: const Center(
        child: CircularProgressIndicator(
          color: AppColors.primaryContainer,
        ),
      ),
    );
  }
}
