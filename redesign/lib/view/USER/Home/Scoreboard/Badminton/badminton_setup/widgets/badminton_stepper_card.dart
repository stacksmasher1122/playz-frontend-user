import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Cricket/cricket_setup/widgets/circle_button.dart';

class BadmintonStepperCard extends StatelessWidget {
  final String title;
  final String mainText;
  final RxInt valueStream;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;
  final Color? titleColor;

  BadmintonStepperCard({
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
    final effectiveTitleColor = titleColor ?? AppColors.muted;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(20)),
      ),
      padding: EdgeInsets.all(ResponsiveHelper.w(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: effectiveTitleColor,
              fontSize: ResponsiveHelper.sp(12),
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                mainText,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: ResponsiveHelper.sp(20),
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                ),
              ),
              Row(
                children: [
                  CircleButton(
                    icon: Icons.remove,
                    color: AppColors.card,
                    iconColor: Colors.white,
                    onTap: onDecrement,
                  ),
                  SizedBox(width: 16),
                  Container(
                    width: ResponsiveHelper.w(48),
                    alignment: Alignment.center,
                    child: Obx(
                      () => Text(
                        '${valueStream.value}',
                        style: TextStyle(
                          color: AppColors.accent,
                          fontSize: ResponsiveHelper.sp(28),
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  CircleButton(
                    icon: Icons.add,
                    color: AppColors.accent,
                    iconColor: Colors.black,
                    onTap: onIncrement,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
