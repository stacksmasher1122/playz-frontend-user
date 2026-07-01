import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

class VenueReviewsSection extends StatelessWidget {
  VenueReviewsSection({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Reviews',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: ResponsiveHelper.sp(18),
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(),
              Text(
                'View All (128)',
                style: TextStyle(color: AppColors.accent),
              ),
            ],
          ),
          SizedBox(height: 12),
          _reviewCard(
            'Michael S.',
            'Great facilities and well maintained equipment.',
          ),
          SizedBox(height: 12),
          _reviewCard('Priya K.', 'Spacious and clean. Friendly trainers.'),
        ],
      ),
    );
  }

  Widget _reviewCard(String name, String comment) {
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.w(12)),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage('https://i.pravatar.cc/150'),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: List.generate(
                    5,
                    (index) =>
                        Icon(Icons.star, size: 14, color: Colors.amber),
                  ),
                ),
                Text(
                  comment,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Color(0xFFA7A7A7)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
