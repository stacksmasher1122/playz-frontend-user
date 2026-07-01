import 'package:flutter/material.dart';

class HalvesSelectorWidget extends StatelessWidget {
  final int halves;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;

  const HalvesSelectorWidget({
    super.key,
    required this.halves,
    required this.onIncrease,
    required this.onDecrease,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Number of Halves',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Standard is 2',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 10,
              ),
            ),
          ],
        ),
        Row(
          children: [
            _buildCircularBtn(Icons.remove, onDecrease),
            const SizedBox(width: 16),
            Text(
              halves.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 16),
            _buildCircularBtn(Icons.add, onIncrease),
          ],
        ),
      ],
    );
  }

  Widget _buildCircularBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black.withValues(alpha: 0.5),
          border: Border.all(color: const Color(0xFFC6FF00)), // Lime Green
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 16,
        ),
      ),
    );
  }
}
