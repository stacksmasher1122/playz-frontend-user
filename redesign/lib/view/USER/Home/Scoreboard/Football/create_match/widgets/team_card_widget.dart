import 'package:redesign/theme/app_colors.dart';
import 'package:flutter/material.dart';
import '../../../../../../../../model/User_Models/Home_Models/Scoreboard_Model/Football/team_model.dart';
import 'package:redesign/theme/responsive_helper.dart';

class DashedCirclePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashWidth;
  final double dashSpace;

  DashedCirclePainter({
    required this.color,
    required this.strokeWidth,
    required this.dashWidth,
    required this.dashSpace,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    var circumference = size.width * 3.14159;
    var dashCount = (circumference / (dashWidth + dashSpace)).floor();
    var adjustedDashSpace = (circumference - (dashCount * dashWidth)) / dashCount;

    var angle = 0.0;
    for (int i = 0; i < dashCount; i++) {
      canvas.drawArc(
        Rect.fromLTWH(0, 0, size.width, size.height),
        angle,
        (dashWidth / circumference) * 2 * 3.14159,
        false,
        paint,
      );
      angle += ((dashWidth + adjustedDashSpace) / circumference) * 2 * 3.14159;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class TeamCardWidget extends StatelessWidget {
  final bool isHome;
  final TeamModel? team;
  final ValueChanged<TeamModel> onSelect;
  final VoidCallback onUploadLogo;

  TeamCardWidget({
    super.key,
    required this.isHome,
    required this.team,
    required this.onSelect,
    required this.onUploadLogo,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(24), horizontal: ResponsiveHelper.w(16)),
      decoration: BoxDecoration(
        color: Color(0xFF121212),
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
        border: Border.all(color: Color(0xFF1E1E1E)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: onUploadLogo,
            child: SizedBox(
              width: ResponsiveHelper.w(70),
              height: ResponsiveHelper.h(70),
              child: CustomPaint(
                painter: DashedCirclePainter(
                  color: Colors.grey,
                  strokeWidth: 2,
                  dashWidth: 6,
                  dashSpace: 4,
                ),
                child: Center(
                  child: Icon(
                    Icons.camera_alt_outlined,
                    color: Colors.grey,
                    size: 28,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          DropdownButtonFormField<String>(
            initialValue: team?.teamName,
            hint: Text(
              isHome ? 'Select Team A' : 'Select Team B',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            dropdownColor: Color(0xFF121212),
            icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey),
            style: TextStyle(color: Colors.white, fontSize: 14),
            decoration: InputDecoration(
              filled: true,
              fillColor: Color(0xFF121212),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(ResponsiveHelper.w(8)),
                borderSide: BorderSide(color: Color(0xFF1E1E1E)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(ResponsiveHelper.w(8)),
                borderSide: BorderSide(color: Color(0xFF1E1E1E)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(ResponsiveHelper.w(8)),
                borderSide: BorderSide(color: AppColors.accent),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16), vertical: ResponsiveHelper.h(12)),
            ),
            items: ['Team Alpha', 'Team Beta', 'FC United', 'Real FC']
                .map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (val) {
              if (val != null) {
                onSelect(TeamModel(
                  teamId: DateTime.now().millisecondsSinceEpoch.toString(),
                  teamName: val,
                  isHome: isHome,
                ));
              }
            },
          ),
          SizedBox(height: 12),
          Text(
            isHome ? 'HOME SIDE' : 'AWAY SIDE',
            style: TextStyle(
              color: Colors.grey,
              fontSize: ResponsiveHelper.sp(10),
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}
