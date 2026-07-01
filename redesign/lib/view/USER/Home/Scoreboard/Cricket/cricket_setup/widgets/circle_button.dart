import 'package:flutter/material.dart';
import 'package:redesign/theme/responsive_helper.dart';

class CircleButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Color iconColor;
  final VoidCallback onTap;
  final double size;
  final double iconSize;

  CircleButton({
    super.key,
    required this.icon,
    required this.color,
    required this.iconColor,
    required this.onTap,
    this.size = 40,
    this.iconSize = 20,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        child: Icon(icon, color: iconColor, size: iconSize),
      ),
    );
  }
}
