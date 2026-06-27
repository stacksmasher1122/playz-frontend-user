import 'package:flutter/material.dart';

class RecommendedVenuesList extends StatelessWidget {
  final List<String> images;

  const RecommendedVenuesList({
    super.key,
    required this.images,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'You Might Also Like',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 200,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            itemBuilder: (_, index) {
              return Container(
                width: 160,
                margin: const EdgeInsets.only(right: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        images[index],
                        height: 120,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Gold\'s Gym',
                      style: TextStyle(color: Colors.white),
                    ),
                    const Text(
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
