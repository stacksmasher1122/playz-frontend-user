import 'package:flutter/material.dart';
import 'package:redesign/theme/responsive_helper.dart';

class SwapSideButton extends StatelessWidget {
  final VoidCallback onTap;

  SwapSideButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(ResponsiveHelper.w(10)),
        decoration: BoxDecoration(
          color: Colors.grey.shade900,
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.swap_horiz,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }
}
