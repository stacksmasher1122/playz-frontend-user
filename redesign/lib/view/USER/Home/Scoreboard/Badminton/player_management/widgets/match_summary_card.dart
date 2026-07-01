import 'package:flutter/material.dart';
import '../../../../../../../model/User_Models/Home_Models/Scoreboard_Model/Badminton/player_model.dart';
import 'player_avatar_widget.dart';
import 'versus_widget.dart';
import 'package:redesign/theme/responsive_helper.dart';

class MatchSummaryCard extends StatefulWidget {
  final PlayerModel? playerOne;
  final PlayerModel? playerTwo;
  final int totalGames;

  MatchSummaryCard({
    super.key,
    required this.playerOne,
    required this.playerTwo,
    required this.totalGames,
  });

  @override
  State<MatchSummaryCard> createState() => _MatchSummaryCardState();
}

class _MatchSummaryCardState extends State<MatchSummaryCard> with SingleTickerProviderStateMixin {
  late final AnimationController _entranceController;

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    );
    
    // Animate on load
    Future.delayed(Duration(milliseconds: 100), () {
      if (mounted) _entranceController.forward();
    });
  }

  @override
  void dispose() {
    _entranceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return RepaintBoundary(
      child: FadeTransition(
        opacity: CurvedAnimation(
          parent: _entranceController,
          curve: Curves.easeOut,
        ),
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.95, end: 1.0).animate(
            CurvedAnimation(
              parent: _entranceController,
              curve: Curves.easeOutBack,
            ),
          ),
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(24), vertical: ResponsiveHelper.h(16)),
            padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(32), horizontal: ResponsiveHelper.w(16)),
            decoration: BoxDecoration(
              color: Colors.grey.shade900.withValues(alpha: 0.8), // dark glass card
              borderRadius: BorderRadius.circular(ResponsiveHelper.w(24)),
              border: Border.all(color: Colors.grey.shade800, width: 1.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.5),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PlayerAvatarWidget(
                  player: widget.playerOne,
                  isHighlighted: true, // player one gets green border
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: VersusWidget(
                    gamesLabel: 'BEST OF ${widget.totalGames}',
                  ),
                ),
                PlayerAvatarWidget(
                  player: widget.playerTwo,
                  isHighlighted: false,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
