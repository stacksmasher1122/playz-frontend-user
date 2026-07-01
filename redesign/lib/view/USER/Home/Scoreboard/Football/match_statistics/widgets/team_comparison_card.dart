import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../controller/User_Controller/Home_Controller/Scoreboard_Controller/Football/football_match_statistics_controller.dart';
import '../../../../../../../theme/responsive_helper.dart';
import 'comparison_progress_bar.dart';

class TeamComparisonCard extends StatelessWidget {
  TeamComparisonCard({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final controller = Get.find<FootballMatchStatisticsController>();

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.w(16),
        vertical: ResponsiveHelper.h(8),
      ),
      padding: EdgeInsets.all(ResponsiveHelper.w(24)),
      decoration: BoxDecoration(
        color: Colors.grey.shade900.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(20)),
        border: Border.all(color: Colors.grey.shade800),
      ),
      child: Obx(() {
        final home = controller.homeStatistics.value;
        final away = controller.awayStatistics.value;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.show_chart,
                  color: Color(0xFFC6FF00),
                  size: ResponsiveHelper.w(20),
                ),
                SizedBox(width: ResponsiveHelper.w(8)),
                Text(
                  'TEAM COMPARISON',
                  style: TextStyle(
                    color: Color(0xFFC6FF00).withValues(alpha: 0.8),
                    fontSize: ResponsiveHelper.sp(12),
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
                ),
              ],
            ),
            SizedBox(height: ResponsiveHelper.h(24)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${home.possession.toInt()}%',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: ResponsiveHelper.sp(16),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'POSSESSION',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: ResponsiveHelper.sp(11),
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                Text(
                  '${away.possession.toInt()}%',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: ResponsiveHelper.sp(16),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: ResponsiveHelper.h(12)),
            ComparisonProgressBar(
              homePercentage: home.possession.toDouble(),
              awayPercentage: away.possession.toDouble(),
            ),
            SizedBox(height: ResponsiveHelper.h(24)),
            StatisticsRowWidget(
              title: 'Shots',
              homeValue: '${home.shots}',
              awayValue: '${away.shots}',
            ),
            StatisticsRowWidget(
              title: 'Shots on Target',
              homeValue: '${home.shotsOnTarget}',
              awayValue: '${away.shotsOnTarget}',
            ),
            StatisticsRowWidget(
              title: 'Total Passes',
              homeValue: '${home.passes}',
              awayValue: '${away.passes}',
            ),
            StatisticsRowWidget(
              title: 'Corners',
              homeValue: '${home.corners}',
              awayValue: '${away.corners}',
            ),
            StatisticsRowWidget(
              title: 'Fouls',
              homeValue: '${home.fouls}',
              awayValue: '${away.fouls}',
              isHighlightHome: home.fouls > away.fouls,
              isHighlightAway: away.fouls > home.fouls,
            ),
          ],
        );
      }),
    );
  }
}

class StatisticsRowWidget extends StatelessWidget {
  final String title;
  final dynamic homeValue;
  final dynamic awayValue;
  final bool? isHighlightHome;
  final bool? isHighlightAway;
  StatisticsRowWidget({
    super.key,
    required this.title,
    required this.homeValue,
    required this.awayValue,
    this.isHighlightHome,
    this.isHighlightAway,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(12)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                homeValue.toString(),
                style: TextStyle(
                  color: (isHighlightHome ?? false)
                      ? Color(0xFFC6FF00)
                      : Colors.white,
                  fontSize: ResponsiveHelper.sp(16),
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                title.toUpperCase(),
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: ResponsiveHelper.sp(11),
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              Text(
                awayValue.toString(),
                style: TextStyle(
                  color: (isHighlightAway ?? false)
                      ? Color(0xFFC6FF00)
                      : Colors.white,
                  fontSize: ResponsiveHelper.sp(16),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveHelper.h(8)),
          _buildStatBar(homeValue, awayValue),
        ],
      ),
    );
  }

  Widget _buildStatBar(dynamic hVal, dynamic aVal) {
    final double h = double.tryParse(hVal.toString()) ?? 0;
    final double a = double.tryParse(aVal.toString()) ?? 0;
    final double total = (h + a) == 0 ? 1 : (h + a);

    int homeFlex = ((h / total) * 100).toInt();
    int awayFlex = ((a / total) * 100).toInt();

    if (homeFlex == 0 && awayFlex == 0) {
      homeFlex = 1;
      awayFlex = 1;
    } else if (homeFlex == 0) {
      homeFlex = 1;
    } else if (awayFlex == 0) {
      awayFlex = 1;
    }

    return Container(
      height: ResponsiveHelper.h(4),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(2)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: homeFlex,
            child: Container(
              decoration: BoxDecoration(
                color: (isHighlightHome ?? false)
                    ? Color(0xFFC6FF00)
                    : Colors.white.withValues(alpha: 0.5),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(ResponsiveHelper.w(2)),
                  bottomLeft: Radius.circular(ResponsiveHelper.w(2)),
                ),
              ),
            ),
          ),
          Expanded(
            flex: awayFlex,
            child: Container(
              decoration: BoxDecoration(
                color: (isHighlightAway ?? false)
                    ? Color(0xFFC6FF00)
                    : Colors.grey.shade700,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(ResponsiveHelper.w(2)),
                  bottomRight: Radius.circular(ResponsiveHelper.w(2)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
