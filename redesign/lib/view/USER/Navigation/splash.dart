import 'dart:async';
import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/view/USER/SignIn-SignUp/favorite_sports/favorite_sports_screen.dart';
import 'package:redesign/view/USER/SignIn-SignUp/onboarding/onboarding_screen.dart';
import 'package:redesign/view/USER/Navigation/user_navigation.dart';
import 'package:redesign/shared_preferences/userPreferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _progress = 0.0;
  Timer? _loaderTimer;

  @override
  void initState() {
    super.initState();
    _startLinearLoading();
  }

  void _startLinearLoading() {
    const stepDuration = Duration(milliseconds: 25);
    const totalSteps = 100;
    int currentStep = 0;

    _loaderTimer = Timer.periodic(stepDuration, (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      currentStep++;
      setState(() {
        _progress = (currentStep / totalSteps).clamp(0.0, 1.0);
      });

      if (currentStep >= totalSteps) {
        timer.cancel();
        _goNext();
      }
    });
  }

  void _goNext() async {
    bool loggedIn = await UserPreferences.isLoggedIn();
    if (!mounted) return;

    if (loggedIn) {
      bool isProfileComplete = await UserPreferences.isProfileComplete();
      final sports = await UserPreferences.getFavoriteSports();
      if (!mounted) return;
      if (isProfileComplete && sports.length >= 4) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const UserAppNavShell()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => FavoriteSportsScreen()),
        );
      }
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const OnboardingScreen()),
      );
    }
  }

  @override
  void dispose() {
    _loaderTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    final logoSize = context.minDimensionPct(24);
    final progressWidth = context.widthPct(75);
    final percentageVal = (_progress * 100).toInt();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.widthPct(8),
            vertical: context.heightPct(4),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox.shrink(),

              /// CENTER BRAND SECTION (CLEAN STATIC DESIGN)
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// STATIC LOGO CONTAINER
                  Container(
                    width: logoSize,
                    height: logoSize,
                    decoration: BoxDecoration(
                      color: AppColors.accent,
                      borderRadius: BorderRadius.circular(
                        context.minDimensionPct(6),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.accent.withValues(alpha: 0.4),
                          blurRadius: 24,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.flash_on_rounded,
                      color: AppColors.background,
                      size: logoSize * 0.55,
                    ),
                  ),
                  SizedBox(height: context.heightPct(3)),

                  /// BRAND NAME
                  Text(
                    'PlayZ',
                    style: AppTypography.displayLg.copyWith(
                      fontSize: context.responsiveFont(42),
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1.0,
                    ),
                  ),
                  SizedBox(height: context.heightPct(2)),

                  /// BIG SLOGAN TEXT
                  Text(
                    "LET'S PLAY. LET'S WIN.",
                    textAlign: TextAlign.center,
                    style: AppTypography.headlineXl.copyWith(
                      fontSize: context.responsiveFont(22),
                      color: AppColors.accent,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.8,
                      height: 1.3,
                    ),
                  ),
                ],
              ),

              /// BOTTOM LINEAR LOADER & MOVING PERCENTAGE
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// PERCENTAGE COUNTER
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'LOADING ',
                        style: AppTypography.labelCaps.copyWith(
                          fontSize: context.responsiveFont(11),
                          color: AppColors.textSecondary,
                          letterSpacing: 1.5,
                        ),
                      ),
                      Text(
                        '$percentageVal%',
                        style: AppTypography.monoMd.copyWith(
                          fontSize: context.responsiveFont(14),
                          color: AppColors.accent,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: context.heightPct(1.2)),

                  /// LINEAR PROGRESS BAR
                  SizedBox(
                    width: progressWidth,
                    height: 6,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(3),
                      child: LinearProgressIndicator(
                        value: _progress,
                        backgroundColor: AppColors.card,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          AppColors.accent,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: context.heightPct(2)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
