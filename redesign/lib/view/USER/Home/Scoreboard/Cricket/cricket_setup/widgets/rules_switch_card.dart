import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../cricket_setup_screen.dart';

class RulesSwitchCard extends StatelessWidget {
  final RxBool valueStream;
  final Function(bool) onChanged;

  const RulesSwitchCard({
    super.key,
    required this.valueStream,
    required this.onChanged,
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
              color: const Color(0xFF3B2828), // Slight red tint for rules
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.gavel_rounded,
              color: kRed,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Formal ICC Rules',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Disable to allow single\nbatter (Last Man Standing)',
                  style: TextStyle(
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
              activeColor: Colors.white,
              activeTrackColor: kRed,
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
