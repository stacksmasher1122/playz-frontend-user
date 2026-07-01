import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../../controller/User_Controller/Home_Controller/Scoreboard_Controller/Badminton/live_match_controller.dart';
import 'service_indicator_widget.dart';
import 'package:redesign/theme/responsive_helper.dart';

class CourtVisualizationWidget extends StatelessWidget {
  CourtVisualizationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final controller = Get.find<LiveMatchController>();

    return RepaintBoundary(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(24.0), vertical: ResponsiveHelper.h(16.0)),
        child: Obx(() {
          final isLeftActive = controller.serviceSide.value == "LEFT COURT";
          
          return Stack(
            alignment: Alignment.bottomCenter,
            clipBehavior: Clip.none,
            children: [
              Container(
                height: ResponsiveHelper.h(180),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
                  border: Border.all(color: Colors.grey.shade800),
                  color: Colors.black, // Dark court base
                ),
                child: Row(
                  children: [
                    // Left Court Half
                    Expanded(
                      child: _CourtHalf(
                        isActive: isLeftActive,
                        isLeft: true,
                      ),
                    ),
                    // Center Net Line
                    Container(
                      width: ResponsiveHelper.w(2),
                      color: Colors.grey.shade800,
                    ),
                    // Right Court Half
                    Expanded(
                      child: _CourtHalf(
                        isActive: !isLeftActive,
                        isLeft: false,
                      ),
                    ),
                  ],
                ),
              ),
              // Floating Service Tooltip
              Positioned(
                bottom: -16,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16), vertical: ResponsiveHelper.h(8)),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade900,
                    borderRadius: BorderRadius.circular(ResponsiveHelper.w(8)),
                    border: Border.all(color: Colors.grey.shade800),
                  ),
                  child: Text(
                    'SERVICE: ${controller.serviceSide.value}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: ResponsiveHelper.sp(10),
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

class _CourtHalf extends StatelessWidget {
  final bool isActive;
  final bool isLeft;

  _CourtHalf({
    required this.isActive,
    required this.isLeft,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: isActive 
            ? Color(0xFFC6FF00).withValues(alpha: 0.15) // Neon Yellow-Green tint
            : Colors.transparent,
        borderRadius: BorderRadius.horizontal(
          left: isLeft ? Radius.circular(ResponsiveHelper.w(15)) : Radius.zero,
          right: !isLeft ? Radius.circular(ResponsiveHelper.w(15)) : Radius.zero,
        ),
        border: isActive
            ? Border.all(color: Color(0xFFC6FF00).withValues(alpha: 0.5), width: 1.5)
            : null,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Inner Court Markings Mock
          Container(
            margin: EdgeInsets.all(ResponsiveHelper.w(12)),
            decoration: BoxDecoration(
              border: Border.all(
                color: isActive 
                    ? Color(0xFFC6FF00).withValues(alpha: 0.2) 
                    : Colors.grey.shade800,
                width: ResponsiveHelper.w(1),
              ),
            ),
          ),
          ServiceIndicatorWidget(
            isActive: isActive,
            isLeft: isLeft,
          ),
        ],
      ),
    );
  }
}
