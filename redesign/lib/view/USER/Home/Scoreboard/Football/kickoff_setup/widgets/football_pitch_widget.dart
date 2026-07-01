import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../controller/User_Controller/Home_Controller/Scoreboard_Controller/Football/kickoff_setup_controller.dart';
import 'team_side_widget.dart';
import 'kickoff_ball_widget.dart';
import 'package:redesign/theme/responsive_helper.dart';

class FootballKickoffPitchWidget extends StatelessWidget {
  FootballKickoffPitchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final controller = Get.find<KickoffSetupController>();

    return AspectRatio(
      aspectRatio: 2.0, // Wider aspect ratio for kickoff side selection
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black, // Dark background
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
          border: Border.all(color: Colors.grey.shade800),
        ),
        child: Stack(
          children: [
            // Pitch Markings (Custom Painter)
            RepaintBoundary(
              child: _PitchMarkingsWidget(),
            ),
            
            // Drop Zones & Team Cards
            Row(
              children: [
                Expanded(
                  child: DragTarget<String>(
                    onAcceptWithDetails: (details) {
                      controller.dropTeam(details.data, 'left');
                    },
                    builder: (context, candidateData, rejectedData) {
                      return Center(
                        child: Obx(() {
                          final team = controller.teamA.value.side == 'left'
                              ? controller.teamA.value
                              : controller.teamB.value;
                          return TeamSideWidget(
                            team: team,
                            onDrag: controller.dragTeam,
                          );
                        }),
                      );
                    },
                  ),
                ),
                Expanded(
                  child: DragTarget<String>(
                    onAcceptWithDetails: (details) {
                      controller.dropTeam(details.data, 'right');
                    },
                    builder: (context, candidateData, rejectedData) {
                      return Center(
                        child: Obx(() {
                          final team = controller.teamA.value.side == 'right'
                              ? controller.teamA.value
                              : controller.teamB.value;
                          return TeamSideWidget(
                            team: team,
                            onDrag: controller.dragTeam,
                          );
                        }),
                      );
                    },
                  ),
                ),
              ],
            ),

            // Animated Ball
            Obx(() {
              final alignment = Alignment(
                (controller.ballPosition.value * 2) - 1, // mapping 0..1 to -1..1
                0.5, // Slightly below center
              );
              return AnimatedAlign(
                duration: Duration(milliseconds: 400),
                curve: Curves.easeInOut,
                alignment: alignment,
                child: RepaintBoundary(
                  child: KickoffBallWidget(),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _PitchMarkingsWidget extends StatelessWidget {
  _PitchMarkingsWidget();

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return CustomPaint(
      painter: _KickoffPitchPainter(),
      child: Container(),
    );
  }
}

class _KickoffPitchPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.shade800
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // Grid pattern faint lines
    final gridPaint = Paint()
      ..color = Colors.grey.shade900
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    for (double i = 0; i < size.width; i += 40) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), gridPaint);
    }
    for (double i = 0; i < size.height; i += 40) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), gridPaint);
    }

    // Center divider line
    canvas.drawLine(
      Offset(size.width / 2, 0),
      Offset(size.width / 2, size.height),
      paint,
    );

    // Center circle
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.height * 0.3,
      paint,
    );
    
    // Dashed drop zone outlines (optional, simplified to solid for now or we could use path_drawing if available)
    // Left drop zone
    final dropZonePaint = Paint()
      ..color = Colors.grey.shade800
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
      
    final leftRect = Rect.fromCenter(
      center: Offset(size.width * 0.25, size.height * 0.5),
      width: ResponsiveHelper.w(70),
      height: ResponsiveHelper.h(80),
    );
    canvas.drawRRect(RRect.fromRectAndRadius(leftRect, Radius.circular(ResponsiveHelper.w(16))), dropZonePaint);

    final rightRect = Rect.fromCenter(
      center: Offset(size.width * 0.75, size.height * 0.5),
      width: ResponsiveHelper.w(70),
      height: ResponsiveHelper.h(80),
    );
    canvas.drawRRect(RRect.fromRectAndRadius(rightRect, Radius.circular(ResponsiveHelper.w(16))), dropZonePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
