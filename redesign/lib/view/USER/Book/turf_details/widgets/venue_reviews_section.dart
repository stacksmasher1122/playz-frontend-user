import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';

class VenueReviewsSection extends StatelessWidget {
  const VenueReviewsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Text(
                'Reviews',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
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
          const SizedBox(height: 12),
          _reviewCard(
            'Michael S.',
            'Great facilities and well maintained equipment.',
          ),
          const SizedBox(height: 12),
          _reviewCard('Priya K.', 'Spacious and clean. Friendly trainers.'),
        ],
      ),
    );
  }

  Widget _reviewCard(String name, String comment) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundImage: NetworkImage('https://i.pravatar.cc/150'),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: List.generate(
                    5,
                    (index) =>
                        const Icon(Icons.star, size: 14, color: Colors.amber),
                  ),
                ),
                Text(
                  comment,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Color(0xFFA7A7A7)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
