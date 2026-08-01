import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:redesign/view/USER/Book/payment_success/payment_success_screen.dart';
import 'package:redesign/controller/User_Controller/Booking_Controller/booking_controller.dart';
import 'package:redesign/model/User_Models/Booking_Models/slot_model.dart';
import 'package:redesign/shared_preferences/userPreferences.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/utils/slot_overlap_helper.dart';
import 'package:redesign/services/xp_reward_service.dart';

import 'widgets/availability_timeline.dart';
import 'widgets/booking_dropdowns.dart';
import 'widgets/booking_summary.dart';
import 'widgets/booking_time_pickers.dart';
import 'widgets/confirmation_bottom_bar.dart';
import 'widgets/date_selector.dart';
import 'widgets/sport_selector.dart';
import 'widgets/slot_matrix_bottom_sheet.dart';
import 'widgets/venue_policy_box.dart';
import 'package:redesign/theme/responsive_helper.dart';

class ConfirmSlotScreen extends StatefulWidget {
  const ConfirmSlotScreen({super.key});

  @override
  State<ConfirmSlotScreen> createState() => _ConfirmSlotScreenState();
}

class _ConfirmSlotScreenState extends State<ConfirmSlotScreen> {
  final BookingController _bookingController = Get.find<BookingController>();
  late Razorpay _razorpay;

  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  final ValueNotifier<bool> _isBottomBarVisible = ValueNotifier(true);
  late final ScrollController _timelineController;

  DateTime? selectedDate;
  String? selectedGround;
  String? selectedSize;
  String? selectedSport;

  /// Dynamic options from the controller
  List<String> get _sportOptions => _bookingController.turfSports;
  List<String> get _groundOptions => _bookingController.groundNames;
  List<String> get _dimensionOptions => _bookingController.dimensionOptions;

  bool get _isReadyToPay {
    if (selectedDate == null) return false;
    if (selectedSport == null) return false;
    if (selectedGround == null || selectedGround!.isEmpty) return false;
    if (_startTime == null || _endTime == null) return false;
    int startMin = _startTime!.hour * 60 + _startTime!.minute;
    int endMin = _endTime!.hour * 60 + _endTime!.minute;
    if (endMin <= startMin && _endTime!.hour == 0) {
      endMin += 1440;
    }
    return endMin > startMin;
  }

  double get _totalAmount {
    final ground = _bookingController.selectedGround.value;
    final basePrice = ground?.defaultPrice ?? 1000.0;
    int hours = 1;
    if (_startTime != null && _endTime != null) {
      int startMin = _startTime!.hour * 60 + _startTime!.minute;
      int endMin = _endTime!.hour * 60 + _endTime!.minute;
      if (endMin <= startMin && _endTime!.hour == 0) {
        endMin += 1440;
      }
      hours = ((endMin - startMin) / 60).round();
      if (hours <= 0) hours = 1;
    }
    return basePrice * hours;
  }

  Worker? _slotsWorker;

  @override
  void initState() {
    super.initState();
    _timelineController = ScrollController();

    // Razorpay Initialization
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    // Auto-scroll when reactive slots finish loading
    _slotsWorker = ever(_bookingController.slots, (_) {
      Future.delayed(const Duration(milliseconds: 150), () {
        _autoScrollToNextHour();
      });
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _waitForTimelineAndScroll();
    });
  }

  @override
  void dispose() {
    _slotsWorker?.dispose();
    _timelineController.dispose();
    _isBottomBarVisible.dispose();
    _razorpay.clear();
    super.dispose();
  }

  void _waitForTimelineAndScroll() {
    if (!_timelineController.hasClients) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _waitForTimelineAndScroll(),
      );
      return;
    }
    _autoScrollToNextHour();
  }

  void _autoScrollToNextHour() {
    if (!_timelineController.hasClients) return;

    final now = DateTime.now();
    final currentHour = now.hour;

    int index = -1;
    if (_bookingController.slots.isNotEmpty) {
      final sortedSlots = List<SlotModel>.from(_bookingController.slots)
        ..sort((a, b) => (a.startHour ?? 0).compareTo(b.startHour ?? 0));

      final foundIdx = sortedSlots
          .indexWhere((s) => (s.startHour ?? 0) >= currentHour);
      if (foundIdx != -1) {
        index = foundIdx;
      } else {
        index = sortedSlots.length - 1;
      }
    }

    if (index == -1) {
      index = currentHour.clamp(0, 23);
    }

    final double slotWidth = context.widthPct(28).clamp(90.0, 130.0);
    final double separatorWidth = context.widthPct(0.5);
    final double itemExtent = slotWidth + separatorWidth;

    double offset = index * itemExtent;

    final viewportWidth = _timelineController.position.viewportDimension;
    offset -= (viewportWidth - slotWidth) / 2;

    offset = offset.clamp(
      _timelineController.position.minScrollExtent,
      _timelineController.position.maxScrollExtent,
    );

    _timelineController.animateTo(
      offset,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
    );
  }

  void _onGroundSelected(String groundName) {
    setState(() => selectedGround = groundName);

    final dateStr = selectedDate != null
        ? DateFormat('yyyy-MM-dd').format(selectedDate!)
        : DateFormat('yyyy-MM-dd').format(DateTime.now());

    final ground = _bookingController.grounds
        .firstWhereOrNull((g) => g.name == groundName);
    if (ground != null) {
      _bookingController.setSelectedGround(ground, dateStr: dateStr);
    }
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      extendBody: true,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: const BackButton(color: AppColors.textPrimary),
        title: Obx(() {
          final turfName = _bookingController.selectedTurf.value?.turfName ?? 'Confirm Slot';
          return Text(
            turfName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.displayLg.copyWith(
              color: AppColors.textPrimary,
              fontSize: context.responsiveFont(18),
              fontWeight: FontWeight.bold,
            ),
          );
        }),
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification.depth != 0) return false;

          if (notification.metrics.extentAfter < 60) {
            if (!_isBottomBarVisible.value) {
              _isBottomBarVisible.value = true;
            }
            return false;
          }

          if (notification is UserScrollNotification) {
            if (notification.direction == ScrollDirection.reverse) {
              if (_isBottomBarVisible.value) {
                _isBottomBarVisible.value = false;
              }
            } else if (notification.direction == ScrollDirection.forward) {
              if (!_isBottomBarVisible.value) {
                _isBottomBarVisible.value = true;
              }
            }
          }
          return false;
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(0, 0, 0, context.heightPct(14)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DateSelector(
                selectedDate: selectedDate,
                onDateSelected: (date) {
                  setState(() => selectedDate = date);
                  final turf = _bookingController.selectedTurf.value;
                  final ground = _bookingController.selectedGround.value;
                  if (turf != null && ground != null) {
                    final dateStr = DateFormat('yyyy-MM-dd').format(date);
                    _bookingController.fetchGroundSlots(
                      turf.ownerId,
                      turf.id,
                      ground.id,
                      dateStr: dateStr,
                    );
                  }
                },
              ),
              SizedBox(height: context.heightPct(2.5)),

              const _SectionTitle(text: 'Sport & Ground'),
              SizedBox(height: context.heightPct(1)),
              SportSelector(
                sports: _sportOptions,
                selectedSport: selectedSport,
                onSportSelected: (sport) => setState(() => selectedSport = sport),
              ),
              SizedBox(height: context.heightPct(2)),
              Obx(() => BookingDropdowns(
                selectedType: selectedGround,
                selectedSize: selectedSize,
                typeLabel: 'Ground',
                sizeLabel: 'Size',
                typeOptions: _groundOptions,
                sizeOptions: _dimensionOptions,
                isLoadingTypes: _bookingController.isLoadingGrounds.value,
                onTypeSelected: _onGroundSelected,
                onSizeSelected: (v) => setState(() => selectedSize = v),
              )),
              SizedBox(height: context.heightPct(2.5)),

              Obx(() => AvailabilityTimeline(
                controller: _timelineController,
                slots: _bookingController.slots,
                isLoading: _bookingController.isLoadingSlots.value,
                selectedDate: selectedDate,
              )),
              SizedBox(height: context.heightPct(2.5)),

              BookingTimePickers(
                startTime: _startTime,
                endTime: _endTime,
                onPickStartTime: () => _pickTime(isStart: true),
                onPickEndTime: () => _pickTime(isStart: false),
              ),
              SizedBox(height: context.heightPct(2.5)),

              /// VENUE POLICY CARD DIRECTLY ABOVE LAST BILL
              const VenuePolicyBox(),
              SizedBox(height: context.heightPct(2.5)),

              Obx(() => BookingSummary(
                slotPrice: _bookingController.selectedGround.value?.defaultPrice ?? 0,
                hours: (_endTime != null && _startTime != null)
                    ? (() {
                        int startMin = _startTime!.hour * 60 + _startTime!.minute;
                        int endMin = _endTime!.hour * 60 + _endTime!.minute;
                        if (endMin <= startMin && _endTime!.hour == 0) endMin += 1440;
                        return ((endMin - startMin) / 60).round().clamp(1, 24);
                      })()
                    : 1,
              )),
            ],
          ),
        ),
      ),
      bottomNavigationBar: ValueListenableBuilder<bool>(
        valueListenable: _isBottomBarVisible,
        builder: (context, visible, child) {
          return AnimatedSlide(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            offset: visible ? Offset.zero : const Offset(0, 1.5),
            child: child,
          );
        },
        child: ConfirmationBottomBar(
          enabled: _isReadyToPay,
          totalAmount: _totalAmount.toInt(),
          onPayPressed: _onPayPressed,
        ),
      ),
    );
  }

  void _onPayPressed() => _openRazorpay();

  Future<void> _openRazorpay() async {
    if (!_isReadyToPay) {
      Get.snackbar(
        'Incomplete Details',
        'Please select Date, Sport, Ground, and Time Slot before proceeding.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.error,
        colorText: AppColors.textPrimary,
      );
      return;
    }

    final turf = _bookingController.selectedTurf.value;
    final ground = _bookingController.selectedGround.value;
    final user = FirebaseAuth.instance.currentUser;

    if (turf != null && ground != null && selectedDate != null && _startTime != null && _endTime != null) {
      final dateStr = DateFormat('yyyy-MM-dd').format(selectedDate!);
      final startTimeStr = '${_startTime!.hourOfPeriod == 0 ? 12 : _startTime!.hourOfPeriod}:00 ${_startTime!.period == DayPeriod.am ? 'AM' : 'PM'}';
      final endTimeStr = '${_endTime!.hourOfPeriod == 0 ? 12 : _endTime!.hourOfPeriod}:00 ${_endTime!.period == DayPeriod.am ? 'AM' : 'PM'}';
      final timeRangeStr = '$startTimeStr - $endTimeStr';

      final isOverlapping = await SlotOverlapHelper.isSlotOverlappingInFirestore(
        ownerId: turf.ownerId,
        turfId: turf.id,
        groundId: ground.id,
        dateStr: dateStr,
        newTimeRangeStr: timeRangeStr,
      );

      if (isOverlapping) {
        Get.snackbar(
          'Slot Unavailable',
          'The selected slot ($timeRangeStr) overlaps with an existing booking! Please choose another slot.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.error,
          colorText: AppColors.textPrimary,
          duration: const Duration(seconds: 4),
        );
        return;
      }
    }

    var options = {
      'key': 'rzp_test_THjDLg1t3KW9ib',
      'amount': (_totalAmount * 100).toInt(),
      'name': turf?.turfName ?? 'PlayZ Turf Booking',
      'description': '${selectedSport ?? "Turf"} - ${ground?.name ?? "Ground"}',
      'prefill': {
        'contact': user?.phoneNumber ?? '9876543210',
        'email': user?.email ?? 'user@playz.com',
      },
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint("Error launching Razorpay: $e");
      Get.snackbar("Payment Error", "Could not launch Razorpay: $e");
    }
  }

  Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
    final user = FirebaseAuth.instance.currentUser;
    final userDocId = await UserPreferences.getDocId() ?? user?.email ?? user?.uid ?? 'guest_user';
    final userId = user?.uid ?? 'guest_user';
    final turf = _bookingController.selectedTurf.value;
    final ground = _bookingController.selectedGround.value;

    final ownerId = turf?.ownerId ?? 'unknown_owner';
    final turfId = turf?.id ?? 'unknown_turf';
    final groundId = ground?.id ?? 'unknown_ground';

    final bookingId = 'PLZ_${DateTime.now().millisecondsSinceEpoch}';
    final otp = (100000 + Random().nextInt(900000)).toString();

    final userName = user?.displayName ?? 'Player';
    final userPhone = user?.phoneNumber ?? 'N/A';
    final currentTimeStr = DateTime.now().toIso8601String();

    final dateStr = selectedDate != null
        ? DateFormat('yyyy-MM-dd').format(selectedDate!)
        : DateFormat('yyyy-MM-dd').format(DateTime.now());
    final dateFormatted = selectedDate != null
        ? DateFormat('EEE, dd MMM yyyy').format(selectedDate!)
        : DateFormat('EEE, dd MMM yyyy').format(DateTime.now());

    final startTimeStr = _formatTimeOfDay(_startTime!);
    final endTimeStr = _formatTimeOfDay(_endTime!);

    final rawPayload = jsonEncode({
      'bookingId': bookingId,
      'otp': otp,
      'userName': userName,
      'userPhone': userPhone,
      'userEmail': user?.email ?? '',
      'turfId': turfId,
      'groundId': groundId,
      'date': dateStr,
      'timeSlot': '$startTimeStr – $endTimeStr',
      'timestamp': currentTimeStr,
    });

    final encodedQrText = 'PZSEC_${base64Encode(utf8.encode(rawPayload))}';

    final effectiveSport = (selectedSport != null && selectedSport!.trim().isNotEmpty)
        ? selectedSport!.trim()
        : (_bookingController.turfSports.isNotEmpty
            ? _bookingController.turfSports.first
            : 'Cricket');

    final bookingMap = {
      'id': bookingId,
      'bookingId': bookingId,
      'otp': otp,
      'qrData': encodedQrText,
      'userId': userId,
      'userEmail': user?.email ?? '',
      'userName': userName,
      'userPhone': userPhone,
      'ownerId': ownerId,
      'turfId': turfId,
      'turfName': turf?.turfName ?? 'PlayZ Arena',
      'turfAddress': (turf?.fullAddress.isNotEmpty == true) ? turf!.fullAddress : 'Local Turf Arena',
      'turfImage': (turf?.allImages.isNotEmpty == true) ? turf!.allImages.first : 'https://images.unsplash.com/photo-1517927033932-b3d18e61fb3a',
      'groundId': groundId,
      'groundName': ground?.name ?? selectedGround ?? 'Ground 1',
      'sport': effectiveSport,
      'date': dateStr,
      'dateFormatted': dateFormatted,
      'startTime': startTimeStr,
      'endTime': endTimeStr,
      'timeSlot': '$startTimeStr – $endTimeStr',
      'amount': _totalAmount.toInt(),
      'paymentId': response.paymentId ?? '',
      'status': 'upcoming',
      'bookingType': 'Online App',
      'createdAt': FieldValue.serverTimestamp(),
    };

    try {
      final batch = FirebaseFirestore.instance.batch();

      final userBookingRef = FirebaseFirestore.instance
          .collection('User')
          .doc(userDocId)
          .collection('bookings')
          .doc(bookingId);
      batch.set(userBookingRef, bookingMap, SetOptions(merge: true));

      if (ownerId.isNotEmpty && turfId.isNotEmpty) {
        final ownerTurfBookingRef = FirebaseFirestore.instance
            .collection('owners')
            .doc(ownerId)
            .collection('turfs')
            .doc(turfId)
            .collection('bookings')
            .doc(bookingId);
        batch.set(ownerTurfBookingRef, bookingMap, SetOptions(merge: true));

        final ownerBookingRef = FirebaseFirestore.instance
            .collection('owners')
            .doc(ownerId)
            .collection('bookings')
            .doc(bookingId);
        batch.set(ownerBookingRef, bookingMap, SetOptions(merge: true));
      }

      await batch.commit();

      // Award +50 XP for successful slot booking to the specific sport counter
      await XpRewardService.awardBookingXp(
        userDocId: userDocId,
        sport: effectiveSport,
        xpAmount: 50,
      );

      Get.snackbar(
        'Booking Confirmed! 🎉',
        'Your QR entry ticket is saved in Bookings!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.accent,
        colorText: AppColors.background,
        duration: const Duration(seconds: 4),
      );

      Get.offAll(() => BookingConfirmationScreen(bookingData: bookingMap));

    } catch (e) {
      debugPrint("Error saving booking to Firestore: $e");
      Get.snackbar("Booking Error", "Failed to sync booking data: $e");
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Get.snackbar(
      'Payment Cancelled / Failed',
      response.message ?? 'Payment process was interrupted.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.error,
      colorText: AppColors.textPrimary,
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Get.snackbar('Wallet Selected', response.walletName ?? '');
  }

  String _formatTimeOfDay(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    final hourStr = hour < 10 ? '0$hour' : '$hour';
    return '$hourStr:00 $period';
  }

  void _scrollToSelectedStartHour(int startHour) {
    if (!_timelineController.hasClients) return;

    int index = -1;
    if (_bookingController.slots.isNotEmpty) {
      final sortedSlots = List<SlotModel>.from(_bookingController.slots)
        ..sort((a, b) => (a.startHour ?? 0).compareTo(b.startHour ?? 0));

      final foundIdx = sortedSlots
          .indexWhere((s) => (s.startHour ?? 0) >= startHour);
      if (foundIdx != -1) {
        index = foundIdx;
      } else {
        index = sortedSlots.length - 1;
      }
    }

    if (index == -1) {
      index = startHour.clamp(0, 23);
    }

    final double slotWidth = context.widthPct(28).clamp(90.0, 130.0);
    final double separatorWidth = context.widthPct(0.5);
    final double itemExtent = slotWidth + separatorWidth;

    double offset = index * itemExtent;

    final viewportWidth = _timelineController.position.viewportDimension;
    offset -= (viewportWidth - slotWidth) / 2;

    offset = offset.clamp(
      _timelineController.position.minScrollExtent,
      _timelineController.position.maxScrollExtent,
    );

    _timelineController.animateTo(
      offset,
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeOutCubic,
    );
  }

  Future<void> _pickTime({required bool isStart}) async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return SlotMatrixBottomSheet(
          isStart: isStart,
          startTime: _startTime,
          selectedTime: isStart ? _startTime : _endTime,
          selectedDate: selectedDate,
          slots: _bookingController.slots,
          onSlotSelected: (picked) {
            setState(() {
              if (isStart) {
                _startTime = picked;
                _endTime = TimeOfDay(
                  hour: (_startTime!.hour + 1) % 24,
                  minute: 0,
                );
                _scrollToSelectedStartHour(picked.hour);
              } else {
                _endTime = picked;
              }
            });

            if (isStart) {
              Future.delayed(const Duration(milliseconds: 250), () {
                if (mounted) {
                  _pickTime(isStart: false);
                }
              });
            }
          },
        );
      },
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle({required this.text});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.widthPct(4)),
      child: Text(
        text,
        style: AppTypography.headlineSm.copyWith(
          color: AppColors.textPrimary,
          fontSize: context.responsiveFont(18),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
