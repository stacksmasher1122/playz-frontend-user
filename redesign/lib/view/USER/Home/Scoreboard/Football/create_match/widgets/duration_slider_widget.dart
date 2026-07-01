import 'package:flutter/material.dart';

class DurationSliderWidget extends StatelessWidget {
  final double duration;
  final ValueChanged<double> onChanged;

  const DurationSliderWidget({
    super.key,
    required this.duration,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'TOTAL DURATION',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${duration.toInt()} MINS',
              style: const TextStyle(
                color: Color(0xFFC6FF00), // Lime Green
                fontSize: 14,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        RepaintBoundary(
          child: SliderTheme(
            data: SliderThemeData(
              activeTrackColor: const Color(0xFFC6FF00),
              inactiveTrackColor: Colors.grey.shade800,
              thumbColor: const Color(0xFFC6FF00),
              trackHeight: 2.0,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8.0),
              overlayColor: const Color(0xFFC6FF00).withValues(alpha: 0.2),
            ),
            child: Slider(
              value: duration,
              min: 10,
              max: 120,
              divisions: 11, // 10 to 120 with steps of 10
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
