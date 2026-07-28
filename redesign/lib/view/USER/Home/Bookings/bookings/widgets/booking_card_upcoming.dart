import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:redesign/view/USER/Home/Bookings/qr_in_bookings/qr_in_bookings_screen.dart';
import 'package:redesign/services/scoreboard_booking_validator.dart';
import 'package:redesign/services/scoreboard_recovery_manager.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/cricket_controller.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Scoreboard_Controller/badminton_controller.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Cricket/cricket_setup/cricket_setup_screen.dart';
import 'package:redesign/view/USER/Home/Scoreboard/Badminton/badminton_setup/badminton_setup_screen.dart';
import '../bookings_screen.dart';
import 'action_chip.dart';
import 'status_badge.dart';
import 'package:redesign/theme/responsive_helper.dart';

class BookingCardUpcoming extends StatefulWidget {
  final Map<String, dynamic>? bookingData;

  const BookingCardUpcoming({super.key, this.bookingData});
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
          backgroundColor: const Color(0xFF1E1E1E),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              const Icon(Icons.timer_off_outlined, color: Colors.orangeAccent, size: 24),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'Scoreboard Access',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          content: Text(
            result.message,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('OK', style: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold)),
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
          backgroundColor: const Color(0xFF1E1E1E),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              const Icon(Icons.timer_off_outlined, color: Colors.orangeAccent, size: 24),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'Scoreboard Access Expired',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          content: Text(
            result.message,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('OK', style: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold)),
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

    return Padding(
      padding: EdgeInsets.fromLTRB(16, 6, 16, 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(18)),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => BookingQrScreen(bookingData: widget.bookingData),
              ),
            );
          },
          child: Container(
            padding: EdgeInsets.all(ResponsiveHelper.w(14)),
            decoration: BoxDecoration(
              color: MyBookingsConstants.surface,
              borderRadius: BorderRadius.circular(ResponsiveHelper.w(18)),
              border: Border.all(
                color: hasActiveMatch ? MyBookingsConstants.green.withValues(alpha: 0.6) : Colors.white.withValues(alpha: 0.08),
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
                      borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
                      child: Image.network(
                        turfImage,
                        height: ResponsiveHelper.h(56),
                        width: ResponsiveHelper.w(56),
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          height: ResponsiveHelper.h(56),
                          width: ResponsiveHelper.w(56),
                          color: Colors.grey.shade800,
                          child: Icon(Icons.sports_soccer, color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            turfName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: ResponsiveHelper.sp(14),
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '$groundName · $sport',
                            style: TextStyle(
                              color: MyBookingsConstants.muted,
                              fontSize: ResponsiveHelper.sp(12),
                            ),
                          ),
                        ],
                      ),
                    ),

                    StatusBadge(statusText, MyBookingsConstants.green),
                  ],
                ),

                SizedBox(height: 10),

                Text(
                  '$dateFormatted · $timeSlot',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: ResponsiveHelper.sp(12),
                    fontWeight: FontWeight.w600,
                  ),
                ),

                SizedBox(height: 6),

                Text(
                  '📍 $address',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: MyBookingsConstants.muted,
                    fontSize: ResponsiveHelper.sp(12),
                  ),
                ),

                SizedBox(height: 12),

                /// ACTIONS
                Wrap(
                  spacing: 10,
                  runSpacing: 8,
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
                      Icons.qr_code,
                      'View QR Code',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => BookingQrScreen(bookingData: widget.bookingData),
                          ),
                        );
                      },
                    ),
                    ActionChipWidget(
                      Icons.directions,
                      'Directions',
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
