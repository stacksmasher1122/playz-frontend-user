import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/Pickleball/match_result_controller.dart';
import 'series_score_widget.dart';
import 'package:redesign/theme/responsive_helper.dart';

class WinnerCard extends StatefulWidget {
  final MatchResultController controller;

  WinnerCard({super.key, required this.controller});

  @override
  State<WinnerCard> createState() => _WinnerCardState();
}

class _WinnerCardState extends State<WinnerCard> with SingleTickerProviderStateMixin {
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
    return RepaintBoundary(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16), vertical: ResponsiveHelper.h(4)),
            decoration: BoxDecoration(
              color: AppColors.accent,
              borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
            ),
            child: Text(
              'WINNER',
              style: AppTypography.labelCaps10.copyWith(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ScaleTransition(
                scale: Tween<double>(begin: 0.8, end: 1.0).animate(CurvedAnimation(
                  parent: _animController,
                  curve: Curves.easeOutBack,
                )),
                child: _buildAvatar(isWinner: true),
              ),
              SizedBox(width: 24),
              Text('VS', style: AppTypography.labelCaps10.copyWith(color: AppColors.muted)),
              SizedBox(width: 24),
              FadeTransition(
                opacity: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                  parent: _animController,
                  curve: Interval(0.3, 1.0, curve: Curves.easeIn),
                )),
                child: _buildAvatar(isWinner: false),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.controller.winnerName.value,
                style: AppTypography.headlineMd.copyWith(color: AppColors.accent, fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 16),
              Text('vs', style: AppTypography.labelCaps10.copyWith(color: AppColors.muted)),
              SizedBox(width: 16),
              Text(
                widget.controller.runnerUp.value,
                style: AppTypography.headlineMd.copyWith(color: AppColors.muted, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 24),
          SeriesScoreWidget(
            winnerGames: widget.controller.winnerGames.value,
            runnerGames: widget.controller.runnerGames.value,
            matchStatus: widget.controller.matchStatus.value,
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar({required bool isWinner}) {
    return Stack(
      children: [
        Container(
          width: ResponsiveHelper.w(80),
          height: ResponsiveHelper.h(80),
          decoration: BoxDecoration(
            color: AppColors.outlineVariant,
            borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
          ),
          child: Center(
            child: Icon(Icons.group, color: AppColors.muted, size: 40),
          ),
        ),
        if (isWinner)
          Positioned(
            bottom: -4,
            right: -4,
            child: Container(
              width: ResponsiveHelper.w(24),
              height: ResponsiveHelper.h(24),
              decoration: BoxDecoration(
                color: AppColors.accent,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.check, color: Colors.black, size: 16),
            ),
          ),
      ],
    );
  }
}
