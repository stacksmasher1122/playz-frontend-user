import 'dart:typed_data';
import 'package:archive/archive.dart';
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
import 'widgets/home_previous_venues.dart';
import 'widgets/home_quick_access_tiles.dart';
import 'widgets/home_top_app_bar.dart';
import 'package:redesign/theme/responsive_helper.dart';

/// Custom DotLottie decoder.
/// - Picks the animation JSON from the animations/ folder (not manifest.json)
/// - Provides embedded PNGs from the zip as MemoryImage providers,
///   normalising the path to strip any leading slash (e.g. /images/ → images/).
Future<LottieComposition?> decodeDotLottie(List<int> bytes) async {
  return LottieComposition.decodeZip(
    bytes,
    filePicker: (files) {
      return files.firstWhere(
        (f) => f.name.endsWith('.json') && f.name != 'manifest.json',
      );
    },
    imageProviderFactory: (asset) {
      // asset.dirName is '/images/', asset.fileName is 'image_0.png'
      // Strip leading slash so we can match against zip file names like 'images/image_0.png'
      final dir = asset.dirName.replaceFirst(RegExp(r'^/'), '');
      final target = '$dir${asset.fileName}'.toLowerCase();

      final archive = ZipDecoder().decodeBytes(bytes);
      final imageFile = archive.files.firstWhereOrNull(
        (f) => f.name.toLowerCase() == target,
      );

      if (imageFile != null) {
        return MemoryImage(Uint8List.fromList(imageFile.content as List<int>));
      }
      return null;
    },
  );
}

/* ============================================================
   USER HOME PAGE
   ============================================================ */
class UserHomePage extends StatefulWidget {
  const UserHomePage({super.key});

  // Spotify-style palette mapped from AppColors
  static Color bg = AppColors.background;
  static Color surface = AppColors.card;
  static Color accent = AppColors.accent;
  static Color muted = AppColors.textSecondary;

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage>
    with TickerProviderStateMixin {
  final _controller = Get.find<UserProfileController>();
  final _eventFestController = Get.find<EventFestController>();

  // Lottie animation widget storage
  Widget? _festivalLottieWidget;
  late final AnimationController _lottieController;

  // Fade-out controller
  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;
  bool _isFadingOut = false;

  @override
  void initState() {
    super.initState();
    _lottieController = AnimationController(vsync: this);

    // Fade-out over 600ms
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );

    _loadUserData();

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
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _preloadFestivalLottie() async {
    if (_eventFestController.activeFestival.value.isNotEmpty) {
      final active = _eventFestController.activeFestival.value;
      final data = _eventFestController.festivalEventData[active];

      final assetPath = (data?['lottieAsset'] ?? 'assets/lottie/tfu_republic.lottie').toString();
      final double startingProgress =
          (data?['lottieProgress'] as num?)?.toDouble() ?? 0.0;
      final double endProgress =
          (data?['lottieEndProgress'] as num?)?.toDouble() ?? 1.0;
      final double speed = (data?['lottieSpeed'] as num?)?.toDouble() ?? 1.0;

      if (mounted) {
        setState(() {
          _isFadingOut = false;
          // Bottom-aligned so monument bases touch the navigation bar top
          _festivalLottieWidget = RepaintBoundary(
            child: SizedBox.expand(
              child: Lottie.asset(
                assetPath,
                decoder: assetPath.endsWith('.lottie') ? decodeDotLottie : null,
                controller: _lottieController,
                frameRate: FrameRate.max,
                fit: BoxFit.contain,
                alignment: Alignment.bottomCenter,
                onLoaded: (composition) {
                  _lottieController.duration = Duration(
                    microseconds:
                        (composition.duration.inMicroseconds / speed).round(),
                  );
                  Future.delayed(const Duration(milliseconds: 200), () {
                    if (mounted) {
                      _lottieController.value = startingProgress;
                      _lottieController.animateTo(endProgress).then((_) {
                        if (mounted) {
                          _eventFestController.markLottieAsShown();
                          // Trigger smooth fade-out
                          setState(() => _isFadingOut = true);
                          _fadeController.forward().then((_) {
                            if (mounted) {
                              setState(() {
                                _festivalLottieWidget = null;
                                _isFadingOut = false;
                              });
                              _fadeController.reset();
                            }
                          });
                        }
                      });
                    }
                  });
                },
                errorBuilder: (context, error, stackTrace) {
                  debugPrint("Error loading dotLottie asset: $error");
                  return const SizedBox.shrink();
                },
              ),
            ),
          );
        });
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
      backgroundColor: AppColors.background,
      body: SafeArea(
        top: true,
        bottom: false,
        child: Stack(
          children: [
            ListView(
              padding: EdgeInsets.only(bottom: context.heightPct(10)),
              children: [
                HomeTopAppBar(),
                SizedBox(height: context.heightPct(2.5)),
                HomeHeroCTA(),
                SizedBox(height: context.heightPct(3)),
                HomeQuickAccessTiles(),
                SizedBox(height: context.heightPct(3)),
                HomePreviousVenues(),
                HomeExploreBySport(),
                SizedBox(height: context.heightPct(3)),
                HomeFeaturedEvents(),
                SizedBox(height: context.heightPct(2.5)),
                HomeOfficialAppInfo(),
              ],
            ),
            // Startup festival Lottie — sits just above the bottom nav bar, fades out smoothly
            if (_festivalLottieWidget != null)
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                bottom: context.heightPct(9).clamp(64.0, 88.0),
                child: IgnorePointer(
                  child: _isFadingOut
                      ? FadeTransition(
                          opacity: ReverseAnimation(_fadeAnimation),
                          child: _festivalLottieWidget!,
                        )
                      : _festivalLottieWidget!,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
