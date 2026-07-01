import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:redesign/controller/event_fest_controller.dart';
import 'package:redesign/controller/user_profile_controller.dart';
import 'package:redesign/shared_preferences/userPreferences.dart';
import 'package:redesign/theme/app_colors.dart';

import 'widgets/home_explore_by_sport.dart';
import 'widgets/home_featured_events.dart';
import 'widgets/home_hero_cta.dart';
import 'widgets/home_official_app_info.dart';
import 'widgets/home_popular_venues.dart';
import 'widgets/home_quick_access_tiles.dart';
import 'widgets/home_top_app_bar.dart';
import 'package:redesign/theme/responsive_helper.dart';

/* ============================================================
   USER HOME PAGE
   ============================================================ */
class UserHomePage extends StatefulWidget {
  UserHomePage({super.key});

  // Spotify-style palette
  static Color bg = AppColors.background;
  static Color surface = Color(0xFF181818);
  static Color accent = AppColors.accent;
  static Color muted = Color(0xFF9CA3AF);

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage>
    with TickerProviderStateMixin {
  final _controller = Get.find<UserProfileController>();
  final _eventFestController = Get.find<EventFestController>();

  // Lottie Optimization: Store widget in variable to avoid reload on rebuild
  Widget? _festivalLottieWidget;
  late final AnimationController _lottieController;

  @override
  void initState() {
    super.initState();
    _lottieController = AnimationController(vsync: this);
    _loadUserData();

    // Check immediately in case the controller already set it to true
    if (_eventFestController.shouldShowLottie.value) {
      _preloadFestivalLottie();
    }

    ever(_eventFestController.shouldShowLottie, (show) {
      if (show == true) {
        _preloadFestivalLottie();
      }
    });
  }

  @override
  void dispose() {
    _lottieController.dispose();
    super.dispose();
  }

  Future<void> _preloadFestivalLottie() async {
    if (_eventFestController.activeFestival.value.isNotEmpty) {
      final active = _eventFestController.activeFestival.value;
      final data = _eventFestController.festivalEventData[active];

      final url = data?['lottieUrl'];
      final double startingProgress =
          (data?['lottieProgress'] as num?)?.toDouble() ?? 0.0;
      final double endProgress =
          (data?['lottieEndProgress'] as num?)?.toDouble() ?? 1.0;
      final double speed = (data?['lottieSpeed'] as num?)?.toDouble() ?? 1.0;
      final String alignmentStr =
          data?['lottieAlignment']?.toString() ?? 'center';

      AlignmentGeometry lottieAlignment = Alignment.center;
      if (alignmentStr == 'bottom') {
        lottieAlignment = Alignment.bottomCenter;
      } else if (alignmentStr == 'top') {
        lottieAlignment = Alignment.topCenter;
      }

      if (url != null) {
        if (mounted) {
          setState(() {
            // Optimization: Wrap animation in RepaintBoundary
            _festivalLottieWidget = RepaintBoundary(
              // Usage of SizedBox.expand() instead of MediaQuery in initState context
              child: SizedBox.expand(
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: alignmentStr == 'bottom' ? 80.0 : 0.0,
                  ),
                  child: Lottie.network(
                    url,
                    controller: _lottieController,
                    frameRate: FrameRate.max, // smoother playback
                    fit: BoxFit.contain,
                    alignment: lottieAlignment,
                    onLoaded: (composition) {
                      _lottieController.duration = Duration(
                        microseconds:
                            (composition.duration.inMicroseconds / speed)
                                .round(),
                      );
                      // Wait for page transition to finish before playing
                      Future.delayed(Duration(milliseconds: 500), () {
                        if (mounted) {
                          _lottieController.value = startingProgress;
                          _lottieController.animateTo(endProgress).then((_) {
                            if (mounted) {
                              _eventFestController.markLottieAsShown();
                              setState(() {
                                _festivalLottieWidget = null;
                              });
                            }
                          });
                        }
                      });
                    },
                    errorBuilder: (context, error, stackTrace) {
                      debugPrint("Error loading lottie: $error");
                      return SizedBox.shrink();
                    },
                  ),
                ), // Closes Padding
              ), // Closes SizedBox.expand
            );
          });
        }
      }
    }
  }

  Future<void> _loadUserData() async {
    final docId = await UserPreferences.getDocId();
    if (docId != null) {
      _controller.fetchUserProfile(docId);
    }
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Scaffold(
      extendBody: true,
      backgroundColor: UserHomePage.bg,
      body: SafeArea(
        top: true,
        bottom: false,
        child: Stack(
          children: [
            ListView(
              padding: EdgeInsets.fromLTRB(0, 0, 00, 80),
              children: [
                HomeTopAppBar(),
                Padding(padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(20))),
                SizedBox(height: 20),
                HomeHeroCTA(),
                SizedBox(height: 28),
                HomeQuickAccessTiles(),
                SizedBox(height: 28),
                HomePopularVenues(),
                SizedBox(height: 28),
                HomeExploreBySport(),
                SizedBox(height: 28),
                HomeFeaturedEvents(),
                SizedBox(height: 20),
                HomeOfficialAppInfo(),
              ],
            ),
            // Optimization: Use animation only in hero/top section
            if (_festivalLottieWidget != null)
              Positioned.fill(
                child: IgnorePointer(child: _festivalLottieWidget!),
              ),
          ],
        ),
      ),
    );
  }
}
