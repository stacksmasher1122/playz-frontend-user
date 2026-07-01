import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

class VenueTitleSection extends StatelessWidget {
  VenueTitleSection({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// VENUE INFO
        Padding(
          padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Text(
                'CrossFit Arena',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: ResponsiveHelper.sp(26),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 6),
              Row(
                children: [
                  Icon(Icons.location_on, color: Colors.grey, size: 16),
                  SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      'Narhe, Pune • 7.9 km away',
                      style: TextStyle(color: Color(0xFFA7A7A7)),
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      backgroundColor: AppColors.accent.withValues(alpha: 0.15),
                      foregroundColor: AppColors.accent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(ResponsiveHelper.w(20)),
                      ),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'Open Now',
                      style: TextStyle(fontSize: ResponsiveHelper.sp(12), fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        SizedBox(height: 0),

        /// RATING ROW
        Padding(
          padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16)),
          child: Row(
            children: [
              Row(
                children: List.generate(
                  5,
                  (index) => Icon(
                    Icons.star,
                    size: 16,
                    color: index < 4 ? Colors.amber : Colors.grey,
                  ),
                ),
              ),
              SizedBox(width: 8),
              Text(
                '5.0',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 6),
              Text(
                '(128 Reviews)',
                style: TextStyle(color: Color(0xFFA7A7A7)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
