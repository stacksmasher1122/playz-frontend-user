import 'package:flutter/material.dart';
import 'package:redesign/theme/responsive_helper.dart';

class RecommendedVenuesList extends StatelessWidget {
  final List<String> images;

  RecommendedVenuesList({
    super.key,
    required this.images,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16)),
          child: Text(
            'You Might Also Like',
            style: TextStyle(
              color: Colors.white,
              fontSize: ResponsiveHelper.sp(18),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 12),
        SizedBox(
          height: ResponsiveHelper.h(200),
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16)),
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            itemBuilder: (_, index) {
              return Container(
                width: ResponsiveHelper.w(160),
                margin: EdgeInsets.only(right: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
                      child: Image.network(
                        images[index],
                        height: ResponsiveHelper.h(120),
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Gold\'s Gym',
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      '2.3 km • ₹1200/hr',
                      style: TextStyle(color: Color(0xFFA7A7A7)),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
