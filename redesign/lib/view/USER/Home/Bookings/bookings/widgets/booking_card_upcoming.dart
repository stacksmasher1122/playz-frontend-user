import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/view/USER/Home/Bookings/qr_in_bookings/qr_in_bookings_screen.dart';
import 'package:redesign/services/scoreboard_booking_validator.dart';
import 'package:redesign/services/scoreboard_recovery_manager.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/cricket_controller.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/badminton_controller.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Cricket/cricket_setup/cricket_setup_screen.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Badminton/badminton_setup/badminton_setup_screen.dart';
import 'action_chip.dart';
import 'status_badge.dart';
import 'package:redesign/theme/responsive_helper.dart';

class BookingCardUpcoming extends StatefulWidget {
  final Map<String, dynamic>? bookingData;

  const BookingCardUpcoming({super.key, this.bookingData});

  @override
  State<BookingCardUpcoming> createState() => _BookingCardUpcomingState();
}

class _BookingCardUpcomingState extends State<BookingCardUpcoming> {
  RecoverableMatchItem? _existingMatch;

  @override
  void initState() {
    super.initState();
    _checkExistingScoreboard();
  }

  Future<void> _checkExistingScoreboard() async {
    final rawBookingId = (widget.bookingData?['bookingId'] ?? widget.bookingData?['id'] ?? widget.bookingData?['docId'] ?? '').toString().trim();
    if (rawBookingId.isNotEmpty) {
      final expectedMatchId = 'SLOT_$rawBookingId';
      final unfinished = await ScoreboardRecoveryManager.getUnfinishedMatches();
      for (final m in unfinished) {
        if (m.matchId == expectedMatchId || m.matchId.contains(rawBookingId)) {
          if (mounted) {
            setState(() {
              _existingMatch = m;
            });
          }
          return;
        }
      }
    }
    if (mounted) {
      setState(() {
        _existingMatch = null;
      });
    }
  }

  Future<void> _launchGoogleMaps() async {
    final turfName = widget.bookingData?['turfName'] ?? '';
    final address = widget.bookingData?['turfAddress'] ?? widget.bookingData?['address'] ?? '';
    final query = Uri.encodeComponent('$turfName $address'.trim());
    final uri = Uri.parse('https://www.google.com/maps/search/?api=1&query=$query');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _onOpenScoreboard(BuildContext context) {
    final result = ScoreboardBookingValidator.validateBooking(widget.bookingData);

    if (!result.isAllowed) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: AppColors.card,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(context.minDimensionPct(4))),
          title: Row(
            children: [
              const Icon(Icons.timer_off_outlined, color: Colors.amber, size: 24),
              SizedBox(width: context.widthPct(2.5)),
              Expanded(
                child: Text(
                  'Scoreboard Access',
                  style: AppTypography.headlineSm.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            result.message,
            style: AppTypography.bodySm.copyWith(
              color: AppColors.textSecondary,
              fontSize: context.responsiveFont(14),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                'OK',
                style: AppTypography.bodySm.copyWith(
                  color: AppColors.accent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
      return;
    }

    final bookingId = (widget.bookingData?['bookingId'] ?? widget.bookingData?['id'] ?? 'BOOKING_${DateTime.now().millisecondsSinceEpoch}').toString();

    if (result.sportName == 'Cricket') {
      final controller = Get.isRegistered<CricketController>()
          ? Get.find<CricketController>()
          : Get.put(CricketController());
      controller.currentMatchId.value = 'SLOT_$bookingId';
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => FriendlySetupScreen()),
      ).then((_) => _checkExistingScoreboard());
    } else if (result.sportName == 'Badminton') {
      final controller = Get.isRegistered<BadmintonController>()
          ? Get.find<BadmintonController>()
          : Get.put(BadmintonController());
      controller.currentMatchId.value = 'SLOT_$bookingId';
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => BadmintonSetupScreen()),
      ).then((_) => _checkExistingScoreboard());
    }
  }

  void _onContinueScoreboard(BuildContext context) async {
    final result = ScoreboardBookingValidator.validateBooking(widget.bookingData);
    if (!result.isAllowed) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: AppColors.card,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(context.minDimensionPct(4))),
          title: Row(
            children: [
              const Icon(Icons.timer_off_outlined, color: Colors.amber, size: 24),
              SizedBox(width: context.widthPct(2.5)),
              Expanded(
                child: Text(
                  'Scoreboard Access Expired',
                  style: AppTypography.headlineSm.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            result.message,
            style: AppTypography.bodySm.copyWith(
              color: AppColors.textSecondary,
              fontSize: context.responsiveFont(14),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                'OK',
                style: AppTypography.bodySm.copyWith(
                  color: AppColors.accent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
      return;
    }

    if (_existingMatch != null) {
      await ScoreboardRecoveryManager.resumeMatch(context, _existingMatch!);
      _checkExistingScoreboard();
    }
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    final turfName = widget.bookingData?['turfName'] ?? 'Neon Futsal Arena';
    final turfImage = widget.bookingData?['turfImage'] ?? 'https://images.unsplash.com/photo-1517927033932-b3d18e61fb3a';
    final groundName = widget.bookingData?['groundName'] ?? 'Court 4';
    final sport = widget.bookingData?['sport'] ?? '5-a-side';
    final timeSlot = widget.bookingData?['timeSlot'] ?? '20:00 – 21:00';
    final dateFormatted = widget.bookingData?['dateFormatted'] ?? widget.bookingData?['date'] ?? 'Today';
    final address = widget.bookingData?['turfAddress'] ?? 'Local Turf Arena';
    final statusText = (widget.bookingData?['status'] ?? 'CONFIRMED').toString().toUpperCase();

    final hasActiveMatch = _existingMatch != null;
    final imageSize = context.minDimensionPct(14).clamp(48.0, 60.0);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        context.widthPct(4),
        context.heightPct(0.8),
        context.widthPct(4),
        context.heightPct(1.5),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(context.minDimensionPct(4)),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => BookingQrScreen(bookingData: widget.bookingData),
              ),
            );
          },
          child: Container(
            padding: EdgeInsets.all(context.widthPct(3.5)),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(context.minDimensionPct(4)),
              border: Border.all(
                color: hasActiveMatch ? AppColors.accent.withValues(alpha: 0.6) : AppColors.borderDark,
                width: hasActiveMatch ? 1.5 : 1.0,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// TOP ROW
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(context.minDimensionPct(3)),
                      child: Image.network(
                        turfImage,
                        height: imageSize,
                        width: imageSize,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          height: imageSize,
                          width: imageSize,
                          color: AppColors.surface,
                          child: const Icon(Icons.sports_soccer, color: AppColors.textPrimary),
                        ),
                      ),
                    ),
                    SizedBox(width: context.widthPct(3)),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            turfName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.headlineSm.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w700,
                              fontSize: context.responsiveFont(14),
                            ),
                          ),
                          SizedBox(height: context.heightPct(0.4)),
                          Text(
                            '$groundName · $sport',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.bodySm.copyWith(
                              color: AppColors.muted,
                              fontSize: context.responsiveFont(12),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(width: context.widthPct(2)),
                    StatusBadge(statusText, AppColors.accent),
                  ],
                ),

                SizedBox(height: context.heightPct(1.2)),

                Text(
                  '$dateFormatted · $timeSlot',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.headlineSm.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: context.responsiveFont(12),
                    fontWeight: FontWeight.w600,
                  ),
                ),

                SizedBox(height: context.heightPct(0.6)),

                Text(
                  '📍 $address',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.muted,
                    fontSize: context.responsiveFont(12),
                  ),
                ),

                SizedBox(height: context.heightPct(1.5)),

                /// ACTIONS
                Wrap(
                  spacing: context.widthPct(2.5),
                  runSpacing: context.heightPct(1),
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    ActionChipWidget(
                      hasActiveMatch ? Icons.play_circle_fill : Icons.sports_score,
                      hasActiveMatch ? 'Continue Scoreboard' : 'Start Scoreboard',
                      onTap: () {
                        if (hasActiveMatch) {
                          _onContinueScoreboard(context);
                        } else {
                          _onOpenScoreboard(context);
                        }
                      },
                    ),
                    ActionChipWidget(
                      Icons.qr_code_2,
                      'QR Code',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => BookingQrScreen(bookingData: widget.bookingData),
                          ),
                        );
                      },
                    ),
                    ActionChipWidget(
                      Icons.location_on,
                      '',
                      onTap: _launchGoogleMaps,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
