import 'package:flutter/material.dart';
import 'package:redesign/theme/responsive_helper.dart';

class TeamBadgeWidget extends StatelessWidget {
  final String logoUrl;

  TeamBadgeWidget({super.key, required this.logoUrl});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      width: ResponsiveHelper.w(100),
      height: ResponsiveHelper.h(100),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
        border: Border.all(color: Color(0xFFC6FF00), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Color(0xFFC6FF00).withValues(alpha: 0.2),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      padding: EdgeInsets.all(ResponsiveHelper.w(4)),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade900,
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
          // Using a placeholder icon as the logoUrl from the dummy data is just a placeholder
          // You would normally use Image.network(logoUrl)
        ),
        child: Icon(
          Icons.shield,
          color: Colors.greenAccent,
          size: 60,
        ),
      ),
    );
  }
}
