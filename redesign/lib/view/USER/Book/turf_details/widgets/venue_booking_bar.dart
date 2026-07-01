import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

class VenueBookingBar extends StatelessWidget {
  final VoidCallback onBookNow;

  VenueBookingBar({
    super.key,
    required this.onBookNow,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16), vertical: ResponsiveHelper.h(12)),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(ResponsiveHelper.w(20)),
              topRight: Radius.circular(ResponsiveHelper.w(20)),
            ),
            color: Color.fromRGBO(0, 0, 0, 0.9),
            border: Border(
              top: BorderSide(color: Color.fromARGB(100, 163, 163, 163)),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Starts from ₹1000/hr',
                  style: TextStyle(
                    color: AppColors.accent,
                    fontSize: ResponsiveHelper.sp(16),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  padding: EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(ResponsiveHelper.w(30)),
                  ),
                ),
                onPressed: onBookNow,
                child: Text(
                  'Book Now',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
