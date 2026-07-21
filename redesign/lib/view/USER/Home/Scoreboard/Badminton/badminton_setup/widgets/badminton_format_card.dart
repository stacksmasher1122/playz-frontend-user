import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/badminton_controller.dart';

class BadmintonFormatCard extends StatelessWidget {
  final BadmintonController controller;

  BadmintonFormatCard({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
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
            'MATCH FORMAT',
            style: TextStyle(
              color: AppColors.muted,
              fontSize: ResponsiveHelper.sp(12),
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Obx(() => _FormatButton(
                  title: 'Singles',
                  isSelected: controller.format.value == 'Singles',
                  onTap: () => controller.setFormat('Singles'),
                )),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Obx(() => _FormatButton(
                  title: 'Doubles',
                  isSelected: controller.format.value == 'Doubles',
                  onTap: () => controller.setFormat('Doubles'),
                )),
              ),
            ],
          ),
          SizedBox(height: 24),
          Text(
            'GAMES TO WIN (SERIES)',
            style: TextStyle(
              color: AppColors.muted,
              fontSize: ResponsiveHelper.sp(12),
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Obx(() => _FormatButton(
                  title: 'Best of 1',
                  isSelected: controller.gamesToWin.value == 1,
                  onTap: () => controller.gamesToWin.value = 1,
                )),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Obx(() => _FormatButton(
                  title: 'Best of 3',
                  isSelected: controller.gamesToWin.value == 2,
                  onTap: () => controller.gamesToWin.value = 2,
                )),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Obx(() => _FormatButton(
                  title: 'Best of 5',
                  isSelected: controller.gamesToWin.value == 3,
                  onTap: () => controller.gamesToWin.value = 3,
                )),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FormatButton extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _FormatButton({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(12)),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.accent : Colors.white10,
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
          border: Border.all(
            color: isSelected ? AppColors.accent : Colors.transparent,
            width: 1,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.white,
            fontSize: ResponsiveHelper.sp(14),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
