import 'package:flutter/material.dart';
import 'package:redesign/theme/responsive_helper.dart';

class StadiumBannerWidget extends StatelessWidget {
  final String status;
  final String venueName;

  StadiumBannerWidget({
    super.key,
    required this.status,
    required this.venueName,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      height: ResponsiveHelper.h(150),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.black,
        // Since we cannot use actual assets without knowing them, a mock gradient/image setup
        image: DecorationImage(
          image: NetworkImage('https://images.unsplash.com/photo-1522778119026-d647f0596c20?q=80&w=600'), // Mock stadium photo
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black.withValues(alpha: 0.9),
            ],
          ),
        ),
        padding: EdgeInsets.all(ResponsiveHelper.w(16)),
        alignment: Alignment.bottomLeft,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(8), vertical: ResponsiveHelper.h(4)),
              decoration: BoxDecoration(
                color: Color(0xFFC6FF00), // Lime Green
                borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
              ),
              child: Text(
                status,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: ResponsiveHelper.sp(10),
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            SizedBox(height: 8),
            Text(
              venueName,
              style: TextStyle(
                color: Colors.white,
                fontSize: ResponsiveHelper.sp(18),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
