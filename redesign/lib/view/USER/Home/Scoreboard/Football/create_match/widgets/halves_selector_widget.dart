import 'package:redesign/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:redesign/theme/responsive_helper.dart';

class HalvesSelectorWidget extends StatelessWidget {
  final int halves;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;

  HalvesSelectorWidget({
    super.key,
    required this.halves,
    required this.onIncrease,
    required this.onDecrease,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Number of Halves',
              style: TextStyle(
                color: Colors.white,
                fontSize: ResponsiveHelper.sp(14),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Standard is 2',
              style: TextStyle(
                color: Colors.grey,
                fontSize: ResponsiveHelper.sp(10),
              ),
            ),
          ],
        ),
        Row(
          children: [
            _buildCircularBtn(Icons.remove, onDecrease),
            SizedBox(width: 16),
            Text(
              halves.toString(),
              style: TextStyle(
                color: Colors.white,
                fontSize: ResponsiveHelper.sp(16),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 16),
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
        padding: EdgeInsets.all(ResponsiveHelper.w(4)),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xFF121212),
          border: Border.all(color: AppColors.accent), // Lime Green
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
