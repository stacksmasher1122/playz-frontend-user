import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../controller/User_Controller/Home_Controller/Scoreboard_Controller/Football/football_match_statistics_controller.dart';
import 'comparison_progress_bar.dart';

class TeamComparisonCard extends StatelessWidget {
  const TeamComparisonCard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FootballMatchStatisticsController>();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade900.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20),
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
                const Icon(
                  Icons.show_chart,
                  color: Color(0xFFC6FF00),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'TEAM COMPARISON',
                  style: TextStyle(
                    color: const Color(0xFFC6FF00).withValues(alpha: 0.8),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${home.possession.toInt()}%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'POSSESSION',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                Text(
                  '${away.possession.toInt()}%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ComparisonProgressBar(
              homePercentage: home.possession.toDouble(),
              awayPercentage: away.possession.toDouble(),
            ),
            const SizedBox(height: 24),
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
  const StatisticsRowWidget({
    super.key,
    required this.title,
    required this.homeValue,
    required this.awayValue,
    this.isHighlightHome,
    this.isHighlightAway,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                homeValue.toString(),
                style: TextStyle(
                  color: (isHighlightHome ?? false)
                      ? const Color(0xFFC6FF00)
                      : Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                title.toUpperCase(),
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              Text(
                awayValue.toString(),
                style: TextStyle(
                  color: (isHighlightAway ?? false)
                      ? const Color(0xFFC6FF00)
                      : Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
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
      homeFlex = 1; // Minimum flex to avoid crash
    } else if (awayFlex == 0) {
      awayFlex = 1;
    }

    return Container(
      height: 4,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(2),
      ),
      child: Row(
        children: [
          Expanded(
            flex: homeFlex,
            child: Container(
              decoration: BoxDecoration(
                color: (isHighlightHome ?? false)
                    ? const Color(0xFFC6FF00)
                    : Colors.white.withValues(alpha: 0.5),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(2),
                  bottomLeft: Radius.circular(2),
                ),
              ),
            ),
          ),
          Expanded(
            flex: awayFlex,
            child: Container(
              decoration: BoxDecoration(
                color: (isHighlightAway ?? false)
                    ? const Color(0xFFC6FF00)
                    : Colors.grey.shade700,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(2),
                  bottomRight: Radius.circular(2),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
