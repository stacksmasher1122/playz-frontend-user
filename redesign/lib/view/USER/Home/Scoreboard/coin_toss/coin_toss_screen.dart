import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Cricket/cricket_scoreboard/cricket_scoreboard_screen.dart';
import 'package:vibration/vibration.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/cricket_controller.dart';

// Widgets
import 'widgets/coin_3d.dart';
import 'widgets/coin_shadow.dart';
import 'widgets/swipe_hint.dart';
import 'widgets/toss_impact_effects.dart';
import 'widgets/toss_result_display.dart';
import 'package:redesign/theme/responsive_helper.dart';

enum CoinState { idle, anticipating, tossing, landed }

class CoinFlipScreen extends StatefulWidget {
  CoinFlipScreen({super.key});

  @override
  State<CoinFlipScreen> createState() => _CoinFlipScreenState();
}

class _CoinFlipScreenState extends State<CoinFlipScreen>
    with TickerProviderStateMixin {
  late AnimationController controller;
  late AnimationController shakeController;
  late AnimationController idleController;
  late AnimationController resultController;
  late AnimationController haloController;
  late AnimationController flashController;
  late AnimationController wobbleController;

  late Animation<double> rotationAnimation;
  late Animation<double> heightAnimation;
  late Animation<double> shadowAnimation;
  late Animation<double> xOffsetAnimation;
  late Animation<double> scaleAnimation;
  late Animation<Offset> shakeAnimation;
  late Animation<double> zoomAnimation;
  late Animation<double> idleWobble;
  late Animation<double> resultOpacity;
  late Animation<Offset> resultSlide;
  late Animation<double> glowPulse;
  late Animation<double> haloRadius;
  late Animation<double> haloOpacity;
  late Animation<double> flashOpacity;
  late Animation<double> wobbleAngle;
  late Animation<double> rimLightProgress;

  final AudioPlayer audioPlayer = AudioPlayer();
  final AudioPlayer spinLoopPlayer = AudioPlayer();

  CoinState currentState = CoinState.idle;
  bool isHeads = true;
  double randomTilt = 0.0;
  double randomDriftScale = 1.0;
  int spinCount = 10;
  double verticalVelocityRatio = 1.0;

  // Toss Tracking
  late String callerTeamName;
  late String otherTeamName;
  String? callerPrediction;
  bool isTossCompleted = false;

  @override
  void initState() {
    super.initState();

    final cCtrl = Get.find<CricketController>();
    final random = Random();
    bool isHomeCalling = random.nextBool();
    if (isHomeCalling) {
      callerTeamName = cCtrl.homeTeamName.value;
      otherTeamName = cCtrl.awayTeamName.value;
    } else {
      callerTeamName = cCtrl.awayTeamName.value;
      otherTeamName = cCtrl.homeTeamName.value;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showCallTossBottomSheet();
    });

    controller = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    );

    shakeController = AnimationController(
      duration: Duration(milliseconds: 150),
      vsync: this,
    );

    idleController = AnimationController(
      duration: Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);

    resultController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );

    haloController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );

    flashController = AnimationController(
      duration: Duration(milliseconds: 80),
      vsync: this,
    );

    wobbleController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    idleWobble = Tween<double>(begin: -0.04, end: 0.04).animate(
      CurvedAnimation(parent: idleController, curve: Curves.easeInOutSine),
    );

    rimLightProgress = Tween<double>(begin: 0, end: 1).animate(controller);

    rotationAnimation = Tween<double>(begin: 0, end: pi * 10).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(0.08, 1.0, curve: Curves.easeOutExpo),
      ),
    );

    heightAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0,
          end: -20,
        ).chain(CurveTween(curve: Curves.easeOutQuad)),
        weight: 8,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: -20,
          end: -350,
        ).chain(CurveTween(curve: Curves.easeOutCubic)),
        weight: 42,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: -350,
          end: 0,
        ).chain(CurveTween(curve: Curves.bounceOut)),
        weight: 50,
      ),
    ]).animate(controller);

    xOffsetAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: ConstantTween<double>(0.0), weight: 10),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0,
          end: 15,
        ).chain(CurveTween(curve: Curves.easeInOutSine)),
        weight: 45,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 15,
          end: -8,
        ).chain(CurveTween(curve: Curves.easeInOutSine)),
        weight: 45,
      ),
    ]).animate(controller);

    zoomAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: ConstantTween<double>(1.0), weight: 10),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.0,
          end: 1.08,
        ).chain(CurveTween(curve: Curves.easeInOutQuad)),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.08,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeInOutQuad)),
        weight: 50,
      ),
    ]).animate(controller);

    scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: ConstantTween<double>(1.0), weight: 10),
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 0.9), weight: 30),
      TweenSequenceItem(tween: Tween<double>(begin: 0.9, end: 0.9), weight: 40),
      TweenSequenceItem(tween: Tween<double>(begin: 0.9, end: 1.0), weight: 20),
    ]).animate(controller);

    shadowAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: ConstantTween<double>(1.0), weight: 10),
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 0.3), weight: 40),
      TweenSequenceItem(tween: Tween<double>(begin: 0.3, end: 1.0), weight: 50),
    ]).animate(controller);

    shakeAnimation = TweenSequence<Offset>([
      TweenSequenceItem(
        tween: Tween<Offset>(begin: Offset.zero, end: Offset(3, 2)),
        weight: 25,
      ),
      TweenSequenceItem(
        tween: Tween<Offset>(
          begin: Offset(3, 2),
          end: Offset(-3, -2),
        ),
        weight: 25,
      ),
      TweenSequenceItem(
        tween: Tween<Offset>(
          begin: Offset(-3, -2),
          end: Offset(1, 0),
        ),
        weight: 25,
      ),
      TweenSequenceItem(
        tween: Tween<Offset>(begin: Offset(1, 0), end: Offset.zero),
        weight: 25,
      ),
    ]).animate(shakeController);

    resultOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: resultController,
        curve: Interval(0.4, 1.0, curve: Curves.easeOut),
      ),
    );

    resultSlide = Tween<Offset>(begin: Offset(0, 0.5), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: resultController,
            curve: Interval(0.4, 1.0, curve: Curves.easeOutCubic),
          ),
        );

    glowPulse =
        TweenSequence<double>([
          TweenSequenceItem(
            tween: Tween<double>(begin: 0.0, end: 1.0),
            weight: 50,
          ),
          TweenSequenceItem(
            tween: Tween<double>(begin: 1.0, end: 0.0),
            weight: 50,
          ),
        ]).animate(
          CurvedAnimation(
            parent: resultController,
            curve: Interval(0.5, 1.0, curve: Curves.easeInOut),
          ),
        );

    haloRadius = Tween<double>(begin: 40, end: 280).animate(
      CurvedAnimation(parent: haloController, curve: Curves.easeOutQuad),
    );

    haloOpacity = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: 0.5), weight: 20),
      TweenSequenceItem(tween: Tween<double>(begin: 0.5, end: 0.0), weight: 80),
    ]).animate(CurvedAnimation(parent: haloController, curve: Curves.easeOut));

    flashOpacity = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 0.25),
        weight: 10,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.25, end: 0.0),
        weight: 90,
      ),
    ]).animate(flashController);

    wobbleAngle =
        TweenSequence<double>([
          TweenSequenceItem(
            tween: Tween<double>(begin: 0, end: -0.06),
            weight: 25,
          ),
          TweenSequenceItem(
            tween: Tween<double>(begin: -0.06, end: 0.04),
            weight: 25,
          ),
          TweenSequenceItem(
            tween: Tween<double>(begin: 0.04, end: -0.02),
            weight: 25,
          ),
          TweenSequenceItem(
            tween: Tween<double>(begin: -0.02, end: 0),
            weight: 25,
          ),
        ]).animate(
          CurvedAnimation(
            parent: wobbleController,
            curve: Curves.easeInOutSine,
          ),
        );

    controller.addListener(() {
      double currentHeightNormalized = (heightAnimation.value.abs() / 400);
      spinLoopPlayer.setVolume(0.2 - (0.1 * currentHeightNormalized));
    });

    controller.addStatusListener((status) {
      if (status == AnimationStatus.forward) {
        setState(() => currentState = CoinState.tossing);
        _startSpinLoop();
      } else if (status == AnimationStatus.completed) {
        _onImpact();
      }
    });
  }

  void _onImpact() {
    setState(() => currentState = CoinState.landed);
    _stopSpinLoop();
    shakeController.forward(from: 0);
    haloController.forward(from: 0);
    Vibration.vibrate(pattern: [0, 50, 40, 60]);
    _playSound("land.mp3");

    Future.delayed(Duration(milliseconds: 200), () {
      if (mounted) wobbleController.forward(from: 0);
    });

    Future.delayed(Duration(milliseconds: 150), () {
      if (mounted) resultController.forward(from: 0);
    });

    Future.delayed(Duration(milliseconds: 2000), () {
      if (mounted) _showDecisionBottomSheet();
    });
  }

  void _showCallTossBottomSheet() {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(ResponsiveHelper.w(24))),
      ),
      builder: (ctx) {
        return PopScope(
          canPop: false,
          child: Padding(
            padding: EdgeInsets.all(ResponsiveHelper.w(24.0)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'TOSS TIME',
                  style: GoogleFonts.outfit(
                    color: Colors.white54,
                    fontSize: ResponsiveHelper.sp(14),
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "$callerTeamName's Call",
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: ResponsiveHelper.sp(24),
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          callerPrediction = "HEADS";
                          Navigator.pop(ctx);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFF7E7A1),
                          foregroundColor: Colors.black,
                          padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(16)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
                          ),
                        ),
                        child: Text(
                          'HEADS',
                          style: TextStyle(
                            fontSize: ResponsiveHelper.sp(18),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          callerPrediction = "TAILS";
                          Navigator.pop(ctx);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFF7E7A1),
                          foregroundColor: Colors.black,
                          padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(16)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
                          ),
                        ),
                        child: Text(
                          'TAILS',
                          style: TextStyle(
                            fontSize: ResponsiveHelper.sp(18),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showDecisionBottomSheet() {
    isTossCompleted = true;
    String tossResult = isHeads ? "HEADS" : "TAILS";
    bool callerWon = (tossResult == callerPrediction);
    String winner = callerWon ? callerTeamName : otherTeamName;

    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(ResponsiveHelper.w(24))),
      ),
      builder: (ctx) {
        return PopScope(
          canPop: false,
          child: Padding(
            padding: EdgeInsets.all(ResponsiveHelper.w(24.0)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'TOSS WON BY',
                  style: GoogleFonts.outfit(
                    color: Colors.white54,
                    fontSize: ResponsiveHelper.sp(14),
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  winner,
                  style: GoogleFonts.outfit(
                    color: Color(0xFF56F174),
                    fontSize: ResponsiveHelper.sp(28),
                    fontWeight: FontWeight.w800,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 12),
                Text(
                  'What will they do first?',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          Navigator.pop(ctx);
                          final cCtrl = Get.find<CricketController>();
                          try {
                            await cCtrl.finalizeMatchAndStart(winner, 'bat');
                            if (mounted) {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      CricketScoreboardScreen(),
                                ),
                                (route) => false,
                              );
                            }
                          } catch (e) {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Error: $e'),
                                  backgroundColor: Colors.redAccent,
                                ),
                              );
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(16)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
                          ),
                        ),
                        child: Text(
                          'BAT',
                          style: TextStyle(
                            fontSize: ResponsiveHelper.sp(18),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          Navigator.pop(ctx);
                          final cCtrl = Get.find<CricketController>();
                          try {
                            await cCtrl.finalizeMatchAndStart(winner, 'bowl');
                            if (mounted) {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      CricketScoreboardScreen(),
                                ),
                                (route) => false,
                              );
                            }
                          } catch (e) {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Error: $e'),
                                  backgroundColor: Colors.redAccent,
                                ),
                              );
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(16)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
                          ),
                        ),
                        child: Text(
                          'BOWL',
                          style: TextStyle(
                            fontSize: ResponsiveHelper.sp(18),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _startSpinLoop() async {
    try {
      await spinLoopPlayer.setReleaseMode(ReleaseMode.loop);
      await spinLoopPlayer.play(AssetSource("spin_loop.mp3"), volume: 0.2);
    } catch (_) {}
  }

  void _stopSpinLoop() {
    spinLoopPlayer.stop();
  }

  Future<void> _playSound(String fileName) async {
    try {
      await audioPlayer.play(AssetSource(fileName), volume: 0.6);
    } catch (e) {
      debugPrint("Audio error: $e");
    }
  }

  void tossCoinWithVelocity(double velocity) {
    if (controller.isAnimating || isTossCompleted || callerPrediction == null) {
      return;
    }

    verticalVelocityRatio = (velocity.abs() / 4000.0).clamp(0.8, 1.4);
    spinCount = 8 + Random().nextInt(7);

    setState(() {
      currentState = CoinState.anticipating;
      isHeads = Random().nextBool();
      randomTilt = (Random().nextDouble() - 0.5) * 0.18;
      randomDriftScale = 0.6 + Random().nextDouble() * 0.8;

      rotationAnimation =
          Tween<double>(
            begin: 0,
            end: isHeads
                ? (pi * 2 * (spinCount ~/ 2))
                : (pi * 2 * (spinCount ~/ 2) + pi),
          ).animate(
            CurvedAnimation(
              parent: controller,
              curve: Interval(0.08, 1.0, curve: Curves.easeOutExpo),
            ),
          );

      controller.duration = Duration(
        milliseconds: (1800 * verticalVelocityRatio).toInt(),
      );
    });

    resultController.reset();
    _playSound("flip.mp3");
    controller.forward(from: 0);
  }

  @override
  void dispose() {
    controller.dispose();
    shakeController.dispose();
    idleController.dispose();
    resultController.dispose();
    haloController.dispose();
    flashController.dispose();
    wobbleController.dispose();
    audioPlayer.dispose();
    spinLoopPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: GestureDetector(
          onVerticalDragEnd: (details) {
            if (details.primaryVelocity != null &&
                details.primaryVelocity! < -300) {
              tossCoinWithVelocity(details.primaryVelocity!);
            }
          },
          child: AnimatedBuilder(
            animation: Listenable.merge([
              controller,
              shakeController,
              idleController,
              resultController,
              haloController,
              flashController,
              wobbleController,
            ]),
            builder: (context, child) {
              return Transform.scale(
                scale: zoomAnimation.value,
                child: Transform.translate(
                  offset: shakeAnimation.value,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CoinShadow(shadowValue: shadowAnimation.value),

                      if (currentState == CoinState.idle) SwipeHint(),

                      TossImpactEffects(
                        haloRadius: haloRadius.value,
                        haloOpacity: haloOpacity.value,
                        shakeValue: shakeController.value,
                        isShakeAnimating: shakeController.isAnimating,
                      ),

                      Coin3D(
                        angle: rotationAnimation.value,
                        verticalShift: heightAnimation.value,
                        idleWobble: idleWobble.value,
                        wobbleAngle: wobbleAngle.value,
                        randomTilt: currentState == CoinState.idle
                            ? 0
                            : randomTilt,
                        xOffset: xOffsetAnimation.value,
                        randomDriftScale: randomDriftScale,
                        verticalVelocityRatio: verticalVelocityRatio,
                        scaleValue: scaleAnimation.value,
                        controllerValue: controller.value,
                        glowPulse: glowPulse.value,
                        rimLightProgress: rimLightProgress.value,
                        isTossing: currentState == CoinState.tossing,
                        isIdle: currentState == CoinState.idle,
                      ),

                      if (currentState == CoinState.landed)
                        TossResultDisplay(
                          slideAnimation: resultSlide,
                          opacityAnimation: resultOpacity,
                          isHeads: isHeads,
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
