import 'package:flutter/material.dart';
import 'package:redesign/theme/responsive_helper.dart';

Color kCard = Color(0xFF1A1A1A);

class LocationMapCard extends StatelessWidget {
  LocationMapCard({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Location',
          style: TextStyle(
            color: Colors.white,
            fontSize: ResponsiveHelper.sp(18),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12),
        Container(
          height: ResponsiveHelper.h(160),
          decoration: BoxDecoration(
            color: kCard,
            borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(ResponsiveHelper.w(20)),
                child: Opacity(
                  opacity: 0.5,
                  child: Image.network(
                    'https://img.freepik.com/premium-vector/colored-city-map-digital-concept_23-2148311690.jpg',
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.near_me, size: 18),
                label: Text('Get Directions'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(ResponsiveHelper.w(30)),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
