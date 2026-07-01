import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class MvpAnalysisCard extends StatefulWidget {
  MvpAnalysisCard({super.key});

  @override
  State<MvpAnalysisCard> createState() => _MvpAnalysisCardState();
}

class _MvpAnalysisCardState extends State<MvpAnalysisCard> with SingleTickerProviderStateMixin {
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(vsync: this, duration: Duration(milliseconds: 600));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return ScaleTransition(
      scale: Tween<double>(begin: 0.9, end: 1.0).animate(CurvedAnimation(
        parent: _animController,
        curve: Curves.elasticOut,
      )),
      child: FadeTransition(
        opacity: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
          parent: _animController,
          curve: Curves.easeIn,
        )),
        child: Container(
          padding: EdgeInsets.all(ResponsiveHelper.w(24)),
          decoration: BoxDecoration(
            color: AppColors.primaryContainer,
            borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'MVP ANALYSIS',
                    style: AppTypography.labelCaps10.copyWith(color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  Icon(Icons.emoji_events, color: Colors.black, size: 20),
                ],
              ),
              SizedBox(height: 16),
              Text(
                'J. Smith dominated the kitchen with 12 winners.',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: ResponsiveHelper.sp(20),
                  fontWeight: FontWeight.w900,
                  fontStyle: FontStyle.italic,
                  color: Colors.black,
                  height: ResponsiveHelper.h(1.2),
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStat('Serve%', '91%'),
                  _buildStat('Winners', '14'),
                  _buildStat('Reaction', '0.31s'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTypography.labelCaps10.copyWith(color: Colors.black54)),
        Text(value, style: AppTypography.bodyMd.copyWith(color: Colors.black, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
