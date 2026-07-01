import 'package:flutter/material.dart';
import 'package:redesign/theme/responsive_helper.dart';

class InfoDetailRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color valueColor;

  InfoDetailRow({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(20), vertical: ResponsiveHelper.h(20)),
      child: Row(
        children: [
          Icon(icon, color: Colors.white54, size: 22),
          SizedBox(width: 16),
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: ResponsiveHelper.sp(15),
              fontWeight: FontWeight.w500,
            ),
          ),
          Spacer(),
          Text(
            value,
            style: TextStyle(color: valueColor, fontSize: 15),
          ),
        ],
      ),
    );
  }
}
