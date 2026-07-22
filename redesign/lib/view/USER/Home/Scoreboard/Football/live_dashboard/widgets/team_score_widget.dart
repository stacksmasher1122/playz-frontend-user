import 'package:redesign/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:redesign/theme/responsive_helper.dart';

class TeamScoreWidget extends StatelessWidget {
  final String teamName;
  final String? logoUrl;

  TeamScoreWidget({
    super.key,
    required this.teamName,
    this.logoUrl,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: ResponsiveHelper.w(50),
          height: ResponsiveHelper.h(50),
          decoration: BoxDecoration(
            color: AppColors.background,
            shape: BoxShape.circle,
            border: Border.all(color: Color(0xFF1E1E1E)),
            image: logoUrl != null
                ? DecorationImage(
                    image: NetworkImage(logoUrl!),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: logoUrl == null
              ? Icon(Icons.shield, color: Colors.blueAccent, size: 24)
              : null,
        ),
        SizedBox(height: 8),
        Text(
          teamName.toUpperCase(),
          style: TextStyle(
            color: Colors.white,
            fontSize: ResponsiveHelper.sp(12),
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
