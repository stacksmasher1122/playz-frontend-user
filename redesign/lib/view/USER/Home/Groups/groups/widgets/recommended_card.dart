import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

const kGreen = AppColors.accent;
const kMuted = Colors.white70;

class RecommendedCard extends StatelessWidget {
  final String name;
  final String members;
  final String status;
  final String imageUrl;

  RecommendedCard({
    super.key,
    required this.name,
    required this.members,
    required this.status,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16)),
      child: Container(
        padding: EdgeInsets.all(ResponsiveHelper.w(16)),
        decoration: BoxDecoration(
          color: Color(0xFF161616),
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(32)),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: Colors.white,
              child: Padding(
                padding: EdgeInsets.all(ResponsiveHelper.w(4.0)),
                child: CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(imageUrl),
                ),
              ),
            ),
            SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: ResponsiveHelper.sp(15),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '$members • $status',
                    style: TextStyle(
                      color: kMuted,
                      fontSize: ResponsiveHelper.sp(10),
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: kGreen,
                foregroundColor: Colors.black,
                elevation: 0,
                minimumSize: Size(64, 32),
                padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
                ),
              ),
              child: Text(
                'JOIN',
                style: TextStyle(
                  fontSize: ResponsiveHelper.sp(12),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
