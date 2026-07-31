import 'dart:math' as math;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:redesign/controller/maps_controller.dart';
import 'package:redesign/shared_preferences/userPreferences.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/view/USER/Play/tournaments/tournament_detail/tournament_detail_screen.dart';
import 'home_section_header.dart';
import 'home_shimmer.dart';

/* ============================================================
   FEATURED EVENTS (Dynamic Highest Prize Tournaments within 100km)
   ============================================================ */
class HomeFeaturedEvents extends StatefulWidget {
  const HomeFeaturedEvents({super.key});

  @override
  State<HomeFeaturedEvents> createState() => _HomeFeaturedEventsState();
}

class _HomeFeaturedEventsState extends State<HomeFeaturedEvents> {
  late final PageController _controller;
  int _index = 0;
  List<Map<String, dynamic>> _featuredTournaments = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = PageController(viewportFraction: 0.86);
    _loadFeaturedTournaments();
  }

  Future<void> _loadFeaturedTournaments() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('tournaments')
          .get();

      final List<Map<String, dynamic>> items = [];

      final mapsCtrl = Get.isRegistered<MapsController>()
          ? Get.find<MapsController>()
          : null;
      final userLoc = mapsCtrl?.currentLocation.value;
      final double? userLat = userLoc?.lat;
      final double? userLng = userLoc?.lng;

      final now = DateTime.now();

      for (final doc in snapshot.docs) {
        final data = Map<String, dynamic>.from(doc.data());
        data['docId'] = doc.id;

        // Hide tournaments ended more than 2 days ago
        final Timestamp? endTs = data['endDate'] ?? data['startDate'];
        if (endTs != null) {
          final endDate = endTs.toDate();
          if (now.isAfter(endDate.add(const Duration(days: 2)))) {
            continue;
          }
        }

        double? distKm;
        final double? tLat = (data['latitude'] as num?)?.toDouble() ??
            (data['lat'] as num?)?.toDouble();
        final double? tLng = (data['longitude'] as num?)?.toDouble() ??
            (data['lng'] as num?)?.toDouble();

        if (userLat != null && userLng != null && tLat != null && tLng != null) {
          distKm = _calculateDistanceKm(userLat, userLng, tLat, tLng);
        }

        data['distanceKm'] = distKm;
        data['isWithin100Km'] = distKm == null || distKm <= 100.0;
        data['totalPrize'] = _extractTotalPrize(data);

        items.add(data);
      }

      // Filter tournaments within 100 km radius
      List<Map<String, dynamic>> nearTournaments = items
          .where((t) => t['isWithin100Km'] == true)
          .toList();

      List<Map<String, dynamic>> selectedList = [];

      if (nearTournaments.isNotEmpty) {
        nearTournaments.sort((a, b) => (b['totalPrize'] as double).compareTo(a['totalPrize'] as double));
        selectedList = nearTournaments.take(4).toList();
      } else {
        items.sort((a, b) => (b['totalPrize'] as double).compareTo(a['totalPrize'] as double));
        selectedList = items.take(4).toList();
      }

      if (mounted) {
        setState(() {
          _featuredTournaments = selectedList;
          _isLoading = false;
        });

        if (selectedList.length > 1) {
          _startAutoScroll();
        }
      }
    } catch (e) {
      debugPrint('🔴 [HomeFeaturedEvents] Error loading featured tournaments: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _startAutoScroll() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 5));
      if (!mounted || _featuredTournaments.isEmpty) return false;

      _index = (_index + 1) % _featuredTournaments.length;
      if (_controller.hasClients) {
        _controller.animateToPage(
          _index,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      }
      return true;
    });
  }

  double _calculateDistanceKm(double lat1, double lon1, double lat2, double lon2) {
    const p = 0.017453292519943295;
    final a = 0.5 -
        math.cos((lat2 - lat1) * p) / 2 +
        math.cos(lat1 * p) *
            math.cos(lat2 * p) *
            (1 - math.cos((lon2 - lon1) * p)) /
            2;
    return 12742 * math.asin(math.sqrt(a));
  }

  double _extractTotalPrize(Map<String, dynamic> data) {
    if (data['totalPrize'] != null) {
      return (data['totalPrize'] as num).toDouble();
    }
    if (data['totalPrizeAmount'] != null) {
      return (data['totalPrizeAmount'] as num).toDouble();
    }
    if (data['prizePoolAmount'] != null) {
      return (data['prizePoolAmount'] as num).toDouble();
    }

    final prizeMap = data['prizePool'];
    if (prizeMap is Map) {
      if (prizeMap['totalAmount'] != null) {
        return (prizeMap['totalAmount'] as num).toDouble();
      }
      final tiers = prizeMap['tiers'];
      if (tiers is List) {
        double total = 0.0;
        for (final tier in tiers) {
          if (tier is Map) {
            final amtRaw = tier['amount'];
            if (amtRaw is num) {
              total += amtRaw.toDouble();
            } else if (amtRaw is String) {
              final cleaned = amtRaw.replaceAll(RegExp(r'[^0-9.]'), '');
              total += double.tryParse(cleaned) ?? 0.0;
            }
          }
        }
        return total;
      }
    }
    return 0.0;
  }

  String _getCoverImage(Map<String, dynamic> data) {
    // Always prioritize the tournament's own uploaded cover image
    for (final key in ['coverImage', 'coverImageUrl', 'imageUrl', 'image', 'thumbnailUrl']) {
      final val = data[key];
      if (val is String && val.trim().isNotEmpty) return val.trim();
    }
    // Fallback sport-based images if no uploaded image exists
    final sport = (data['sport'] ?? '').toString().toLowerCase();
    if (sport.contains('cricket')) {
      return 'https://images.unsplash.com/photo-1540747913346-19e32dc3e97e';
    } else if (sport.contains('football') || sport.contains('futsal')) {
      return 'https://images.unsplash.com/photo-1517927033932-b3d18e61fb3a';
    } else if (sport.contains('badminton')) {
      return 'https://images.unsplash.com/photo-1626248801379-51a0748a5f96';
    } else if (sport.contains('basketball')) {
      return 'https://images.unsplash.com/photo-1546519638-68e109498ffc';
    }
    return 'https://images.unsplash.com/photo-1511886929837-354d827aae26';
  }

  String _formatSubtitle(Map<String, dynamic> data) {
    final sport = data['sport'] ?? 'Sport';
    final startTs = data['startDate'];
    String dateStr = '';
    if (startTs is Timestamp) {
      dateStr = DateFormat('MMM d').format(startTs.toDate());
    }
    if (dateStr.isNotEmpty) {
      return '$sport • Starts $dateStr';
    }
    return '$sport Tournament';
  }

  String _getTag(Map<String, dynamic> data) {
    final prize = data['totalPrize'] as double? ?? 0.0;
    if (prize > 0) {
      return 'PRIZE POOL  \u20B9${prize.toInt()}';
    }
    return 'FEATURED';
  }

  void _onTapTournament(BuildContext context, Map<String, dynamic> data) async {
    final docId = data['docId'] ?? '';
    final myEmail = await UserPreferences.getDocId() ?? '';
    if (!mounted) return;
    Get.to(
      () => TournamentDetailScreen(
        tournamentId: docId,
        data: data,
        currentUserId: myEmail,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    if (_isLoading) {
      return Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: context.widthPct(5)),
            child: const HomeSectionHeader('Featured Events'),
          ),
          SizedBox(height: context.heightPct(1.5)),
          SizedBox(
            height: (context.widthPct(100) * 0.42).clamp(140.0, 170.0),
            child: const HomeShimmer(),
          ),
        ],
      );
    }

    if (_featuredTournaments.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: context.widthPct(5)),
          child: const HomeSectionHeader('Featured Events'),
        ),
        SizedBox(height: context.heightPct(1.5)),
        LayoutBuilder(
          builder: (context, constraints) {
            final w = constraints.maxWidth;
            final cardHeight = (w * 0.42).clamp(140.0, 170.0);
            final padding = context.widthPct(4.5).clamp(12.0, 16.0);

            return SizedBox(
              height: cardHeight,
              child: PageView.builder(
                controller: _controller,
                padEnds: false,
                itemCount: _featuredTournaments.length,
                itemBuilder: (context, index) {
                  final event = _featuredTournaments[index];
                  final title = (event['tournamentName'] ?? event['name'] ?? event['title'] ?? 'Featured Tournament').toString();
                  final subtitle = _formatSubtitle(event);
                  final tag = _getTag(event);
                  final imageUrl = _getCoverImage(event);

                  return Padding(
                    padding: EdgeInsets.only(
                      left: index == 0 ? context.widthPct(5) : 0,
                      right: index == _featuredTournaments.length - 1
                          ? context.widthPct(5)
                          : context.widthPct(4),
                    ),
                    child: GestureDetector(
                      onTap: () => _onTapTournament(context, event),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                          context.minDimensionPct(5).clamp(14.0, 20.0),
                        ),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            /// CACHED IMAGE WITH SHIMMER
                            CachedNetworkImage(
                              imageUrl: imageUrl,
                              fit: BoxFit.cover,
                              cacheKey: imageUrl,
                              placeholder: (context, _) => const HomeShimmer(),
                              errorWidget: (context, _, __) => Center(
                                child: Icon(
                                  Icons.emoji_events_outlined,
                                  color: AppColors.muted,
                                  size: 28,
                                ),
                              ),
                            ),

                            /// OVERLAY — transparent at top, darker at bottom for text legibility
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  stops: const [0.0, 0.45, 1.0],
                                  colors: [
                                    Colors.black.withValues(alpha: 0.15),
                                    Colors.black.withValues(alpha: 0.35),
                                    Colors.black.withValues(alpha: 0.75),
                                  ],
                                ),
                              ),
                            ),

                            /// CONTENT
                            Padding(
                              padding: EdgeInsets.all(padding),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  /// TAG
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: context.widthPct(3).clamp(8.0, 12.0),
                                      vertical: context.heightPct(0.5).clamp(4.0, 6.0),
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.accent,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      tag,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppTypography.labelCaps.copyWith(
                                        fontSize: context.responsiveFont(10),
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.background,
                                      ),
                                    ),
                                  ),

                                  const Spacer(),

                                  /// TITLE
                                  Text(
                                    title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTypography.headlineSm.copyWith(
                                      color: AppColors.textPrimary,
                                      fontSize: context.responsiveFont(15),
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),

                                  SizedBox(height: context.heightPct(0.5)),

                                  /// SUBTITLE
                                  Text(
                                    subtitle,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTypography.bodySm.copyWith(
                                      color: AppColors.textSecondary,
                                      fontSize: context.responsiveFont(11),
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
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
