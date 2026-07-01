import 'package:flutter/material.dart';
import 'package:redesign/theme/responsive_helper.dart';

class ServiceIndicatorWidget extends StatelessWidget {
  final bool isActive;
  final bool isLeft;

  ServiceIndicatorWidget({
    super.key,
    required this.isActive,
    required this.isLeft,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      width: ResponsiveHelper.w(40),
      height: ResponsiveHelper.h(40),
      decoration: BoxDecoration(
        color: isActive ? Color(0xFFC6FF00) : Colors.grey.shade900,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: Color(0xFFC6FF00).withValues(alpha: 0.3),
                  blurRadius: 15,
                  spreadRadius: 2,
                )
              ]
            : null,
      ),
      child: Center(
        child: Icon(
          isActive ? Icons.sports_tennis : Icons.person_outline,
          color: isActive ? Colors.black : Colors.grey.shade600,
          size: 24,
        ),
      ),
    );
  }
}
