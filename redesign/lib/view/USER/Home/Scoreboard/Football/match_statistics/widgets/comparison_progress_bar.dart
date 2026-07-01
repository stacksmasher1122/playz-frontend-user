import 'package:flutter/material.dart';
import '../../../../../../../theme/responsive_helper.dart';

class ComparisonProgressBar extends StatelessWidget {
  final double homePercentage;
  final double awayPercentage;

  ComparisonProgressBar({
    super.key,
    required this.homePercentage,
    required this.awayPercentage,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    final total = homePercentage + awayPercentage;
    final homeFlex = total == 0 ? 50 : (homePercentage / total * 100).round();
    final awayFlex = total == 0 ? 50 : (awayPercentage / total * 100).round();

    return Container(
      height: ResponsiveHelper.h(8),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(4)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: homeFlex,
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFFC6FF00),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(ResponsiveHelper.w(4)),
                  bottomLeft: Radius.circular(ResponsiveHelper.w(4)),
                ),
              ),
            ),
          ),
          Expanded(
            flex: awayFlex,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade800,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(ResponsiveHelper.w(4)),
                  bottomRight: Radius.circular(ResponsiveHelper.w(4)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
