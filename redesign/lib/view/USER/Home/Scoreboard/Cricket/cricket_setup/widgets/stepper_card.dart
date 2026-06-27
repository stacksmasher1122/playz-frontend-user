import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../cricket_setup_screen.dart';
import 'circle_button.dart';

class StepperCard extends StatelessWidget {
  final String title;
  final String mainText;
  final RxInt valueStream;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;
  final Color? titleColor;

  const StepperCard({
    super.key,
    required this.title,
    required this.mainText,
    required this.valueStream,
    required this.onDecrement,
    required this.onIncrement,
    this.titleColor,
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: titleColor ?? kMutedText,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  mainText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF131313),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              children: [
                CircleButton(
                  icon: Icons.remove,
                  color: const Color(0xFF2C2C2C),
                  iconColor: kGreen,
                  onTap: onDecrement,
                ),
                const SizedBox(width: 16),
                Obx(
                  () => Text(
                    valueStream.value.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                CircleButton(
                  icon: Icons.add,
                  color: kGreen,
                  iconColor: Colors.black,
                  onTap: onIncrement,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
