import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class MomentumChartWidget extends StatefulWidget {
  final List<double> momentumData;
  final String selectedGame;

  MomentumChartWidget({
    super.key,
    required this.momentumData,
    required this.selectedGame,
  });

  @override
  State<MomentumChartWidget> createState() => _MomentumChartWidgetState();
}

class _MomentumChartWidgetState extends State<MomentumChartWidget> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _animation = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _animController.forward();
  }

  @override
  void didUpdateWidget(covariant MomentumChartWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedGame != widget.selectedGame) {
      _animController.reset();
      _animController.forward();
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return RepaintBoundary(
      child: Container(
        height: ResponsiveHelper.h(160),
        decoration: BoxDecoration(
          color: AppColors.background.withOpacity(0.5),
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
        ),
        padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16), vertical: ResponsiveHelper.h(16)),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Text('ALPHA MOMENTUM', style: AppTypography.labelCaps10.copyWith(color: AppColors.accent.withOpacity(0.5))),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Text('OMEGA MOMENTUM', style: AppTypography.labelCaps10.copyWith(color: AppColors.error.withOpacity(0.5))),
            ),
            Center(
              child: Container(
                height: ResponsiveHelper.h(1),
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: AppColors.outlineVariant,
                      width: ResponsiveHelper.w(1),
                      style: BorderStyle.solid,
                    ),
                  ),
                ),
                child: CustomPaint(painter: DashedLinePainter()),
              ),
            ),
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: widget.momentumData.map((val) {
                    bool isPositive = val >= 0;
                    double height = (val.abs() * 50) * _animation.value;
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (isPositive) _buildBar(height, AppColors.accent),
                        if (!isPositive) SizedBox(height: 0),
                        SizedBox(height: 2), // spacing from center line
                        if (!isPositive) _buildBar(height, Colors.redAccent),
                        if (isPositive) SizedBox(height: 0),
                      ],
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBar(double height, Color color) {
    return Container(
      width: ResponsiveHelper.w(6),
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(3)),
      ),
    );
  }
}

class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double dashWidth = 5, dashSpace = 5, startX = 0;
    final paint = Paint()
      ..color = AppColors.muted.withOpacity(0.3)
      ..strokeWidth = 1;
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
