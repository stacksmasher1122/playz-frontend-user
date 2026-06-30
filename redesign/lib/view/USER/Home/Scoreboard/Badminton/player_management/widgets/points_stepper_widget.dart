import 'package:flutter/material.dart';

class PointsStepperWidget extends StatelessWidget {
  final int points;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const PointsStepperWidget({
    super.key,
    required this.points,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade900.withValues(alpha: 0.8), // dark glass card
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade800, width: 1.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Points to Win (per Game)',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
          Row(
            children: [
              _buildStepperButton(Icons.remove, onDecrement),
              const SizedBox(width: 16),
              SizedBox(
                width: 32,
                child: Center(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    transitionBuilder: (Widget child, Animation<double> animation) {
                      return ScaleTransition(scale: animation, child: child);
                    },
                    child: Text(
                      '$points',
                      key: ValueKey<int>(points),
                      style: const TextStyle(
                        color: Color(0xFFC6FF00), // Neon Yellow-Green
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              _buildStepperButton(Icons.add, onIncrement),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStepperButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.grey.shade800,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}
