import 'package:flutter/material.dart';
import '../match_detail_constants.dart';
import 'package:redesign/theme/responsive_helper.dart';

class MatchLocationCard extends StatelessWidget {
  MatchLocationCard({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      decoration: BoxDecoration(
        color: MatchDetailColors.surfaceSoft,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(30)),
      ),
      child: Column(
        children: [
          Container(
            height: ResponsiveHelper.h(140),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(ResponsiveHelper.w(30))),
              image: DecorationImage(
                image: NetworkImage(
                  "https://images.unsplash.com/photo-1508609349937-5ec4ae374ebf",
                ),
                fit: BoxFit.cover,
                opacity: 0.35,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(ResponsiveHelper.w(22)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Badminton Hub",
                  style: TextStyle(fontSize: ResponsiveHelper.sp(18), fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 6),
                Text(
                  "Sector 4, HSR Layout",
                  style: TextStyle(color: MatchDetailColors.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
