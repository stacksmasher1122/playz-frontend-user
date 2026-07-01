import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../cricket_setup_screen.dart';
import 'circle_button.dart';
import 'package:redesign/theme/responsive_helper.dart';

class StepperCard extends StatelessWidget {
  final String title;
  final String mainText;
  final RxInt valueStream;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;
  final Color? titleColor;

  StepperCard({
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
    ResponsiveHelper.init(context);
    return Container(
      decoration: BoxDecoration(
        color: kSurface,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(20)),
      ),
      padding: EdgeInsets.all(ResponsiveHelper.w(20)),
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
                    fontSize: ResponsiveHelper.sp(11),
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  mainText,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: ResponsiveHelper.sp(18),
                    fontWeight: FontWeight.w600,
                    height: ResponsiveHelper.h(1.2),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8),
          Container(
            padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(6), vertical: ResponsiveHelper.h(6)),
            decoration: BoxDecoration(
              color: Color(0xFF131313),
              borderRadius: BorderRadius.circular(ResponsiveHelper.w(30)),
            ),
            child: Row(
              children: [
                CircleButton(
                  icon: Icons.remove,
                  color: Color(0xFF2C2C2C),
                  iconColor: kGreen,
                  onTap: onDecrement,
                ),
                SizedBox(width: 16),
                Obx(
                  () => Text(
                    valueStream.value.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: ResponsiveHelper.sp(20),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(width: 16),
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
