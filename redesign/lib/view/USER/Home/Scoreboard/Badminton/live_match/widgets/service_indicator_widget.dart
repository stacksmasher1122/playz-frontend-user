import 'package:flutter/material.dart';

class ServiceIndicatorWidget extends StatelessWidget {
  final bool isActive;
  final bool isLeft;

  const ServiceIndicatorWidget({
    super.key,
    required this.isActive,
    required this.isLeft,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFFC6FF00) : Colors.grey.shade900,
        borderRadius: BorderRadius.circular(12),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: const Color(0xFFC6FF00).withValues(alpha: 0.3),
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
