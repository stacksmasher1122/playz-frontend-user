import 'package:flutter/material.dart';
import 'package:redesign/theme/responsive_helper.dart';

class FormatOptionWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  FormatOptionWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
          border: Border.all(
            color: isSelected ? Color(0xFFC6FF00) : Colors.grey.shade800,
            width: isSelected ? 2.0 : 1.0,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Color(0xFFC6FF00).withValues(alpha: 0.15),
                    blurRadius: 12,
                    spreadRadius: 2,
                  )
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                color: isSelected ? Color(0xFFC6FF00) : Colors.white,
                fontSize: ResponsiveHelper.sp(16),
                fontWeight: FontWeight.w900,
              ),
            ),
            SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                color: isSelected ? Color(0xFFC6FF00).withValues(alpha: 0.7) : Colors.grey,
                fontSize: ResponsiveHelper.sp(10),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
