import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

class VenueAboutSection extends StatelessWidget {
  final bool isExpanded;
  final VoidCallback onToggleExpand;

  VenueAboutSection({
    super.key,
    required this.isExpanded,
    required this.onToggleExpand,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About Venue',
            style: TextStyle(
              color: Colors.white,
              fontSize: ResponsiveHelper.sp(18),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Experience premium CrossFit training with state-of-the-art equipment, cardio zones, and expert trainers. Perfect for strength and endurance.',
            maxLines: isExpanded ? null : 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Color(0xFFA7A7A7)),
          ),
          GestureDetector(
            onTap: onToggleExpand,
            child: Text(
              isExpanded ? 'Read more' : 'Read less',
              style: TextStyle(color: AppColors.accent),
            ),
          ),
          SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
            child: Stack(
              children: [
                Image.network(
                  'https://images.unsplash.com/photo-1524661135-423995f22d0b?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8N3x8bWFwc3xlbnwwfHwwfHx8MA%3D%3D',
                  height: ResponsiveHelper.h(150),
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  bottom: ResponsiveHelper.h(8),
                  right: ResponsiveHelper.w(8),
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.black.withValues(alpha: 0.7),
                    ),
                    icon: Icon(Icons.directions, size: 16),
                    label: Text('Get Directions'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
