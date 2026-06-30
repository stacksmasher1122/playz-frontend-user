import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../../controller/User_Controller/Home_Controller/Scoreboard_Controller/Badminton/live_match_controller.dart';
import 'service_indicator_widget.dart';

class CourtVisualizationWidget extends StatelessWidget {
  const CourtVisualizationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LiveMatchController>();

    return RepaintBoundary(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Obx(() {
          final isLeftActive = controller.serviceSide.value == "LEFT COURT";
          
          return Stack(
            alignment: Alignment.bottomCenter,
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 180,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
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
                      width: 2,
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
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade900,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade800),
                  ),
                  child: Text(
                    'SERVICE: ${controller.serviceSide.value}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
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

  const _CourtHalf({
    required this.isActive,
    required this.isLeft,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: isActive 
            ? const Color(0xFFC6FF00).withValues(alpha: 0.15) // Neon Yellow-Green tint
            : Colors.transparent,
        borderRadius: BorderRadius.horizontal(
          left: isLeft ? const Radius.circular(15) : Radius.zero,
          right: !isLeft ? const Radius.circular(15) : Radius.zero,
        ),
        border: isActive
            ? Border.all(color: const Color(0xFFC6FF00).withValues(alpha: 0.5), width: 1.5)
            : null,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Inner Court Markings Mock
          Container(
            margin: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(
                color: isActive 
                    ? const Color(0xFFC6FF00).withValues(alpha: 0.2) 
                    : Colors.grey.shade800,
                width: 1,
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
