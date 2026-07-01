import 'package:flutter/material.dart';
import '../../../../../../../../model/User_Models/Home_Models/Scoreboard_Model/Badminton/match_achievement_model.dart';
import 'package:redesign/theme/responsive_helper.dart';

class AchievementCard extends StatefulWidget {
  final MatchAchievementModel achievement;
  final int index;

  AchievementCard({
    super.key,
    required this.achievement,
    required this.index,
  });

  @override
  State<AchievementCard> createState() => _AchievementCardState();
}

class _AchievementCardState extends State<AchievementCard> with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _opacity;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );
    
    // Staggered delay based on index
    Future.delayed(Duration(milliseconds: 100 * widget.index), () {
      if (mounted) {
        _animController.forward();
      }
    });

    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    );
    _slide = Tween<Offset>(begin: Offset(0.05, 0), end: Offset.zero).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(
        position: _slide,
        child: Container(
          margin: EdgeInsets.only(bottom: 12.0),
          padding: EdgeInsets.all(ResponsiveHelper.w(16)),
          decoration: BoxDecoration(
            color: Colors.grey.shade900.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
            border: Border.all(color: Colors.grey.shade800),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(ResponsiveHelper.w(12)),
                decoration: BoxDecoration(
                  color: widget.achievement.badgeColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  widget.achievement.icon,
                  color: widget.achievement.badgeColor,
                  size: 20,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.achievement.title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: ResponsiveHelper.sp(14),
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      widget.achievement.subtitle,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: ResponsiveHelper.sp(12),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
