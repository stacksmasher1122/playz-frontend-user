import 'package:flutter/material.dart';
import 'package:redesign/theme/responsive_helper.dart';

Color kCard = Color(0xFF1A1A1A);

class SafetyAmenitiesTags extends StatelessWidget {
  SafetyAmenitiesTags({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    const items = ['CCTV Monitored', 'First Aid Kit', 'RO Water', 'Change Rooms'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Safety & Amenities',
          style: TextStyle(
            color: Colors.white,
            fontSize: ResponsiveHelper.sp(18),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: items
              .map(
                (e) => Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: kCard,
                    borderRadius: BorderRadius.circular(ResponsiveHelper.w(30)),
                  ),
                  child: Text(
                    e,
                    style: TextStyle(color: Colors.white, fontSize: 13),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
