import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_dimensions.dart';
import 'package:redesign/theme/app_typography.dart';
import '../../../../../../controller/User_Controller/Home_Controller/Scoreboard_Controller/Basketball/basketball_controller.dart';
import '../basketball_scoreboard/basketball_scoreboard_screen.dart';
import 'dart:math';

class TipOffScreen extends StatefulWidget {
  const TipOffScreen({super.key});

  @override
  State<TipOffScreen> createState() => _TipOffScreenState();
}

class _TipOffScreenState extends State<TipOffScreen> with SingleTickerProviderStateMixin {
  final BasketballController controller = Get.find<BasketballController>();
  late AnimationController _animController;
  late Animation<double> _animation;

  bool _isFlipping = false;
  bool _hasFlipped = false;
  String? _winnerTeamId;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: pi * 6).animate(CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    ));
    _animController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _isFlipping = false;
          _hasFlipped = true;
          // Randomly decide winner if not mocked. For visual sake, 50/50.
          _winnerTeamId = Random().nextBool() ? 'home' : 'away';
        });
      }
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _startTipOff() {
    setState(() {
      _isFlipping = true;
      _hasFlipped = false;
    });
    _animController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text('Jump Ball', style: AppTypography.headlineLg.copyWith(color: Colors.white)),
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Who wins the opening tip?', style: AppTypography.headlineLgMobile),
            const SizedBox(height: AppDimensions.paddingXl),

            // Re-using the coin flip animation pattern relabeled for tip-off
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Transform(
                  alignment: FractionalOffset.center,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001) // perspective
                    ..rotateX(_animation.value),
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.surface,
                      border: Border.all(color: AppColors.accent, width: 4),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      _isFlipping ? '...' : (_hasFlipped ? (_winnerTeamId == 'home' ? 'Home' : 'Away') : 'Toss'),
                      style: AppTypography.headlineLg,
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: AppDimensions.paddingXl),

            if (!_isFlipping && !_hasFlipped)
              ElevatedButton(
                onPressed: _startTipOff,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: Text('Toss Ball', style: AppTypography.labelCaps.copyWith(color: AppColors.background)),
              ),

            if (_hasFlipped)
              Column(
                children: [
                  Text(
                    '${_winnerTeamId == 'home' ? controller.homeTeamName.value : controller.awayTeamName.value} wins the tip!',
                    style: AppTypography.headlineMd.copyWith(color: AppColors.accent),
                  ),
                  const SizedBox(height: AppDimensions.paddingMd),
                  Text('Possession arrow set to the opposing team.', style: AppTypography.bodySm.copyWith(color: Colors.grey)),
                  const SizedBox(height: AppDimensions.paddingXl),
                  ElevatedButton(
                    onPressed: () async {
                       // The team that loses the tip gets the possession arrow
                       String arrowTeam = _winnerTeamId == 'home' ? 'away' : 'home';
                       await controller.resolveTipOff(_winnerTeamId!, arrowTeam);
                       Get.off(() => const BasketballScoreboardScreen());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    child: Text('Start Match', style: AppTypography.labelCaps.copyWith(color: AppColors.background)),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
