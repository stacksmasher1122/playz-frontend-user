import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

Color kCard = Color(0xFF1A1A1A);
Color kMuted = Color(0xFFA7A7A7);
Color kGreen = AppColors.accent;
Color kYellow = Color(0xFFFFC107);

class AcademyReviewsSection extends StatelessWidget {
  AcademyReviewsSection({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Reviews (128)',
              style: TextStyle(
                color: Colors.white,
                fontSize: ResponsiveHelper.sp(18),
                fontWeight: FontWeight.bold,
              ),
            ),
            Spacer(),
            Text('View All', style: TextStyle(color: kGreen)),
          ],
        ),
        SizedBox(height: 12),
        ReviewTile(
          name: 'Rohan M.',
          rating: 5,
          text:
              'Best academy for kids in Kothrud. Coaches are patient and the ground is well maintained.',
        ),
        SizedBox(height: 10),
        ReviewTile(
          name: 'Priya S.',
          rating: 4,
          text:
              'Good facilities but evening batches get crowded. Morning slots are perfect.',
        ),
      ],
    );
  }
}

class ReviewTile extends StatelessWidget {
  final String name;
  final int rating;
  final String text;

  ReviewTile({
    super.key,
    required this.name,
    required this.rating,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.w(14)),
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(14)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: Colors.grey.shade700,
                child: Icon(Icons.person, size: 16, color: Colors.white),
              ),
              SizedBox(width: 8),
              Text(
                name,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(),
              Row(
                children: List.generate(
                  5,
                  (i) => Icon(
                    Icons.star,
                    size: 14,
                    color: i < rating ? kYellow : Colors.grey,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(text, style: TextStyle(color: kMuted, height: 1.4)),
        ],
      ),
    );
  }
}
