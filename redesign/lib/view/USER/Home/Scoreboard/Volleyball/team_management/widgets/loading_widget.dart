import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

class LoadingWidget extends StatelessWidget {
  LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      color: Colors.black54,
      child: Center(
        child: CircularProgressIndicator(
          color: AppColors.primaryContainer,
        ),
      ),
    );
  }
}
