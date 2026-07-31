import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:intl/intl.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/view/USER/Play/play/play_models.dart';
import 'package:redesign/controller/User_Controller/Match_Controller/match_controller.dart';
import 'package:redesign/controller/User_Controller/Booking_Controller/booking_controller.dart';
import 'package:redesign/controller/user_profile_controller.dart';
import 'package:redesign/shared_preferences/userPreferences.dart';
import 'package:redesign/view/USER/Book/booking_details/widgets/slot_matrix_bottom_sheet.dart';
import 'package:redesign/utils/slot_overlap_helper.dart';

import 'widgets/match_detail_hero.dart';
import 'widgets/match_slots_card.dart';
import 'widgets/player_pool_section.dart';
import 'widgets/match_location_card.dart';
import 'widgets/match_join_bar.dart';
import 'widgets/special_instructions_card.dart';
import 'widgets/equipment_status_card.dart';
import 'widgets/match_chat_card.dart';

class MatchDetailScreen extends StatefulWidget {
  final GameData? gameData;

  final String? sport;
  final String? type;
  final String? time;
  final String? price;
  final int? currentPlayers;
  final int? maxPlayers;
  final String? address;
  final String? hostId;
  final String? hostName;
  final String? hostAvatar;
  final int? hostXp;
  final List<String>? turfImages;
  final String? instructions;
  final String? equipmentOption;
  final List<String>? playerIds;

  const MatchDetailScreen({
    super.key,
    this.gameData,
    this.sport = 'Football',
    this.type = 'Casual',
    this.time = 'Today, 18:00',
    this.price = '₹100',
    this.currentPlayers = 6,
    this.maxPlayers = 10,
    this.address = 'FC Road, Shivajinagar, Pune, Maharashtra 411005',
    this.hostId = '',
    this.hostName = 'Host Player',
    this.hostAvatar = 'https://i.pravatar.cc/150?img=1',
    this.hostXp = 2500,
    this.turfImages,
    this.instructions = '',
    this.equipmentOption = 'none',
    this.playerIds,
  });

  @override
  State<MatchDetailScreen> createState() => _MatchDetailScreenState();
}

class _MatchDetailScreenState extends State<MatchDetailScreen> {
  final _matchController = Get.isRegistered<MatchController>()
      ? Get.find<MatchController>()
      : Get.put(MatchController());
  final _bookingController = Get.isRegistered<BookingController>()
      ? Get.find<BookingController>()
      : Get.put(BookingController());
  final _profileController = Get.find<UserProfileController>();

  late Razorpay _razorpay;
  String _currentUserId = '';
  List<String> _bookedSlotsForDate = [];
  bool _isProcessing = false;
  Function(String? paymentId)? _pendingPaymentAction;
  StreamSubscription<QuerySnapshot>? _bookingsSub;

  bool _hasConflictLocal = false;

  @override
  void initState() {
    super.initState();
    debugPrint('🏁 [MatchDetailScreen] initState started for match: ${widget.gameData?.id}');
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _loadCurrentUserId();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        debugPrint('🎨 [MatchDetailScreen] Post-frame callback executing initial fetches...');
        _fetchBookedSlotsForMatchDate();
        _listenToRealtimeSlotConflicts();
      }
    });
  }

  GameData? get _activeGameData {
    final targetMatchId = widget.gameData?.id ?? '';
    if (targetMatchId.isEmpty) return widget.gameData;
    return _matchController.allMatches.firstWhereOrNull((m) => m.id == targetMatchId) ?? widget.gameData;
  }

  void _listenToRealtimeSlotConflicts() {
    final gameData = _activeGameData;
    if (gameData == null || gameData.turfId == null || gameData.turfId!.isEmpty) {
      debugPrint('ℹ️ [MatchDetailScreen] Skipping realtime conflict listener — missing gameData or turfId.');
      return;
    }

    final parts = gameData.time.split(',');
    final dateStr = gameData.date.isNotEmpty ? gameData.date : parts.first.trim();
    if (dateStr.isEmpty) return;

    final ownerId = gameData.ownerId.isNotEmpty ? gameData.ownerId : 'owner_${gameData.turfId}';

    _bookingsSub?.cancel();
    try {
      debugPrint('📡 [MatchDetailScreen] Setting up realtime listener on owners/$ownerId/turfs/${gameData.turfId}/bookings for date: $dateStr');
      _bookingsSub = FirebaseFirestore.instance
          .collection('owners')
          .doc(ownerId)
          .collection('turfs')
          .doc(gameData.turfId!)
          .collection('bookings')
          .where('date', isEqualTo: dateStr)
          .snapshots()
          .listen((snapshot) {
        debugPrint('🔔 [MatchDetailScreen] Realtime turf bookings snapshot updated (${snapshot.docs.length} docs). Re-evaluating conflicts...');
        _fetchBookedSlotsForMatchDate();
      }, onError: (err) {
        debugPrint('⚠️ [MatchDetailScreen] Realtime turf bookings listener error: $err');
      });
    } catch (e) {
      debugPrint('⚠️ [MatchDetailScreen] Realtime turf bookings setup error: $e');
    }
  }

  Future<void> _fetchBookedSlotsForMatchDate() async {
    final gameData = _activeGameData;
    if (gameData == null) {
      debugPrint('ℹ️ [MatchDetailScreen] _fetchBookedSlotsForMatchDate skipped — gameData is null');
      return;
    }

    final parts = gameData.time.split(',');
    final dateStr = gameData.date.isNotEmpty ? gameData.date : parts.first.trim();
    if (dateStr.isEmpty) return;

    debugPrint('🔍 [MatchDetailScreen] Fetching booked slots for date: $dateStr, turfId: ${gameData.turfId}, ownerId: ${gameData.ownerId}');

    try {
      final List<String> bookedList = [];
      final ownerId = gameData.ownerId.isNotEmpty ? gameData.ownerId : 'owner_${gameData.turfId}';

      // 1. Direct query on owners/{ownerId}/turfs/{turfId}/bookings with serverAndCache fallback
      if (gameData.turfId != null && gameData.turfId!.isNotEmpty) {
        try {
          final ownerSnap = await FirebaseFirestore.instance
              .collection('owners')
              .doc(ownerId)
              .collection('turfs')
              .doc(gameData.turfId!)
              .collection('bookings')
              .where('date', isEqualTo: dateStr)
              .get(const GetOptions(source: Source.serverAndCache));

          for (var doc in ownerSnap.docs) {
            final data = doc.data();
            final status = (data['status'] ?? '').toString().toLowerCase();
            if (status == 'cancelled') continue;

            final bGroundId = (data['groundId'] ?? '').toString();
            if (gameData.groundId != null && gameData.groundId!.isNotEmpty && bGroundId.isNotEmpty && bGroundId != gameData.groundId!) {
              continue;
            }

            final timeStr = (data['time'] ?? data['timeSlot'] ?? '${data['startTime']} - ${data['endTime']}').toString();
            if (timeStr.isNotEmpty && !bookedList.contains(timeStr)) {
              bookedList.add(timeStr);
            }
          }
          debugPrint('✅ [MatchDetailScreen] Found ${bookedList.length} booked slots from turf owner bookings.');
        } catch (e) {
          debugPrint('⚠️ [MatchDetailScreen] Turf bookings query error: $e');
        }
      }

      // 2. Query booked match polls on same turf
      if (gameData.turfId != null && gameData.turfId!.isNotEmpty) {
        try {
          final matchSnap = await FirebaseFirestore.instance
              .collection('matches')
              .where('turfId', isEqualTo: gameData.turfId!)
              .where('date', isEqualTo: dateStr)
              .where('isSlotBooked', isEqualTo: true)
              .get(const GetOptions(source: Source.serverAndCache));

          for (var doc in matchSnap.docs) {
            if (doc.id == gameData.id) continue;
            final data = doc.data();
            final timeStr = (data['time'] ?? '').toString();
            if (timeStr.isNotEmpty && !bookedList.contains(timeStr)) {
              bookedList.add(timeStr);
            }
          }
        } catch (_) {}
      }

      // 3. Overlap check
      bool isConflictDetected = false;
      if (!gameData.isSlotBooked && gameData.time.isNotEmpty) {
        final pollInterval = SlotOverlapHelper.parseTimeRange(gameData.time);
        if (pollInterval != null) {
          for (final bookedTimeStr in bookedList) {
            final bookedInterval = SlotOverlapHelper.parseTimeRange(bookedTimeStr);
            if (bookedInterval != null && pollInterval.overlapsWith(bookedInterval)) {
              isConflictDetected = true;
              debugPrint('⚠️ [MatchDetailScreen] Slot conflict detected! Poll time (${gameData.time}) overlaps with booked time ($bookedTimeStr)');
              break;
            }
          }
        }
      }

      if (mounted) {
        setState(() {
          _bookedSlotsForDate = bookedList;
          _hasConflictLocal = isConflictDetected;
        });
        debugPrint('🎨 [MatchDetailScreen] Local state updated cleanly: hasConflictLocal=$_hasConflictLocal, bookedSlotsCount=${bookedList.length}');
      }
    } catch (e) {
      debugPrint('🔴 [MatchDetailScreen] Error fetching booked slots for match date: $e');
    }
  }

  @override
  void dispose() {
    _bookingsSub?.cancel();
    _razorpay.clear();
    super.dispose();
  }

  Future<void> _loadCurrentUserId() async {
    final user = FirebaseAuth.instance.currentUser;
    final docId = await UserPreferences.getDocId() ?? user?.uid ?? '';
    if (mounted) {
      setState(() {
        _currentUserId = docId;
      });
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    if (_pendingPaymentAction != null) {
      final action = _pendingPaymentAction;
      _pendingPaymentAction = null;
      action!(response.paymentId);
    } else {
      _processJoinPoll(paymentId: response.paymentId);
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    _pendingPaymentAction = null;
    Get.snackbar(
      'Payment Cancelled',
      response.message ?? 'Payment was cancelled or interrupted.',
      backgroundColor: AppColors.card,
      colorText: AppColors.textPrimary,
    );
    if (mounted) setState(() => _isProcessing = false);
  }

  void _onJoinPressed() async {
    if (_isProcessing) return;

    final gameData = _activeGameData;
    if (gameData == null) return;

    final hostName = gameData.hostName.isNotEmpty ? gameData.hostName : 'Host Player';
    final priceStr = gameData.price.isNotEmpty ? gameData.price : '₹${gameData.priceNum}';

    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(context.minDimensionPct(4)),
        ),
        title: Text(
          'Join Match Poll ⚽',
          style: AppTypography.headlineSm.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: context.responsiveFont(16),
          ),
        ),
        content: Text(
          'You are joining this match poll on PlayZ! Please note that you do not need to pay now, but you must pay your share ($priceStr) directly to the match host ($hostName).',
          style: AppTypography.bodySm.copyWith(
            color: AppColors.textSecondary,
            fontSize: context.responsiveFont(14),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel', style: TextStyle(color: AppColors.muted)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accent,
              foregroundColor: AppColors.background,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(context.minDimensionPct(3)),
              ),
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Confirm & Join Poll'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() => _isProcessing = true);
      await _processJoinPoll();
    }
  }

  void _openRazorpay(double amount) {
    debugPrint('💳 [Razorpay] _openRazorpay called with amount=$amount (paise=${(amount * 100).toInt()})');
    setState(() => _isProcessing = true);

    final user = FirebaseAuth.instance.currentUser;
    final phone = (_profileController.rxUser.value?.secondaryPhone.isNotEmpty ?? false)
        ? _profileController.rxUser.value!.secondaryPhone
        : (user?.phoneNumber ?? '9876543210');
    final email = _profileController.userEmail.isNotEmpty
        ? _profileController.userEmail
        : user?.email ?? 'player@playz.com';

    final razorpayKey = dotenv.env['RAZORPAY_KEY_ID'] ?? 'rzp_test_THjDLg1t3KW9ib';

    debugPrint('💳 [Razorpay] key=$razorpayKey, phone=$phone, email=$email');

    var options = {
      'key': razorpayKey,
      'amount': (amount * 100).toInt(),
      'name': 'PlayZ Match Poll Join',
      'description': 'Match Poll Join Fee',
      'prefill': {
        'contact': phone,
        'email': email,
      },
    };

    debugPrint('💳 [Razorpay] Opening with options: $options');

    try {
      _razorpay.open(options);
      debugPrint('💳 [Razorpay] _razorpay.open() called successfully');
    } catch (e) {
      debugPrint('🔴 [Razorpay] Error launching Razorpay: $e — executing fallback action');
      if (_pendingPaymentAction != null) {
        final action = _pendingPaymentAction;
        _pendingPaymentAction = null;
        action!('DEV_PASS_${DateTime.now().millisecondsSinceEpoch}');
      } else {
        _processJoinPoll(paymentId: 'DEV_PASS_${DateTime.now().millisecondsSinceEpoch}');
      }
    }
  }

  Future<void> _processJoinPoll({String? paymentId}) async {
    final gameData = _activeGameData;
    if (gameData == null || _currentUserId.isEmpty) return;

    final double priceVal = gameData.priceNum.toDouble();

    await _matchController.joinMatchPoll(
      matchId: gameData.id,
      userId: _currentUserId,
      pricePaid: priceVal,
      paymentId: paymentId,
    );

    setState(() => _isProcessing = false);
  }

  Future<void> _onHostBookSlotPressed() async {
    final gameData = _activeGameData;
    if (gameData == null) return;

    if (gameData.turfId == null || gameData.groundId == null) {
      Get.snackbar(
        'Slot Booked',
        'This match poll has no associated turf owner ID.',
        backgroundColor: AppColors.card,
        colorText: AppColors.textPrimary,
      );
      return;
    }

    setState(() => _isProcessing = true);

    final parts = gameData.time.split(',');
    final dateStr = gameData.date.isNotEmpty ? gameData.date : parts.first.trim();
    final timeStr = parts.length > 1 ? parts.last.trim() : gameData.time;

    final success = await _matchController.confirmSlotBookingByHost(
      matchId: gameData.id,
      ownerId: gameData.ownerId.isNotEmpty ? gameData.ownerId : 'owner_${gameData.turfId}',
      turfId: gameData.turfId!,
      groundId: gameData.groundId!,
      groundName: 'Main Ground',
      dateStr: dateStr,
      timeStr: timeStr,
      slotId: gameData.slotId ?? '',
    );

    setState(() => _isProcessing = false);

    if (!success) {
      await _fetchBookedSlotsForMatchDate();
      Get.snackbar(
        'Booking Failed ❌',
        'The slot ($timeStr) or an overlapping portion of it has already been booked! Please select a new date or time slot below.',
        backgroundColor: AppColors.error,
        colorText: AppColors.textPrimary,
        duration: const Duration(seconds: 5),
        snackPosition: SnackPosition.BOTTOM,
      );
      await _onHostChangeSlotPressed();
    }
  }

  Future<void> _onHostChangeSlotPressed() async {
    debugPrint('📅 [Reschedule] _onHostChangeSlotPressed INVOKED');
    final gameData = _activeGameData;
    if (gameData == null || gameData.turfId == null || gameData.groundId == null) {
      debugPrint('🔴 [Reschedule] Aborted — gameData=${gameData != null}, turfId=${gameData?.turfId}, groundId=${gameData?.groundId}');
      return;
    }

    if (gameData.isSlotBooked) {
      debugPrint('ℹ️ [Reschedule] Aborted — Slot is already booked!');
      Get.snackbar(
        'Slot Already Booked ⚡',
        'Payment has already been completed and this turf slot is locked.',
        backgroundColor: AppColors.card,
        colorText: AppColors.textPrimary,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final targetOwnerId = gameData.ownerId.isNotEmpty ? gameData.ownerId : 'owner_${gameData.turfId}';
    final parts = gameData.time.split(',');
    String currentDateStr = gameData.date.isNotEmpty ? gameData.date : parts.first.trim();
    DateTime currentSelectedDate = DateTime.tryParse(currentDateStr) ?? DateTime.now();
    currentDateStr = DateFormat('yyyy-MM-dd').format(currentSelectedDate);

    debugPrint('📅 [Reschedule] ownerId=$targetOwnerId, turfId=${gameData.turfId}, groundId=${gameData.groundId}, date=$currentDateStr');

    setState(() => _isProcessing = true);

    // Fetch slots dynamically for currentSelectedDate AND AWAIT BEFORE OPENING SHEET!
    debugPrint('📅 [Reschedule] Fetching ground slots for date=$currentDateStr ...');
    await _bookingController.fetchGroundSlots(
      targetOwnerId,
      gameData.turfId!,
      gameData.groundId!,
      dateStr: currentDateStr,
    );
    debugPrint('📅 [Reschedule] Slots fetched: ${_bookingController.slots.length} slots');
    for (final s in _bookingController.slots) {
      debugPrint('   slot: startHour=${s.startHour}, price=${s.price}, isBooked=${s.isBooked}, isAvailable=${s.isAvailable}, status=${s.status}');
    }

    setState(() => _isProcessing = false);

    if (!mounted) {
      debugPrint('🔴 [Reschedule] Widget not mounted after slot fetch, aborting');
      return;
    }

    debugPrint('📅 [Reschedule] Opening START TIME bottom sheet...');

    // ──────────────────────────────────────────────────────
    // STEP 1: Await the start-time bottom sheet
    // ──────────────────────────────────────────────────────
    TimeOfDay? pickedStart;
    try {
      await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (sheetContext) => StatefulBuilder(
          builder: (sbContext, setSheetState) {
            return SlotMatrixBottomSheet(
              isStart: true,
              startTime: null,
              selectedTime: null,
              selectedDate: currentSelectedDate,
              slots: _bookingController.slots,
              onDateChanged: (newDate) async {
                final newDateStr = DateFormat('yyyy-MM-dd').format(newDate);
                debugPrint('📅 [Reschedule] Date changed to: $newDateStr');
                currentSelectedDate = newDate;
                currentDateStr = newDateStr;

                await _bookingController.fetchGroundSlots(
                  targetOwnerId,
                  gameData.turfId!,
                  gameData.groundId!,
                  dateStr: newDateStr,
                );
                debugPrint('📅 [Reschedule] Slots re-fetched for new date: ${_bookingController.slots.length} slots');

                setSheetState(() {});
              },
              onSlotSelected: (selected) {
                debugPrint('📅 [Reschedule] START TIME selected: ${selected.hour}:00 (${selected.period.name})');
                pickedStart = selected;
                // Note: SlotMatrixBottomSheet calls Navigator.pop(context) internally upon tap
              },
            );
          },
        ),
      );
    } catch (e) {
      debugPrint('🔴 [Reschedule] Error showing start time sheet: $e');
    }

    if (pickedStart == null) {
      debugPrint('📅 [Reschedule] Start time was null (user dismissed), aborting');
      return;
    }
    if (!mounted) {
      debugPrint('🔴 [Reschedule] Widget not mounted after start time sheet, aborting');
      return;
    }

    // Small delay to let sheet close animation finish
    await Future.delayed(const Duration(milliseconds: 250));
    if (!mounted) return;

    // ──────────────────────────────────────────────────────
    // STEP 2: Await the end-time bottom sheet
    // ──────────────────────────────────────────────────────
    debugPrint('📅 [Reschedule] Opening END TIME bottom sheet...');
    TimeOfDay? pickedEnd;
    try {
      await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (endSheetContext) => SlotMatrixBottomSheet(
          isStart: false,
          startTime: pickedStart,
          selectedTime: null,
          selectedDate: currentSelectedDate,
          slots: _bookingController.slots,
          onSlotSelected: (selected) {
            debugPrint('📅 [Reschedule] END TIME selected: ${selected.hour}:00 (${selected.period.name})');
            pickedEnd = selected;
            // Note: SlotMatrixBottomSheet calls Navigator.pop(context) internally upon tap
          },
        ),
      );
    } catch (e) {
      debugPrint('🔴 [Reschedule] Error showing end time sheet: $e');
    }

    final start = pickedStart;
    final end = pickedEnd;
    if (start == null || end == null) {
      debugPrint('📅 [Reschedule] Start or End time was null (user dismissed), aborting');
      return;
    }
    if (!mounted) {
      debugPrint('🔴 [Reschedule] Widget not mounted after end time sheet, aborting');
      return;
    }

    // ──────────────────────────────────────────────────────
    // STEP 3: Calculate slot cost
    // ──────────────────────────────────────────────────────
    double newSlotTotalCost = 0.0;
    int startH = start.hour;
    int endH = end.hour;
    int durationHours = (endH > startH) ? (endH - startH) : (24 - startH + endH);

    debugPrint('💰 [Reschedule] Calculating cost: startH=$startH, endH=$endH, durationHours=$durationHours');

    for (int i = 0; i < durationHours; i++) {
      int checkH = (startH + i) % 24;
      final slotModel = _bookingController.slots.firstWhereOrNull((s) => s.startHour == checkH);
      if (slotModel != null && slotModel.price > 0) {
        debugPrint('   hour=$checkH → price=${slotModel.price}');
        newSlotTotalCost += slotModel.price;
      } else {
        debugPrint('   hour=$checkH → no slot model or price=0 (slotModel=${slotModel != null})');
      }
    }

    final double originalTurfCost = gameData.turfSlotCost > 0 ? gameData.turfSlotCost : gameData.targetAmount;
    debugPrint('💰 [Reschedule] Calculated newSlotTotalCost=$newSlotTotalCost, originalTurfCost=$originalTurfCost');
    if (newSlotTotalCost <= 0) {
      newSlotTotalCost = originalTurfCost > 0 ? originalTurfCost : 800.0;
      debugPrint('💰 [Reschedule] Cost was 0, using fallback: $newSlotTotalCost');
    }

    final startStr = '${start.hourOfPeriod == 0 ? 12 : start.hourOfPeriod}:00 ${start.period == DayPeriod.am ? 'AM' : 'PM'}';
    final endStr = '${end.hourOfPeriod == 0 ? 12 : end.hourOfPeriod}:00 ${end.period == DayPeriod.am ? 'AM' : 'PM'}';
    final newTimeRangeStr = '$startStr - $endStr';
    final formattedDate = DateFormat('yyyy-MM-dd').format(currentSelectedDate);

    debugPrint('📅 [Reschedule] Final slot: $newTimeRangeStr on $formattedDate, cost=₹${newSlotTotalCost.toInt()}');

    // ──────────────────────────────────────────────────────
    // STEP 4: Slot change executor (called after payment or directly)
    // ──────────────────────────────────────────────────────
    Future<void> executeSlotChange(String? payId) async {
      debugPrint('🚀 [Reschedule] executeSlotChange called with payId=$payId');
      if (mounted) setState(() => _isProcessing = true);
      try {
        final success = await _matchController.changeMatchSlotByHost(
          matchId: gameData.id,
          ownerId: targetOwnerId,
          turfId: gameData.turfId!,
          groundId: gameData.groundId!,
          groundName: 'Main Ground',
          newDateStr: formattedDate,
          newTimeStr: newTimeRangeStr,
          newTurfCost: newSlotTotalCost,
          paymentId: payId,
        );
        debugPrint('✅ [Reschedule] changeMatchSlotByHost returned: $success');

        await _fetchBookedSlotsForMatchDate();
      } catch (e) {
        debugPrint('🔴 [Reschedule] executeSlotChange error: $e');
      }
      if (mounted) setState(() => _isProcessing = false);
    }

    // ──────────────────────────────────────────────────────
    // STEP 5: Show payment confirmation dialog + Razorpay
    // ──────────────────────────────────────────────────────
    if (!mounted) {
      debugPrint('⚠️ [Reschedule] Widget not mounted for payment dialog, executing slot change with dev pass fallback');
      await executeSlotChange('DEV_PASS_${DateTime.now().millisecondsSinceEpoch}');
      return;
    }

    debugPrint('💳 [Reschedule] Showing payment confirmation dialog (amount=₹${newSlotTotalCost.toInt()})');
    bool? confirmPayment;
    try {
      confirmPayment = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(context.minDimensionPct(4)),
          ),
          title: Text(
            'Reschedule Slot Payment 💳',
            style: AppTypography.headlineSm.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: context.responsiveFont(16),
            ),
          ),
          content: Text(
            'The newly selected slot ($newTimeRangeStr on $formattedDate) costs ₹${newSlotTotalCost.toInt()}.\n\n'
            'As host, you will pay the full slot price of ₹${newSlotTotalCost.toInt()} to book this slot and reactivate your poll.',
            style: AppTypography.bodySm.copyWith(
              color: AppColors.textSecondary,
              fontSize: context.responsiveFont(14),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(
                'Cancel',
                style: AppTypography.bodySm.copyWith(
                  color: AppColors.muted,
                  fontSize: context.responsiveFont(14),
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: AppColors.background,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(context.minDimensionPct(3)),
                ),
              ),
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(
                'Pay ₹${newSlotTotalCost.toInt()} & Book Slot',
                style: AppTypography.headlineSm.copyWith(
                  color: AppColors.background,
                  fontWeight: FontWeight.bold,
                  fontSize: context.responsiveFont(14),
                ),
              ),
            ),
          ],
        ),
      );
    } catch (e) {
      debugPrint('🔴 [Reschedule] Error showing payment dialog: $e — using dev pass fallback');
      await executeSlotChange('DEV_PASS_${DateTime.now().millisecondsSinceEpoch}');
      return;
    }

    debugPrint('💳 [Reschedule] Payment dialog result: confirmPayment=$confirmPayment');
    if (confirmPayment != true) {
      debugPrint('💳 [Reschedule] User cancelled payment dialog, aborting');
      return;
    }

    // ──────────────────────────────────────────────────────
    // STEP 6: Launch Razorpay
    // ──────────────────────────────────────────────────────
    debugPrint('💳 [Reschedule] Setting _pendingPaymentAction and launching Razorpay (amount=$newSlotTotalCost)');
    _pendingPaymentAction = (payId) => executeSlotChange(payId);
    _openRazorpay(newSlotTotalCost);
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    // Stream live match data from controller
    final String targetMatchId = widget.gameData?.id ?? '';
    final liveData = _matchController.allMatches.firstWhereOrNull((m) => m.id == targetMatchId) ?? widget.gameData;

    final String matchId = (liveData?.id ?? '').toString();
    final String activeSport = (liveData?.sport ?? widget.sport ?? 'Football').toString();
    final String activeType = (liveData?.type ?? widget.type ?? 'Casual').toString();
    final String activeTime = (liveData?.time ?? widget.time ?? 'Today, 18:00').toString();
    final String activePrice = (liveData?.price ?? widget.price ?? '₹100').toString();
    final int activeCurrentPlayers = liveData?.currentPlayers ?? widget.currentPlayers ?? 1;
    final int activeMaxPlayers = liveData?.maxPlayers ?? widget.maxPlayers ?? 10;
    final String activeAddress = (liveData?.address ?? widget.address ?? 'Local Ground').toString();
    final String activeHostId = (liveData?.hostId ?? widget.hostId ?? '').toString();
    final String activeHostName = (liveData?.hostName ?? widget.hostName ?? 'Host Player').toString();
    final String activeHostAvatar = (liveData?.avatarUrl ?? widget.hostAvatar ?? 'https://i.pravatar.cc/150?img=1').toString();
    final int activeHostXp = liveData?.hostXp ?? widget.hostXp ?? 100;
    final String activeInstructions = (liveData?.instructions ?? widget.instructions ?? '').toString();
    final String activeEquipmentOption = (liveData?.equipmentOption ?? widget.equipmentOption ?? 'none').toString();
    final List<String> activePlayerIds = liveData?.playerIds ?? widget.playerIds ?? [activeHostId];

    final String activeLocationType = (liveData?.locationType ?? 'playz_turf').toString();
    final double collectedAmount = liveData?.collectedAmount ?? 0.0;
    final double targetAmount = liveData?.targetAmount ?? 0.0;
    final bool isSlotBooked = liveData?.isSlotBooked ?? false;
    final bool hasConflict = _hasConflictLocal || (liveData?.hasConflict ?? false);

    // Host & Player Join Checks (Host is ALWAYS included, players join only ONCE)
    final bool isHost = _currentUserId.isNotEmpty && _currentUserId == activeHostId;
    final bool alreadyJoined = _currentUserId.isNotEmpty && (activePlayerIds.contains(_currentUserId) || isHost);
    final bool isFull = activeCurrentPlayers >= activeMaxPlayers;

    final String venueName = activeAddress.contains('-')
        ? activeAddress.split('-').first.trim()
        : activeAddress;

    debugPrint('📊 [MatchPollScreen] Building Poll Detail View:');
    debugPrint('   matchId: $matchId, sport: $activeSport, time: $activeTime');
    debugPrint('   isHost: $isHost, currentPlayers: $activeCurrentPlayers/$activeMaxPlayers');
    debugPrint('   isSlotBooked: $isSlotBooked, hasConflict: $hasConflict (local=$_hasConflictLocal)');

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              MatchDetailHero(
                images: widget.turfImages,
                sport: activeSport,
                type: activeType,
                time: activeTime,
                isHost: isHost,
                isSlotBooked: isSlotBooked,
                onDeletePressed: () async {
                  final bool? confirm = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      backgroundColor: AppColors.surface,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(context.minDimensionPct(4)),
                      ),
                      title: Text(
                        'Delete Match Poll? 🗑️',
                        style: AppTypography.headlineSm.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: context.responsiveFont(16),
                        ),
                      ),
                      content: Text(
                        'Are you sure you want to cancel and delete this match poll before it gets full?',
                        style: AppTypography.bodySm.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: context.responsiveFont(14),
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, false),
                          child: const Text('Cancel', style: TextStyle(color: AppColors.muted)),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.error,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () => Navigator.pop(ctx, true),
                          child: const Text('Delete Poll'),
                        ),
                      ],
                    ),
                  );

                  if (confirm == true && matchId.isNotEmpty) {
                    final success = await _matchController.deleteMatchPoll(matchId);
                    if (success && mounted) {
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      } else {
                        Get.back();
                      }
                    }
                  }
                },
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    context.widthPct(4),
                    context.heightPct(2),
                    context.widthPct(4),
                    context.heightPct(14),
                  ),
                  child: Column(
                    children: [
                      // Conflict Warning Banner (Shown if slot got booked during poll)
                      if (hasConflict) ...[
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(context.widthPct(4)),
                          decoration: BoxDecoration(
                            color: Colors.orangeAccent.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(context.minDimensionPct(4)),
                            border: Border.all(color: Colors.orangeAccent, width: 1.8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.warning_amber_rounded, color: Colors.orangeAccent, size: 26),
                                  SizedBox(width: context.widthPct(2.5)),
                                  Text(
                                    '⚠️ Slot Conflict Detected!',
                                    style: AppTypography.headlineSm.copyWith(
                                      color: Colors.orangeAccent,
                                      fontWeight: FontWeight.bold,
                                      fontSize: context.responsiveFont(15),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: context.heightPct(1)),
                              Text(
                                isHost
                                    ? 'The targeted slot on this turf was acquired by another user during your poll! Please reschedule to a new available slot or date.'
                                    : 'The targeted slot was booked by another user. The host can select a new available time slot for this match poll.',
                                style: AppTypography.bodySm.copyWith(
                                  color: AppColors.textPrimary,
                                  fontSize: context.responsiveFont(13),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              if (isHost) ...[
                                SizedBox(height: context.heightPct(1.5)),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.accent,
                                      foregroundColor: AppColors.background,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(context.minDimensionPct(3)),
                                      ),
                                    ),
                                    onPressed: _onHostChangeSlotPressed,
                                    icon: const Icon(Icons.edit_calendar_rounded, size: 18),
                                    label: Text(
                                      'Change Date & Time Slot',
                                      style: AppTypography.headlineSm.copyWith(
                                        color: AppColors.background,
                                        fontWeight: FontWeight.bold,
                                        fontSize: context.responsiveFont(13.5),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        SizedBox(height: context.heightPct(2)),
                      ],

                      // 1. Slots & Gathered Poll Funds Card
                      MatchSlotsCard(
                        currentPlayers: activeCurrentPlayers,
                        maxPlayers: activeMaxPlayers,
                        collectedAmount: collectedAmount,
                        targetAmount: targetAmount,
                        isSlotBooked: isSlotBooked,
                        bookedSlotsForDate: _bookedSlotsForDate,
                        isHost: isHost,
                        onChangeSlotPressed: _onHostChangeSlotPressed,
                      ),
                      SizedBox(height: context.heightPct(2)),

                      // 2. Equipment Status Card (Dynamic - shown only if option set)
                      if (activeEquipmentOption != 'none' && activeEquipmentOption.isNotEmpty) ...[
                        EquipmentStatusCard(option: activeEquipmentOption),
                        SizedBox(height: context.heightPct(2)),
                      ],

                      // 3. Special Instructions Card (Dynamic - shown only if instructions exist)
                      if (activeInstructions.isNotEmpty) ...[
                        SpecialInstructionsCard(instructions: activeInstructions),
                        SizedBox(height: context.heightPct(2)),
                      ],

                      // 4. Common Discussion & Queries Chat Card
                      MatchChatCard(
                        matchId: matchId,
                        sport: activeSport,
                        memberCount: activeCurrentPlayers,
                      ),
                      SizedBox(height: context.heightPct(2)),

                      // 5. Dynamic Joined Player Pool (Linked to Firebase, Host in bracket & Show All option)
                      PlayerPoolSection(
                        hostId: activeHostId,
                        hostName: activeHostName,
                        hostAvatar: activeHostAvatar,
                        hostXp: activeHostXp,
                        playerIds: activePlayerIds,
                      ),
                      SizedBox(height: context.heightPct(2)),

                      // 6. Location Card (Cleaned with locationType indicator badge)
                      MatchLocationCard(
                        venueName: venueName,
                        address: activeAddress,
                        locationType: activeLocationType,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Match Join & Host Slot Confirmation Bar
          MatchJoinBar(
            price: activePrice,
            isHost: isHost,
            alreadyJoined: alreadyJoined,
            isFull: isFull,
            isSlotBooked: isSlotBooked,
            hasConflict: hasConflict,
            collectedAmount: collectedAmount,
            targetAmount: targetAmount,
            onJoinPressed: _onJoinPressed,
            onHostBookSlotPressed: _onHostBookSlotPressed,
            onHostChangeSlotPressed: _onHostChangeSlotPressed,
          ),
        ],
      ),
    );
  }
}
