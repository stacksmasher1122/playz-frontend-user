import 'package:flutter/material.dart';
import 'package:redesign/theme/responsive_helper.dart';

class PointsStepperWidget extends StatelessWidget {
  final int points;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  PointsStepperWidget({
    super.key,
    required this.points,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(24), vertical: ResponsiveHelper.h(12)),
      padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(20), vertical: ResponsiveHelper.h(16)),
      decoration: BoxDecoration(
        color: Colors.grey.shade900.withValues(alpha: 0.8), // dark glass card
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
        border: Border.all(color: Colors.grey.shade800, width: 1.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Points to Win (per Game)',
            style: TextStyle(
              color: Colors.white,
              fontSize: ResponsiveHelper.sp(14),
            ),
          ),
          Row(
            children: [
              _buildStepperButton(Icons.remove, onDecrement),
              SizedBox(width: 16),
              SizedBox(
                width: ResponsiveHelper.w(32),
                child: Center(
                  child: AnimatedSwitcher(
                    duration: Duration(milliseconds: 200),
                    transitionBuilder: (Widget child, Animation<double> animation) {
                      return ScaleTransition(scale: animation, child: child);
                    },
                    child: Text(
                      '$points',
                      key: ValueKey<int>(points),
                      style: TextStyle(
                        color: Color(0xFFC6FF00), // Neon Yellow-Green
                        fontSize: ResponsiveHelper.sp(20),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16),
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
        width: ResponsiveHelper.w(36),
        height: ResponsiveHelper.h(36),
        decoration: BoxDecoration(
          color: Colors.grey.shade800,
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(8)),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}
