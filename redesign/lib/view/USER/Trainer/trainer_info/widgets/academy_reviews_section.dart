import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';

const Color kCard = Color(0xFF1A1A1A);
const Color kMuted = Color(0xFFA7A7A7);
const Color kGreen = AppColors.accent;
const Color kYellow = Color(0xFFFFC107);

class AcademyReviewsSection extends StatelessWidget {
  const AcademyReviewsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Text(
              'Reviews (128)',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Spacer(),
            Text('View All', style: TextStyle(color: kGreen)),
          ],
        ),
        const SizedBox(height: 12),
        const ReviewTile(
          name: 'Rohan M.',
          rating: 5,
          text:
              'Best academy for kids in Kothrud. Coaches are patient and the ground is well maintained.',
        ),
        const SizedBox(height: 10),
        const ReviewTile(
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

  const ReviewTile({
    super.key,
    required this.name,
    required this.rating,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: Colors.grey.shade700,
                child: const Icon(Icons.person, size: 16, color: Colors.white),
              ),
              const SizedBox(width: 8),
              Text(
                name,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
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
          const SizedBox(height: 8),
          Text(text, style: const TextStyle(color: kMuted, height: 1.4)),
        ],
      ),
    );
  }
}
