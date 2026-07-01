import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../../controller/User_Controller/Home_Controller/Scoreboard_Controller/Badminton/match_timeline_controller.dart';
import 'score_summary_widget.dart';
import 'package:redesign/theme/responsive_helper.dart';

class WinnerSummaryCard extends StatefulWidget {
  WinnerSummaryCard({super.key});

  @override
  State<WinnerSummaryCard> createState() => _WinnerSummaryCardState();
}

class _WinnerSummaryCardState extends State<WinnerSummaryCard> with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _opacity;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );
    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeIn),
    );
    _slide = Tween<Offset>(begin: Offset(0, 0.2), end: Offset.zero).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final controller = Get.find<MatchTimelineController>();

    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(
        position: _slide,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16.0), vertical: ResponsiveHelper.h(12.0)),
          padding: EdgeInsets.all(ResponsiveHelper.w(20)),
          decoration: BoxDecoration(
            color: Colors.grey.shade900.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
            border: Border.all(color: Colors.grey.shade800),
          ),
          child: Stack(
            children: [
              // Faint trophy watermark
              Positioned(
                right: -20,
                top: -20,
                child: Icon(
                  Icons.emoji_events_outlined,
                  size: 120,
                  color: Colors.grey.shade800.withValues(alpha: 0.3),
                ),
              ),
              Obx(() {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (controller.isTournamentChampion.value)
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(12), vertical: ResponsiveHelper.h(6)),
                        decoration: BoxDecoration(
                          color: Color(0xFFC6FF00), // Neon Yellow-Green
                          borderRadius: BorderRadius.circular(ResponsiveHelper.w(20)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.emoji_events, color: Colors.black, size: 14),
                            SizedBox(width: 4),
                            Text(
                              'TOURNAMENT CHAMPION',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: ResponsiveHelper.sp(10),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    SizedBox(height: 16),
                    RichText(
                      text: TextSpan(
                        text: 'WINNER: ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: ResponsiveHelper.sp(28),
                          fontWeight: FontWeight.w900,
                          fontStyle: FontStyle.italic,
                        ),
                        children: [
                          TextSpan(
                            text: controller.winnerName.value,
                            style: TextStyle(
                              color: Color(0xFFC6FF00),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'FINAL\nSCORE',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: ResponsiveHelper.sp(10),
                                fontWeight: FontWeight.bold,
                                height: ResponsiveHelper.h(1.2),
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              controller.finalScore.value,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: ResponsiveHelper.sp(32),
                                fontWeight: FontWeight.w900,
                                fontFeatures: [FontFeature.tabularFigures()],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: ScoreSummaryWidget(
                            gameScores: controller.gameScores,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
