import 'package:flutter/material.dart';
import '../match_detail_constants.dart';
import 'package:redesign/theme/responsive_helper.dart';

class MatchSlotsCard extends StatelessWidget {
  MatchSlotsCard({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.w(22)),
      decoration: BoxDecoration(
        color: MatchDetailColors.surfaceSoft,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(30)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Slots Filling Fast",
                      style: TextStyle(
                        fontSize: ResponsiveHelper.sp(12),
                        color: MatchDetailColors.textSecondary,
                      ),
                    ),
                    SizedBox(height: 6),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "8",
                          style: TextStyle(
                            fontSize: ResponsiveHelper.sp(36),
                            fontWeight: FontWeight.bold,
                            color: MatchDetailColors.urgent,
                          ),
                        ),
                        SizedBox(width: 6),
                        Text(
                          "/ 10",
                          style: TextStyle(
                            fontSize: ResponsiveHelper.sp(18),
                            color: MatchDetailColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "Match Quality",
                    style: TextStyle(
                      fontSize: ResponsiveHelper.sp(12),
                      color: MatchDetailColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    "High Priority ⚡",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: MatchDetailColors.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 18),
          ClipRRect(
            borderRadius: BorderRadius.circular(ResponsiveHelper.w(10)),
            child: Container(
              height: ResponsiveHelper.h(10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFF59E0B), Color(0xFFFFB020)],
                ),
              ),
            ),
          ),
          SizedBox(height: 18),
          Divider(color: Colors.white12),
          SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _StatColumn("Average Rating", "4.2 ⭐"),
              _StatColumn("Skill Spread", "Balanced ⚖️"),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatColumn extends StatelessWidget {
  final String title;
  final String value;

  _StatColumn(this.title, this.value);

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: TextStyle(
            fontSize: ResponsiveHelper.sp(11),
            color: MatchDetailColors.textSecondary,
          ),
        ),
        SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(fontSize: ResponsiveHelper.sp(16), fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
