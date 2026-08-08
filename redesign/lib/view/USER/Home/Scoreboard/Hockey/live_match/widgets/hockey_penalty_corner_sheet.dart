import 'package:flutter/material.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Hockey/hockey_controller.dart';

/// Modal bottom sheet for awarding Penalty Corner matching the attached design screenshot.
class HockeyPenaltyCornerSheet extends StatelessWidget {
  final HockeyController controller;
  final String homeName;
  final String awayName;

  const HockeyPenaltyCornerSheet({
    super.key,
    required this.controller,
    required this.homeName,
    required this.awayName,
  });

  static void show(
    BuildContext context,
    HockeyController controller,
    String homeName,
    String awayName,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF10141E),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(ResponsiveHelper.w(24.0))),
      ),
      builder: (ctx) => HockeyPenaltyCornerSheet(
        controller: controller,
        homeName: homeName,
        awayName: awayName,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    const Color greenColor = Color(0xFF00E676);
    const Color blueColor = Color(0xFF448AFF);
    const Color borderDividerColor = Color(0xFF1D2638);
    const Color cardBgColor = Color(0xFF121724);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.w(20.0),
        vertical: ResponsiveHelper.h(14.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ─── 1. TOP DRAG HANDLE PILL ───
          Center(
            child: Container(
              width: ResponsiveHelper.w(44.0),
              height: ResponsiveHelper.h(4.5),
              margin: EdgeInsets.only(bottom: ResponsiveHelper.h(16.0)),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(ResponsiveHelper.w(10.0)),
              ),
            ),
          ),

          // ─── 2. HEADER ROW (FLAG ICON + TITLE) ───
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(ResponsiveHelper.w(10.0)),
                decoration: BoxDecoration(
                  color: greenColor.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                  border: Border.all(color: greenColor.withValues(alpha: 0.4), width: 1.0),
                ),
                child: Icon(
                  Icons.flag_outlined,
                  color: greenColor,
                  size: ResponsiveHelper.w(22.0),
                ),
              ),
              SizedBox(width: ResponsiveHelper.w(12.0)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Award Penalty Corner',
                      style: AppTypography.headlineSm.copyWith(
                        color: Colors.white,
                        fontSize: ResponsiveHelper.sp(18.0),
                        fontWeight: FontWeight.w900,
                      ).responsive(context),
                    ),
                    SizedBox(height: ResponsiveHelper.h(2.0)),
                    Text(
                      'Choose the team to award PC',
                      style: AppTypography.bodySm.copyWith(
                        color: const Color(0xFF7E8B9B),
                        fontSize: ResponsiveHelper.sp(13.0),
                      ).responsive(context),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: ResponsiveHelper.h(20.0)),

          // ─── 3. SIDE A CARD ───
          _buildTeamPCCard(
            context,
            teamName: homeName,
            accentColor: greenColor,
            bgColor: const Color(0xFF0D1F17),
            iconBgColor: const Color(0xFF133822),
            teamLetter: 'A',
            onTap: () {
              Navigator.pop(context);
              controller.addPenaltyCorner('sideA');
            },
          ),

          SizedBox(height: ResponsiveHelper.h(12.0)),

          // ─── 4. SIDE B CARD ───
          _buildTeamPCCard(
            context,
            teamName: awayName,
            accentColor: blueColor,
            bgColor: const Color(0xFF0D1B30),
            iconBgColor: const Color(0xFF132B4A),
            teamLetter: 'B',
            onTap: () {
              Navigator.pop(context);
              controller.addPenaltyCorner('sideB');
            },
          ),

          SizedBox(height: ResponsiveHelper.h(20.0)),

          // ─── 5. CANCEL BUTTON ───
          SizedBox(
            width: double.infinity,
            height: ResponsiveHelper.h(48.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: cardBgColor,
                foregroundColor: const Color(0xFF7E8B9B),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(ResponsiveHelper.w(16.0)),
                  side: const BorderSide(color: borderDividerColor, width: 1.2),
                ),
              ),
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: AppTypography.headlineSm.copyWith(
                  color: Colors.white,
                  fontSize: ResponsiveHelper.sp(15.0),
                  fontWeight: FontWeight.w700,
                ).responsive(context),
              ),
            ),
          ),

          SizedBox(height: ResponsiveHelper.h(10.0)),
        ],
      ),
    );
  }

  Widget _buildTeamPCCard(
    BuildContext context, {
    required String teamName,
    required Color accentColor,
    required Color bgColor,
    required Color iconBgColor,
    required String teamLetter,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(16.0)),
        child: Container(
          padding: EdgeInsets.all(ResponsiveHelper.w(14.0)),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(ResponsiveHelper.w(16.0)),
            border: Border.all(
              color: accentColor,
              width: 1.2,
            ),
          ),
          child: Row(
            children: [
              // Jersey Icon Box with Team Letter
              Container(
                width: ResponsiveHelper.w(48.0),
                height: ResponsiveHelper.w(48.0),
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(ResponsiveHelper.w(12.0)),
                ),
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(
                        Icons.checkroom_rounded,
                        color: accentColor,
                        size: ResponsiveHelper.w(28.0),
                      ),
                      Text(
                        teamLetter,
                        style: AppTypography.labelCaps.copyWith(
                          color: Colors.white,
                          fontSize: ResponsiveHelper.sp(11.0),
                          fontWeight: FontWeight.w900,
                        ).responsive(context),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(width: ResponsiveHelper.w(14.0)),

              // Text Column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Penalty Corner for',
                      style: AppTypography.bodySm.copyWith(
                        color: const Color(0xFF7E8B9B),
                        fontSize: ResponsiveHelper.sp(12.5),
                      ).responsive(context),
                    ),
                    SizedBox(height: ResponsiveHelper.h(3.0)),
                    Text(
                      teamName,
                      style: AppTypography.headlineSm.copyWith(
                        color: accentColor,
                        fontSize: ResponsiveHelper.sp(16.0),
                        fontWeight: FontWeight.w900,
                      ).responsive(context),
                    ),
                  ],
                ),
              ),

              // Chevron Right
              Icon(
                Icons.chevron_right_rounded,
                color: accentColor,
                size: ResponsiveHelper.w(24.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
