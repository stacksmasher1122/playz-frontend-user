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

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _loadCurrentUserId();
    _fetchBookedSlotsForMatchDate();
  }

  Future<void> _fetchBookedSlotsForMatchDate() async {
    final gameData = widget.gameData;
    if (gameData == null || gameData.turfId == null || gameData.groundId == null) return;

    final parts = gameData.time.split(',');
    final dateStr = gameData.date.isNotEmpty ? gameData.date : parts.first.trim();
    if (dateStr.isEmpty) return;

    try {
      final List<String> bookedList = [];

      final groupSnap = await FirebaseFirestore.instance
          .collectionGroup('bookings')
          .where('date', isEqualTo: dateStr)
          .get();

      for (var doc in groupSnap.docs) {
        final data = doc.data();
        final status = (data['status'] ?? '').toString().toLowerCase();
        if (status == 'cancelled') continue;

        final bTurfId = (data['turfId'] ?? '').toString();
        if (bTurfId.isNotEmpty && bTurfId != gameData.turfId!) continue;

        final bGroundId = (data['groundId'] ?? '').toString();
        if (bGroundId.isNotEmpty && bGroundId != gameData.groundId!) continue;

        final timeStr = (data['time'] ?? data['timeSlot'] ?? '${data['startTime']} - ${data['endTime']}').toString();
        if (timeStr.isNotEmpty && !bookedList.contains(timeStr)) {
          bookedList.add(timeStr);
        }
      }

      final matchSnap = await FirebaseFirestore.instance
          .collection('matches')
          .where('turfId', isEqualTo: gameData.turfId!)
          .where('groundId', isEqualTo: gameData.groundId!)
          .where('date', isEqualTo: dateStr)
          .where('isSlotBooked', isEqualTo: true)
          .get();

      for (var doc in matchSnap.docs) {
        if (doc.id == gameData.id) continue;
        final data = doc.data();
        final timeStr = (data['time'] ?? '').toString();
        if (timeStr.isNotEmpty && !bookedList.contains(timeStr)) {
          bookedList.add(timeStr);
        }
      }

      if (mounted) {
        setState(() {
          _bookedSlotsForDate = bookedList;
        });
      }
    } catch (e) {
      debugPrint('⚠️ Error fetching booked slots for match date: $e');
    }
  }

  @override
  void dispose() {
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

  void _onJoinPressed() {
    if (_isProcessing) return;

    final gameData = widget.gameData;
    if (gameData == null) return;

    final double priceVal = gameData.priceNum.toDouble();
    _pendingPaymentAction = (payId) => _processJoinPoll(paymentId: payId);

    if (priceVal > 0) {
      _openRazorpay(priceVal);
    } else {
      _processJoinPoll();
    }
  }

  void _openRazorpay(double amount) {
    setState(() => _isProcessing = true);

    final user = FirebaseAuth.instance.currentUser;
    final phone = (_profileController.rxUser.value?.secondaryPhone.isNotEmpty ?? false)
        ? _profileController.rxUser.value!.secondaryPhone
        : (user?.phoneNumber ?? '9876543210');
    final email = _profileController.userEmail.isNotEmpty
        ? _profileController.userEmail
        : user?.email ?? 'player@playz.com';

    final razorpayKey = dotenv.env['RAZORPAY_KEY_ID'] ?? 'rzp_test_THjDLg1t3KW9ib';

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

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error launching Razorpay: $e');
      _processJoinPoll(paymentId: 'DEV_PASS_${DateTime.now().millisecondsSinceEpoch}');
    }
  }

  Future<void> _processJoinPoll({String? paymentId}) async {
    final gameData = widget.gameData;
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
    final gameData = widget.gameData;
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
    final gameData = widget.gameData;
    if (gameData == null || gameData.turfId == null || gameData.groundId == null) return;

    final targetOwnerId = gameData.ownerId.isNotEmpty ? gameData.ownerId : 'owner_${gameData.turfId}';
    final parts = gameData.time.split(',');
    String currentDateStr = gameData.date.isNotEmpty ? gameData.date : parts.first.trim();
    DateTime currentSelectedDate = DateTime.tryParse(currentDateStr) ?? DateTime.now();
    currentDateStr = DateFormat('yyyy-MM-dd').format(currentSelectedDate);

    setState(() => _isProcessing = true);

    // Fetch slots dynamically for currentSelectedDate AND AWAIT BEFORE OPENING SHEET!
    await _bookingController.fetchGroundSlots(
      targetOwnerId,
      gameData.turfId!,
      gameData.groundId!,
      dateStr: currentDateStr,
    );

    setState(() => _isProcessing = false);

    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => StatefulBuilder(
        builder: (context, setSheetState) {
          return SlotMatrixBottomSheet(
            isStart: true,
            startTime: null,
            selectedTime: null,
            selectedDate: currentSelectedDate,
            slots: _bookingController.slots,
            onDateChanged: (newDate) async {
              final newDateStr = DateFormat('yyyy-MM-dd').format(newDate);
              currentSelectedDate = newDate;
              currentDateStr = newDateStr;

              await _bookingController.fetchGroundSlots(
                targetOwnerId,
                gameData.turfId!,
                gameData.groundId!,
                dateStr: newDateStr,
              );

              setSheetState(() {});
            },
            onSlotSelected: (pickedStart) {
              Navigator.pop(sheetContext); // Close Start Time Sheet
              final parentContext = context;

              // STEP 2: Open End Time Bottom Sheet
              Future.delayed(const Duration(milliseconds: 200), () {
                if (!mounted) return;
                showModalBottomSheet(
                  // ignore: use_build_context_synchronously
                  context: parentContext,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (endSheetContext) => SlotMatrixBottomSheet(
                    isStart: false,
                    startTime: pickedStart,
                    selectedTime: null,
                    selectedDate: currentSelectedDate,
                    slots: _bookingController.slots,
                    onSlotSelected: (pickedEnd) async {
                      Navigator.pop(endSheetContext); // Close End Time Sheet

                      await Future.delayed(const Duration(milliseconds: 300));
                      if (!mounted) return;

                      final startStr = '${pickedStart.hourOfPeriod == 0 ? 12 : pickedStart.hourOfPeriod}:00 ${pickedStart.period == DayPeriod.am ? 'AM' : 'PM'}';
                      final endStr = '${pickedEnd.hourOfPeriod == 0 ? 12 : pickedEnd.hourOfPeriod}:00 ${pickedEnd.period == DayPeriod.am ? 'AM' : 'PM'}';
                      final newTimeRangeStr = '$startStr - $endStr';
                      final formattedDate = DateFormat('yyyy-MM-dd').format(currentSelectedDate);

                      if (mounted) setState(() => _isProcessing = true);

                      // Calculate cost of newly selected slot(s)
                      double newSlotTotalCost = 0.0;
                      int startH = pickedStart.hour;
                      int endH = pickedEnd.hour;
                      int durationHours = (endH > startH) ? (endH - startH) : (24 - startH + endH);

                      for (int i = 0; i < durationHours; i++) {
                        int checkH = (startH + i) % 24;
                        final slotModel = _bookingController.slots.firstWhereOrNull((s) => s.startHour == checkH);
                        if (slotModel != null && slotModel.price > 0) {
                          newSlotTotalCost += slotModel.price;
                        }
                      }

                      final double originalTurfCost = gameData.turfSlotCost > 0 ? gameData.turfSlotCost : gameData.targetAmount;
                      if (newSlotTotalCost <= 0) {
                        newSlotTotalCost = originalTurfCost;
                      }

                      final double overheadPrice = newSlotTotalCost - originalTurfCost;

                      Future<void> executeSlotChange() async {
                        await _matchController.changeMatchSlotByHost(
                          matchId: gameData.id,
                          ownerId: targetOwnerId,
                          turfId: gameData.turfId!,
                          groundId: gameData.groundId!,
                          groundName: 'Main Ground',
                          newDateStr: formattedDate,
                          newTimeStr: newTimeRangeStr,
                          newTurfCost: newSlotTotalCost,
                        );

                        await _fetchBookedSlotsForMatchDate();

                        if (mounted) setState(() => _isProcessing = false);
                      }

                      if (overheadPrice > 0) {
                        // Confirm overhead payment with host
                        final bool? confirmPayment = await showDialog<bool>(
                          // ignore: use_build_context_synchronously
                          context: context,
                          builder: (ctx) => AlertDialog(
                            backgroundColor: AppColors.surface,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(context.minDimensionPct(4)),
                            ),
                            title: Text(
                              'Slot Price Overhead 💳',
                              style: AppTypography.headlineSm.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: context.responsiveFont(16),
                              ),
                            ),
                            content: Text(
                              'The newly selected time slot ($newTimeRangeStr) costs ₹${newSlotTotalCost.toInt()} (original: ₹${originalTurfCost.toInt()}).\n\n'
                              'You need to pay the remaining overhead balance of ₹${overheadPrice.toInt()} to book this slot.',
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
                                  'Pay Overhead & Book',
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

                        if (confirmPayment != true) {
                          if (mounted) setState(() => _isProcessing = false);
                          return;
                        }

                        _pendingPaymentAction = (payId) => executeSlotChange();
                        _openRazorpay(overheadPrice);
                      } else {
                        await executeSlotChange();
                      }
                    },
                  ),
                );
              });
            },
          );
        },
      ),
    );
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
    final bool hasConflict = liveData?.hasConflict ?? false;

    // Host & Player Join Checks (Host is ALWAYS included, players join only ONCE)
    final bool isHost = _currentUserId.isNotEmpty && _currentUserId == activeHostId;
    final bool alreadyJoined = _currentUserId.isNotEmpty && (activePlayerIds.contains(_currentUserId) || isHost);
    final bool isFull = activeCurrentPlayers >= activeMaxPlayers;

    final String venueName = activeAddress.contains('-')
        ? activeAddress.split('-').first.trim()
        : activeAddress;

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
                          padding: EdgeInsets.all(context.widthPct(3.5)),
                          decoration: BoxDecoration(
                            color: Colors.orangeAccent.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(context.minDimensionPct(3.5)),
                            border: Border.all(color: Colors.orangeAccent),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.warning_amber_rounded, color: Colors.orangeAccent, size: 24),
                              SizedBox(width: context.widthPct(2.5)),
                              Expanded(
                                child: Text(
                                  isHost
                                      ? 'Slot Conflict Detected: The original slot was booked by another user during the poll. Tap below to pick a new slot or date.'
                                      : 'Slot Conflict Detected: The host is selecting an available slot for this match poll.',
                                  style: AppTypography.bodySm.copyWith(
                                    color: AppColors.textPrimary,
                                    fontSize: context.responsiveFont(12),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
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
