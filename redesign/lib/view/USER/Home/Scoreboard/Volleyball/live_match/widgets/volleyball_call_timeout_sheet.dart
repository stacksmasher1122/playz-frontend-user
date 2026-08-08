import 'package:flutter/material.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Volleyball/volleyball_controller.dart';

/// Modal bottom sheet for calling Volleyball timeouts matching the attached design screenshot.
class VolleyballCallTimeoutSheet extends StatefulWidget {
  final VolleyballController controller;

  const VolleyballCallTimeoutSheet({
    super.key,
    required this.controller,
  });

  static void show(BuildContext context, VolleyballController controller) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF10141E),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(ResponsiveHelper.w(24.0))),
      ),
      builder: (ctx) => VolleyballCallTimeoutSheet(controller: controller),
    );
  }

  @override
  State<VolleyballCallTimeoutSheet> createState() => _VolleyballCallTimeoutSheetState();
}

class _VolleyballCallTimeoutSheetState extends State<VolleyballCallTimeoutSheet> {
  String _selectedTeam = 'sideA';

  void _onSelectTeam(String team) {
    setState(() {
      _selectedTeam = team;
    });
    widget.controller.useTimeout(team);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final state = widget.controller.liveState.value;

    final homeName = widget.controller.currentMatch.value?.homeTeam.isNotEmpty == true
        ? widget.controller.currentMatch.value!.homeTeam
        : 'SIDE A';
    final awayName = widget.controller.currentMatch.value?.awayTeam.isNotEmpty == true
        ? widget.controller.currentMatch.value!.awayTeam
        : 'SIDE B';

    final timeoutsA = state?.timeoutsRemainingA ?? 2;
    final timeoutsB = state?.timeoutsRemainingB ?? 2;

    const Color greenColor = Color(0xFF00E676);
    const Color blueColor = Color(0xFF448AFF);
    const Color cardBgColor = Color(0xFF10141E);
    const Color borderDividerColor = Color(0xFF1D2638);

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

          // ─── 2. HEADER ROW (ICON + TITLE) ───
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(ResponsiveHelper.w(8.0)),
                decoration: BoxDecoration(
                  color: greenColor.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                  border: Border.all(color: greenColor.withValues(alpha: 0.4), width: 1.0),
                ),
                child: Icon(
                  Icons.timer_outlined,
                  color: greenColor,
                  size: ResponsiveHelper.w(22.0),
                ),
              ),
              SizedBox(width: ResponsiveHelper.w(12.0)),
              Text(
                'CALL TIMEOUT',
                style: AppTypography.headlineSm.copyWith(
                  color: Colors.white,
                  fontSize: ResponsiveHelper.sp(18.0),
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.0,
                ).responsive(context),
              ),
            ],
          ),

          SizedBox(height: ResponsiveHelper.h(14.0)),

          Container(
            width: double.infinity,
            height: 1.0,
            color: borderDividerColor,
          ),

          SizedBox(height: ResponsiveHelper.h(16.0)),

          // ─── 3. SUBTITLE ───
          Center(
            child: Text(
              'Select which side is calling a timeout.',
              style: AppTypography.bodySm.copyWith(
                color: const Color(0xFF7E8B9B),
                fontSize: ResponsiveHelper.sp(13.0),
                fontWeight: FontWeight.w500,
              ).responsive(context),
            ),
          ),

          SizedBox(height: ResponsiveHelper.h(16.0)),

          // ─── 4. SIDE A CARD ───
          _buildTeamTimeoutCard(
            context,
            teamKey: 'sideA',
            teamName: homeName.toUpperCase(),
            timeoutsRemaining: timeoutsA,
            accentColor: greenColor,
            bgColor: const Color(0xFF0D1F17),
            iconBgColor: const Color(0xFF133822),
            isSelected: _selectedTeam == 'sideA',
            onTap: () => _onSelectTeam('sideA'),
          ),

          SizedBox(height: ResponsiveHelper.h(12.0)),

          // ─── 5. SIDE B CARD ───
          _buildTeamTimeoutCard(
            context,
            teamKey: 'sideB',
            teamName: awayName.toUpperCase(),
            timeoutsRemaining: timeoutsB,
            accentColor: blueColor,
            bgColor: const Color(0xFF0D1B30),
            iconBgColor: const Color(0xFF132B4A),
            isSelected: _selectedTeam == 'sideB',
            onTap: () => _onSelectTeam('sideB'),
          ),

          SizedBox(height: ResponsiveHelper.h(16.0)),

          // ─── 6. RULES INFO CONTAINER ───
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(ResponsiveHelper.w(16.0)),
            decoration: BoxDecoration(
              color: const Color(0xFF0E1420),
              borderRadius: BorderRadius.circular(ResponsiveHelper.w(16.0)),
              border: Border.all(
                color: borderDividerColor,
                width: 1.0,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  color: blueColor,
                  size: ResponsiveHelper.w(20.0),
                ),
                SizedBox(width: ResponsiveHelper.w(12.0)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Each team is allowed 2 timeouts per set.',
                        style: AppTypography.bodySm.copyWith(
                          color: const Color(0xFF9EABBE),
                          fontSize: ResponsiveHelper.sp(12.5),
                          fontWeight: FontWeight.w500,
                        ).responsive(context),
                      ),
                      SizedBox(height: ResponsiveHelper.h(2.0)),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Timeout duration: ',
                              style: AppTypography.bodySm.copyWith(
                                color: const Color(0xFF9EABBE),
                                fontSize: ResponsiveHelper.sp(12.5),
                                fontWeight: FontWeight.w500,
                              ).responsive(context),
                            ),
                            TextSpan(
                              text: '30 seconds.',
                              style: AppTypography.bodySm.copyWith(
                                color: blueColor,
                                fontSize: ResponsiveHelper.sp(12.5),
                                fontWeight: FontWeight.bold,
                              ).responsive(context),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: ResponsiveHelper.h(16.0)),

          // ─── 7. CANCEL BUTTON ───
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
                  side: const BorderSide(color: Color(0xFF232E42), width: 1.2),
                ),
              ),
              onPressed: () => Navigator.pop(context),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.close_rounded,
                    color: const Color(0xFF7E8B9B),
                    size: ResponsiveHelper.w(18.0),
                  ),
                  SizedBox(width: ResponsiveHelper.w(6.0)),
                  Text(
                    'CANCEL',
                    style: AppTypography.labelCaps.copyWith(
                      color: const Color(0xFF7E8B9B),
                      fontSize: ResponsiveHelper.sp(14.0),
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.8,
                    ).responsive(context),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: ResponsiveHelper.h(10.0)),
        ],
      ),
    );
  }

  // ─── HELPER: TEAM TIMEOUT SELECTION CARD ───
  Widget _buildTeamTimeoutCard(
    BuildContext context, {
    required String teamKey,
    required String teamName,
    required int timeoutsRemaining,
    required Color accentColor,
    required Color bgColor,
    required Color iconBgColor,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final String remainingText = timeoutsRemaining == 1
        ? '1 timeout remaining'
        : '$timeoutsRemaining timeouts remaining';

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
              // Icon Box
              Container(
                width: ResponsiveHelper.w(48.0),
                height: ResponsiveHelper.w(48.0),
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(ResponsiveHelper.w(12.0)),
                ),
                child: Center(
                  child: Icon(
                    Icons.timer_outlined,
                    color: Colors.white,
                    size: ResponsiveHelper.w(22.0),
                  ),
                ),
              ),

              SizedBox(width: ResponsiveHelper.w(14.0)),

              // Team Name & Remaining Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      teamName,
                      style: AppTypography.headlineSm.copyWith(
                        color: Colors.white,
                        fontSize: ResponsiveHelper.sp(16.0),
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5,
                      ).responsive(context),
                    ),
                    SizedBox(height: ResponsiveHelper.h(4.0)),
                    Text(
                      remainingText,
                      style: AppTypography.bodySm.copyWith(
                        color: accentColor,
                        fontSize: ResponsiveHelper.sp(13.0),
                        fontWeight: FontWeight.w600,
                      ).responsive(context),
                    ),
                  ],
                ),
              ),

              // Vertical Divider Line before Radio
              Container(
                width: 1.0,
                height: ResponsiveHelper.h(36.0),
                color: const Color(0xFF1D2638),
              ),

              SizedBox(width: ResponsiveHelper.w(14.0)),

              // Custom Radio Indicator (Outer Ring + Inner Circle)
              Container(
                width: ResponsiveHelper.w(24.0),
                height: ResponsiveHelper.w(24.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: accentColor,
                    width: 2.0,
                  ),
                ),
                child: isSelected
                    ? Center(
                        child: Container(
                          width: ResponsiveHelper.w(12.0),
                          height: ResponsiveHelper.w(12.0),
                          decoration: BoxDecoration(
                            color: accentColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
