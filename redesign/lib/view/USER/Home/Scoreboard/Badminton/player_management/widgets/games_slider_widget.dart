import 'package:flutter/material.dart';
import 'package:redesign/theme/responsive_helper.dart';

class GamesSliderWidget extends StatelessWidget {
  final int totalGames;
  final ValueChanged<double> onChanged;

  GamesSliderWidget({
    super.key,
    required this.totalGames,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(24), vertical: ResponsiveHelper.h(12)),
      padding: EdgeInsets.all(ResponsiveHelper.w(20)),
      decoration: BoxDecoration(
        color: Colors.grey.shade900.withValues(alpha: 0.8), // dark glass card
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
        border: Border.all(color: Colors.grey.shade800, width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Number of Games',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: ResponsiveHelper.sp(14),
                ),
              ),
              Text(
                '$totalGames',
                style: TextStyle(
                  color: Color(0xFFC6FF00), // Neon Yellow-Green
                  fontSize: ResponsiveHelper.sp(20),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Text(
                '1',
                style: TextStyle(color: Colors.grey, fontSize: ResponsiveHelper.sp(12), fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: SliderTheme(
                  data: SliderThemeData(
                    activeTrackColor: Color(0xFFC6FF00),
                    inactiveTrackColor: Colors.grey.shade800,
                    thumbColor: Color(0xFFC6FF00),
                    trackHeight: 4.0,
                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10.0),
                    overlayColor: Color(0xFFC6FF00).withValues(alpha: 0.2),
                  ),
                  child: Slider(
                    value: totalGames.toDouble(),
                    min: 1,
                    max: 5,
                    divisions: 4,
                    onChanged: onChanged,
                  ),
                ),
              ),
              Text(
                '5',
                style: TextStyle(color: Colors.grey, fontSize: ResponsiveHelper.sp(12), fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
