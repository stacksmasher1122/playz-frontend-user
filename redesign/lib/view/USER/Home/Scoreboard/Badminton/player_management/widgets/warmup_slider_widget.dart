import 'package:flutter/material.dart';

class WarmupSliderWidget extends StatelessWidget {
  final int warmupDuration;
  final ValueChanged<double> onChanged;

  const WarmupSliderWidget({
    super.key,
    required this.warmupDuration,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade900.withValues(alpha: 0.8), // dark glass card
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade800, width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Warmup Duration',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
              Text(
                '${warmupDuration}m',
                style: const TextStyle(
                  color: Color(0xFFC6FF00), // Neon Yellow-Green
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Text(
                '0',
                style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: SliderTheme(
                  data: SliderThemeData(
                    activeTrackColor: const Color(0xFFC6FF00),
                    inactiveTrackColor: Colors.grey.shade800,
                    thumbColor: const Color(0xFFC6FF00),
                    trackHeight: 4.0,
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10.0),
                    overlayColor: const Color(0xFFC6FF00).withValues(alpha: 0.2),
                  ),
                  child: Slider(
                    value: warmupDuration.toDouble(),
                    min: 0,
                    max: 10,
                    divisions: 10,
                    onChanged: onChanged,
                  ),
                ),
              ),
              const Text(
                '10',
                style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
