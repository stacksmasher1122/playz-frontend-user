import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/cricket_model.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/cricket_controller.dart';
import 'package:redesign/theme/responsive_helper.dart';

const kSurface = Color(0xFF0E0E0E);
const kGreen = Color(0xFF00FF00); // Note: AppColors.accent equivalent
const kRed = Color(0xFFE53935);
const kMuted = Color(0xFFA7A7A7);

class LiveMatchPreviewCard extends StatelessWidget {
  final CricketMatchModel match;
  LiveMatchPreviewCard({super.key, required this.match});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(ResponsiveHelper.w(20)),
      decoration: BoxDecoration(
        color: kSurface,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(24)),
        border: Border.all(color: kRed.withValues(alpha: 0.15)),
        boxShadow: [
          BoxShadow(
            color: kRed.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: ResponsiveHelper.w(8), height: ResponsiveHelper.h(8),
                    decoration: BoxDecoration(color: kRed, shape: BoxShape.circle),
                  ),
                  SizedBox(width: 8),
                  Text('LIVE NOW', style: TextStyle(color: kRed, fontSize: ResponsiveHelper.sp(10), fontWeight: FontWeight.w900)),
                ],
              ),
              Icon(Icons.arrow_forward_ios, size: 12, color: kMuted),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _teamInfo(match.homeTeamName, match.innings1Score, match.innings1Wickets, match.currentInnings == 1),
              Text('VS', style: TextStyle(color: kMuted, fontWeight: FontWeight.w900, fontSize: 10)),
              _teamInfo(match.awayTeamName, match.innings2Score, match.innings2Wickets, match.currentInnings == 2),
            ],
          ),
          SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(12)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ResponsiveHelper.w(12))),
                elevation: 0,
              ),
              onPressed: () {
                final controller = Get.find<CricketController>();
                controller.resumeMatch(match.matchId);
              },
              child: Text('Resume Scoring', style: TextStyle(fontWeight: FontWeight.w800)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _teamInfo(String name, int runs, int wkts, bool isBatting) {
    return Expanded(
      child: Column(
        crossAxisAlignment: isBatting ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: [
          Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: isBatting ? Colors.white : kMuted,
              fontSize: ResponsiveHelper.sp(14),
              fontWeight: isBatting ? FontWeight.w800 : FontWeight.w500,
            ),
          ),
          SizedBox(height: 4),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$runs',
                style: TextStyle(
                  color: isBatting ? Color(0xFF00FF00) : Colors.white70, // Using literal kGreen here
                  fontSize: ResponsiveHelper.sp(18),
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                '/$wkts',
                style: TextStyle(color: kMuted, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
