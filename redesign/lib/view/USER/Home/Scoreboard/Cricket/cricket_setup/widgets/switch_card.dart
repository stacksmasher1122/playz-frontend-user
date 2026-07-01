import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../cricket_setup_screen.dart';

class SwitchCard extends StatelessWidget {
  final RxBool valueStream;
  final Function(bool) onChanged;
  final String title;
  final String subtitle;
  final IconData icon;

  const SwitchCard({
    super.key,
    required this.valueStream,
    required this.onChanged,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kSurface,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF28362B),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              color: kGreen,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: kMutedText,
                    fontSize: 13,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
          Obx(
            () => Switch(
              value: valueStream.value,
              onChanged: onChanged,
              activeThumbColor: Colors.white,
              activeTrackColor: kGreen,
              inactiveThumbColor: kMutedText,
              inactiveTrackColor: const Color(0xFF2C2C2C),
              thumbColor: WidgetStateProperty.resolveWith<Color>((
                Set<WidgetState> states,
              ) {
                if (states.contains(WidgetState.selected)) {
                  return Colors.black;
                }
                return kMutedText;
              }),
            ),
          ),
        ],
      ),
    );
  }
}
