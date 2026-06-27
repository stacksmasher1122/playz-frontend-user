import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';

class VenueBookingBar extends StatelessWidget {
  final VoidCallback onBookNow;

  const VenueBookingBar({
    super.key,
    required this.onBookNow,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            color: Color.fromRGBO(0, 0, 0, 0.9),
            border: Border(
              top: BorderSide(color: Color.fromARGB(100, 163, 163, 163)),
            ),
          ),
          child: Row(
            children: [
              const Expanded(
                child: Text(
                  'Starts from ₹1000/hr',
                  style: TextStyle(
                    color: AppColors.accent,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: onBookNow,
                child: const Text(
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
