import 'package:flutter/material.dart';
import 'package:redesign/theme/responsive_helper.dart';

class ShutterButton extends StatelessWidget {
  final VoidCallback onTap;

  ShutterButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(ResponsiveHelper.w(4)),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 3),
        ),
        child: Container(
          width: ResponsiveHelper.w(72),
          height: ResponsiveHelper.h(72),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
