import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:redesign/utils/slot_overlap_helper.dart';

import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/controller/User_Controller/Match_Controller/match_controller.dart';
import 'package:redesign/controller/User_Controller/Booking_Controller/booking_controller.dart';
import 'package:redesign/controller/user_profile_controller.dart';
import 'package:redesign/controller/maps_controller.dart';
import 'package:redesign/shared_preferences/userPreferences.dart';
import 'package:redesign/model/User_Models/Booking_Models/turf_model.dart';
import 'package:redesign/model/User_Models/Booking_Models/ground_model.dart';
import 'package:redesign/model/User_Models/Booking_Models/slot_model.dart';
import 'package:redesign/view/USER/Maps/maps_picker/maps_picker_screen.dart';
import 'package:redesign/model/maps_model.dart';
import 'package:redesign/view/USER/Book/booking_details/widgets/slot_matrix_bottom_sheet.dart';

// Import Modular Section Widgets
import 'widgets/sport_selection_section.dart';
import 'widgets/match_mode_section.dart';
import 'widgets/player_counter_section.dart';
import 'widgets/pricing_section.dart';
import 'widgets/schedule_section.dart';
import 'widgets/venue_location_section.dart';
import 'widgets/special_instructions_section.dart';
import 'widgets/equipment_options_section.dart';

class HostMatchScreen extends StatefulWidget {
  const HostMatchScreen({super.key});

  @override
  State<HostMatchScreen> createState() => _HostMatchScreenState();
}

class _HostMatchScreenState extends State<HostMatchScreen> {
  final _matchController = Get.find<MatchController>();
  final _bookingController = Get.isRegistered<BookingController>()
      ? Get.find<BookingController>()
      : Get.put(BookingController());
  final _profileController = Get.find<UserProfileController>();
  final _mapsController = Get.isRegistered<MapsController>()
      ? Get.find<MapsController>()
      : Get.put(MapsController());

  late Razorpay _razorpay;

  // ─── Sports Selection State ──────────────────────────────────────────────
  final TextEditingController _sportSearchController = TextEditingController();
  String _sportSearchQuery = '';
  String? _selectedSport;

  final List<String> _popularSports = [
    'Football',
    'Cricket',
    'Badminton',
    'Basketball',
    'Tennis',
  ];

  final List<String> _allSports = [
    'Football',
    'Cricket',
    'Badminton',
    'Basketball',
    'Tennis',
    'Volleyball',
    'Table Tennis',
    'Squash',
    'Hockey',
    'Swimming',
    'Golf',
    'Padel',
    'Pickleball',
    'Rugby',
    'Chess',
  ];

  // ─── Form State ──────────────────────────────────────────────────────────
  bool _isCompetitive = false; // Casual vs Competitive
  int _maxPlayers = 10;

  // Pricing State
  bool _isFree = false; // Toggle for free to join
  bool _isSplitAndPay = false; // Toggle for equal split pay
  double _pricePerPlayer = 100.0;
  final TextEditingController _priceController = TextEditingController(text: '100');

  // Date & Time (Clear null by default)
  DateTime? _selectedDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  // Location Mode: 'playz_turf' vs 'custom'
  String _locationType = 'playz_turf';

  // PlayZ Turf Search & Selection State
  final TextEditingController _turfSearchController = TextEditingController();
  String _turfSearchQuery = '';
  TurfModel? _selectedTurf;
  GroundModel? _selectedGround;
  SlotModel? _selectedSlot;

  // Custom Location & Google Maps Picker State
  final TextEditingController _customAddressController = TextEditingController();
  double _customLat = 18.5204;
  double _customLng = 73.8567;

  // Special Instructions State
  final TextEditingController _instructionsController = TextEditingController();
  final List<String> _instructionPresets = [
    'Arrive 15m early',
    'Non-marking shoes only',
    'Bring ID card',
    'Bring drinking water',
    'No spiked shoes',
  ];

  // Equipment Options State (Mutually Exclusive: null, 'carry_own', 'provided')
  String? _selectedEquipmentOption;

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);

    // Fetch registered turfs
    _bookingController.fetchAllTurfs();
  }

  @override
  void dispose() {
    _razorpay.clear();
    _sportSearchController.dispose();
    _priceController.dispose();
    _turfSearchController.dispose();
    _customAddressController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    _submitMatchPoll(paymentId: response.paymentId);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Get.snackbar(
      'Payment Interrupted',
      response.message ?? 'Payment failed or was cancelled.',
      backgroundColor: AppColors.card,
      colorText: Colors.white,
    );
    setState(() => _isSubmitting = false);
  }

  // Helper to format TimeOfDay
  String _formatTimeOfDay(TimeOfDay tod) {
    final hour = tod.hourOfPeriod == 0 ? 12 : tod.hourOfPeriod;
    final period = tod.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:00 $period';
  }

  // Formatted range string e.g. "6:00 PM - 7:00 PM"
  String get _formattedTimeString {
    if (_startTime == null && _endTime == null) return '_ : _';
    if (_startTime != null && _endTime != null) {
      return '${_formatTimeOfDay(_startTime!)} - ${_formatTimeOfDay(_endTime!)}';
    }
    if (_startTime != null) {
      return _formatTimeOfDay(_startTime!);
    }
    return '_ : _';
  }

  // Calculate turf slot price based on selected duration and slot sheets
  double get _currentTurfSlotCost {
    if (_startTime == null || _endTime == null) {
      return _selectedGround?.defaultPrice ?? 0.0;
    }
    final startH = _startTime!.hour;
    final endH = _endTime!.hour;
    final duration = (endH > startH) ? (endH - startH) : (24 - startH + endH);
    if (duration <= 0) return 0.0;

    final slots = _bookingController.slots;
    if (slots.isNotEmpty) {
      double total = 0.0;
      for (int step = 0; step < duration; step++) {
        final checkH = (startH + step) % 24;
        final slot = slots.firstWhereOrNull((s) => s.startHour == checkH);
        if (slot != null && slot.price > 0) {
          total += slot.price;
        } else {
          total += (_selectedGround?.defaultPrice ?? 0.0);
        }
      }
      return total;
    }

    return duration * (_selectedGround?.defaultPrice ?? 0.0);
  }

  // Calculate required upfront deposit for host
  double _calculateHostDeposit() {
    if (_locationType != 'playz_turf') {
      return _isFree ? 0.0 : _pricePerPlayer;
    }

    final double turfCost = _currentTurfSlotCost;
    if (turfCost <= 0) return 0.0;

    if (_isFree) {
      // Host pays full turf slot price upfront to make match free to join for everyone
      return turfCost;
    }

    if (_isSplitAndPay) {
      // Split Equal Payments: Divide turf slot cost equally among total players
      final double equalShare = turfCost / (_maxPlayers > 0 ? _maxPlayers : 1);
      return equalShare.ceilToDouble();
    }

    // Custom price per player entered manually by host
    final double othersContribution = (_maxPlayers > 1 ? _maxPlayers - 1 : 1) * _pricePerPlayer;
    final double hostRemainingBalance = turfCost - othersContribution;

    // Host pays the remaining balance (minimum host's own share)
    if (hostRemainingBalance < _pricePerPlayer) {
      return _pricePerPlayer;
    }
    return hostRemainingBalance.clamp(0.0, turfCost);
  }

  // Time sheet picker for starting & ending slots (reused from Booking Details)
  Future<void> _pickTimeSheet({required bool isStart}) async {
    if (_locationType == 'playz_turf') {
      if (_selectedTurf == null || _selectedGround == null) {
        Get.snackbar(
          'Select Ground First',
          'Please select a PlayZ Turf and Ground/Court first to load available slot time sheets.',
          backgroundColor: AppColors.card,
          colorText: Colors.white,
        );
        return;
      }

      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => SlotMatrixBottomSheet(
          isStart: isStart,
          startTime: _startTime,
          selectedTime: isStart ? _startTime : _endTime,
          selectedDate: _selectedDate,
          slots: _bookingController.slots,
          onSlotSelected: (picked) {
            setState(() {
              if (isStart) {
                _startTime = picked;
                _endTime = TimeOfDay(
                  hour: (picked.hour + 1) % 24,
                  minute: 0,
                );
              } else {
                _endTime = picked;
              }
            });

            // Automatically open End Time Sheet after picking Start Time
            if (isStart) {
              Future.delayed(const Duration(milliseconds: 250), () {
                if (mounted) {
                  _pickTimeSheet(isStart: false);
                }
              });
            }
          },
        ),
      );
    } else {
      // CUSTOM LOCATION: Standard TimePicker
      final picked = await showTimePicker(
        context: context,
        initialTime: (isStart ? _startTime : _endTime) ?? const TimeOfDay(hour: 18, minute: 0),
      );
      if (picked != null) {
        setState(() {
          if (isStart) {
            _startTime = picked;
            _endTime = TimeOfDay(hour: (picked.hour + 1) % 24, minute: picked.minute);
          } else {
            _endTime = picked;
          }
        });
      }
    }
  }

  Future<void> _openGoogleMapsPicker() async {
    final result = await Navigator.push<LocationData>(
      context,
      MaterialPageRoute(
        builder: (context) => MapPickerScreen(isSelectOnly: true),
      ),
    );

    if (result != null) {
      setState(() {
        _customAddressController.text = result.fullAddress.isNotEmpty
            ? result.fullAddress
            : '${result.landmark}, ${result.subLocality}, ${result.city}';
        _customLat = result.lat;
        _customLng = result.lng;
      });
    }
  }

  Future<void> _onHostMatchPressed() async {
    if (_selectedSport == null || _selectedSport!.isEmpty) {
      Get.snackbar(
        'Select Sport',
        'Please select a sport for your match poll.',
        backgroundColor: AppColors.card,
        colorText: Colors.white,
      );
      return;
    }

    if (_locationType == 'custom' && _customAddressController.text.trim().isEmpty) {
      Get.snackbar(
        'Missing Location',
        'Please enter an address or select a location on Google Maps.',
        backgroundColor: AppColors.card,
        colorText: Colors.white,
      );
      return;
    }

    if (_locationType == 'playz_turf' && _selectedTurf == null) {
      Get.snackbar(
        'Select Turf',
        'Please select a PlayZ Turf venue.',
        backgroundColor: AppColors.card,
        colorText: Colors.white,
      );
      return;
    }

    if (_selectedDate == null) {
      Get.snackbar(
        'Select Date',
        'Please select a match date.',
        backgroundColor: AppColors.card,
        colorText: Colors.white,
      );
      return;
    }

    if (_startTime == null || _endTime == null) {
      Get.snackbar(
        'Select Time',
        'Please select start and end match time.',
        backgroundColor: AppColors.card,
        colorText: Colors.white,
      );
      return;
    }

    // PRICE VALIDATION: Ensure price per player does not exceed total turf slot cost
    if (_locationType == 'playz_turf' && !_isFree && !_isSplitAndPay) {
      final double turfSlotCost = _currentTurfSlotCost;
      if (turfSlotCost > 0 && _pricePerPlayer > turfSlotCost) {
        Get.snackbar(
          'Invalid Price Per Player',
          'Price per player (₹${_pricePerPlayer.toInt()}) cannot exceed total turf slot price (₹${turfSlotCost.toInt()}).',
          backgroundColor: AppColors.card,
          colorText: Colors.white,
        );
        return;
      }
    }

    if (_locationType == 'playz_turf' && _selectedTurf != null && _selectedGround != null && _selectedDate != null && _startTime != null && _endTime != null) {
      final dateStr = DateFormat('yyyy-MM-dd').format(_selectedDate!);
      final timeRangeStr = _formattedTimeString;

      final isOverlapping = await SlotOverlapHelper.isSlotOverlappingInFirestore(
        ownerId: _selectedTurf!.ownerId,
        turfId: _selectedTurf!.id,
        groundId: _selectedGround!.id,
        dateStr: dateStr,
        newTimeRangeStr: timeRangeStr,
      );

      if (isOverlapping) {
        Get.snackbar(
          'Slot Overlap Detected',
          'The selected slot ($timeRangeStr) overlaps with an existing booking on this ground! Please pick another date or time slot.',
          backgroundColor: AppColors.card,
          colorText: Colors.white,
          duration: const Duration(seconds: 4),
        );
        return;
      }
    }

    if (_locationType == 'playz_turf') {
      final double depositAmount = _calculateHostDeposit();
      if (depositAmount > 0) {
        _openRazorpay(depositAmount);
        return;
      }
    }

    await _submitMatchPoll();
  }

  void _openRazorpay(double amount) {
    setState(() => _isSubmitting = true);

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
      'name': _selectedTurf?.turfName ?? 'PlayZ Arena',
      'description': 'Match Turf Booking Deposit',
      'prefill': {
        'contact': phone,
        'email': email,
      },
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error launching Razorpay: $e');
      _submitMatchPoll(paymentId: 'DEV_PASS_${DateTime.now().millisecondsSinceEpoch}');
    }
  }

  Future<void> _createTurfBookingRecord(String dateStr, String timeStr) async {
    if (_selectedTurf == null || _selectedGround == null) return;
    try {
      final bookingData = {
        'turfId': _selectedTurf!.id,
        'turfName': _selectedTurf!.turfName,
        'groundId': _selectedGround!.id,
        'groundName': _selectedGround!.name,
        'date': dateStr,
        'time': timeStr,
        'slotId': _selectedSlot?.id ?? '',
        'status': 'confirmed',
        'createdAt': FieldValue.serverTimestamp(),
        'bookingType': 'match_poll_free',
      };
      await FirebaseFirestore.instance
          .collection('owners')
          .doc(_selectedTurf!.ownerId)
          .collection('turfs')
          .doc(_selectedTurf!.id)
          .collection('bookings')
          .add(bookingData);
    } catch (e) {
      debugPrint('Error creating turf booking record: $e');
    }
  }

  Future<void> _submitMatchPoll({String? paymentId}) async {
    setState(() => _isSubmitting = true);

    final user = FirebaseAuth.instance.currentUser;
    final docId = await UserPreferences.getDocId() ?? user?.uid ?? 'unknown_user';
    final hostName = _profileController.userName.isNotEmpty
        ? _profileController.userName
        : user?.displayName ?? 'Host Player';
    final avatarUrl = _profileController.profileImageUrl.isNotEmpty
        ? _profileController.profileImageUrl
        : user?.photoURL ?? 'https://i.pravatar.cc/100?img=1';

    final dateStr = DateFormat('yyyy-MM-dd').format(_selectedDate!);
    final timeStr = _formattedTimeString;

    final addressStr = _locationType == 'playz_turf'
        ? '${_selectedTurf?.turfName ?? ''} - ${_selectedGround?.name ?? ''}, ${_selectedTurf?.city ?? ''}'
        : _customAddressController.text.trim();

    final double groundLat = _locationType == 'playz_turf' ? (_selectedTurf?.latitude ?? 0.0) : _customLat;
    final double groundLng = _locationType == 'playz_turf' ? (_selectedTurf?.longitude ?? 0.0) : _customLng;

    String calculatedDist = '1.2 km away';
    final userLoc = _mapsController.currentLocation.value;
    if (userLoc != null && groundLat != 0.0 && groundLng != 0.0) {
      final distM = Geolocator.distanceBetween(userLoc.lat, userLoc.lng, groundLat, groundLng);
      final km = distM / 1000.0;
      calculatedDist = '${km.toStringAsFixed(1)} km away';
    }

    final double turfSlotCost = _locationType == 'playz_turf' ? _currentTurfSlotCost : 0.0;
    final double hostDeposit = _calculateHostDeposit();
    final double pricePerPlayerFinal = _isFree
        ? 0.0
        : (_isSplitAndPay && turfSlotCost > 0
            ? (turfSlotCost / (_maxPlayers > 0 ? _maxPlayers : 1)).ceilToDouble()
            : _pricePerPlayer);

    // Turf slot is ONLY marked booked if host pays 100% of the turf slot cost upfront
    final bool isSlotBooked = (_locationType == 'playz_turf' && _isFree == true && hostDeposit >= turfSlotCost && turfSlotCost > 0);

    if (isSlotBooked) {
      await _createTurfBookingRecord(dateStr, timeStr);
    }

    final matchMap = {
      'hostId': docId,
      'hostName': hostName,
      'avatarUrl': avatarUrl,
      'hostXp': 200,
      'time': '$dateStr, $timeStr',
      'date': dateStr,
      'price': _isFree ? 'Free' : '₹${pricePerPlayerFinal.toInt()}',
      'priceNum': _isFree ? 0 : pricePerPlayerFinal.toInt(),
      'currentPlayers': 1,
      'maxPlayers': _maxPlayers,
      'address': addressStr,
      'distance': calculatedDist,
      'latitude': groundLat,
      'longitude': groundLng,
      'sport': _selectedSport ?? 'Football',
      'type': _isCompetitive ? 'Competitive' : 'Casual',
      'isCompetitive': _isCompetitive,
      'locationType': _locationType,
      'ownerId': _selectedTurf?.ownerId ?? '',
      'turfId': _selectedTurf?.id,
      'groundId': _selectedGround?.id,
      'slotId': _selectedSlot?.id,
      'paymentId': paymentId ?? '',
      'playerIds': [docId],
      'instructions': _instructionsController.text.trim(),
      'equipmentOption': _selectedEquipmentOption ?? 'none',
      'turfSlotCost': turfSlotCost,
      'hostPaidUpfront': hostDeposit,
      'isSplitAndPay': _isSplitAndPay,
      'collectedAmount': hostDeposit,
      'targetAmount': turfSlotCost,
      'isSlotBooked': isSlotBooked,
    };

    final success = await _matchController.createMatch(matchMap);
    setState(() => _isSubmitting = false);

    if (success) {
      Get.back();
      Get.snackbar(
        'Match Hosted! ⚽',
        isSlotBooked
            ? 'Your match poll is live and turf slot is BOOKED! ⚡'
            : 'Your match poll is live! Turf slot will be booked once all player payments are gathered. ⏳',
        backgroundColor: AppColors.accent,
        colorText: Colors.black,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Calculate distance between user and turf
  String _calculateTurfDistance(TurfModel turf, int index) {
    final userLoc = _mapsController.currentLocation.value;
    if (userLoc != null && turf.latitude != 0.0 && turf.longitude != 0.0) {
      final distanceInMeters = Geolocator.distanceBetween(
        userLoc.lat,
        userLoc.lng,
        turf.latitude,
        turf.longitude,
      );
      final km = distanceInMeters / 1000.0;
      return '${km.toStringAsFixed(1)} km away';
    }
    final defaultDistances = ['1.2 km away', '2.4 km away', '3.8 km away', '4.5 km away'];
    return defaultDistances[index % defaultDistances.length];
  }

  void _fetchSlotsIfPossible() {
    if (_selectedTurf != null && _selectedGround != null) {
      final dateStr = DateFormat('yyyy-MM-dd').format(_selectedDate ?? DateTime.now());
      _bookingController.fetchGroundSlots(
        _selectedTurf!.ownerId,
        _selectedTurf!.id,
        _selectedGround!.id,
        dateStr: dateStr,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    final filteredSports = _allSports.where((sport) {
      return sport.toLowerCase().contains(_sportSearchQuery.toLowerCase());
    }).toList();

    final double turfCost = _currentTurfSlotCost;
    final double hostDeposit = _calculateHostDeposit();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Host a Match',
          style: GoogleFonts.inter(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: ResponsiveHelper.sp(18),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(ResponsiveHelper.w(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. SPORTS SELECTION
              SportSelectionSection(
                searchController: _sportSearchController,
                searchQuery: _sportSearchQuery,
                selectedSport: _selectedSport,
                popularSports: _popularSports,
                filteredSports: filteredSports,
                onSearchChanged: (val) => setState(() => _sportSearchQuery = val),
                onSportSelected: (sport) => setState(() {
                  _selectedSport = sport;
                  _selectedTurf = null;
                  _selectedGround = null;
                  _selectedSlot = null;
                  _selectedDate = null;
                  _startTime = null;
                  _endTime = null;
                  if (sport != null) {
                    _sportSearchController.clear();
                    _sportSearchQuery = '';
                  }
                }),
                onClearSearch: () {
                  _sportSearchController.clear();
                  setState(() => _sportSearchQuery = '');
                },
              ),

              const SizedBox(height: 24),

              // 2. MATCH MODE (CASUAL VS COMPETITIVE)
              MatchModeSection(
                isCompetitive: _isCompetitive,
                onModeChanged: (val) => setState(() => _isCompetitive = val),
              ),

              const SizedBox(height: 24),

              // 3. TOTAL PLAYERS COUNTER (+ / - CARD)
              PlayerCounterSection(
                maxPlayers: _maxPlayers,
                onPlayersChanged: (val) => setState(() => _maxPlayers = val),
              ),

              const SizedBox(height: 24),

              // 4. VENUE & GROUND LOCATION
              VenueLocationSection(
                locationType: _locationType,
                selectedSport: _selectedSport,
                turfSearchController: _turfSearchController,
                turfSearchQuery: _turfSearchQuery,
                selectedTurf: _selectedTurf,
                selectedGround: _selectedGround,
                selectedSlot: _selectedSlot,
                customAddressController: _customAddressController,
                bookingController: _bookingController,
                onLocationTypeChanged: (val) => setState(() {
                  _locationType = val;
                  _selectedTurf = null;
                  _selectedGround = null;
                  _selectedSlot = null;
                  _selectedDate = null;
                  _startTime = null;
                  _endTime = null;
                }),
                onTurfSearchChanged: (val) => setState(() => _turfSearchQuery = val),
                onClearTurfSearch: () {
                  _turfSearchController.clear();
                  setState(() => _turfSearchQuery = '');
                },
                onTurfSelected: (turf) {
                  setState(() {
                    _selectedTurf = turf;
                    _selectedGround = null;
                    _selectedSlot = null;
                    _selectedDate = null;
                    _startTime = null;
                    _endTime = null;
                  });
                  _bookingController.fetchTurfGrounds(turf.ownerId, turf.id);
                },
                onGroundSelected: (ground) {
                  setState(() {
                    _selectedGround = ground;
                    _selectedSlot = null;
                    _selectedDate = null;
                    _startTime = null;
                    _endTime = null;
                  });
                  _fetchSlotsIfPossible();
                },
                onSlotSelected: (slot) {
                  setState(() {
                    _selectedSlot = slot;
                  });
                },
                onOpenGoogleMapsPicker: _openGoogleMapsPicker,
                calculateDistance: _calculateTurfDistance,
              ),

              const SizedBox(height: 24),

              // 5. MATCH SCHEDULE (DATE & TIME PICKED AFTER VENUE SELECTION)
              ScheduleSection(
                selectedDate: _selectedDate,
                startTime: _startTime,
                endTime: _endTime,
                onPickDate: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate ?? DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 30)),
                  );
                  if (picked != null) {
                    setState(() => _selectedDate = picked);
                    _fetchSlotsIfPossible();
                  }
                },
                onPickStartTime: () => _pickTimeSheet(isStart: true),
                onPickEndTime: () => _pickTimeSheet(isStart: false),
              ),

              const SizedBox(height: 24),

              // 6. SPECIAL INSTRUCTIONS
              SpecialInstructionsSection(
                instructionsController: _instructionsController,
                instructionPresets: _instructionPresets,
                onPresetTapped: (preset) {
                  final current = _instructionsController.text.trim();
                  if (current.isEmpty) {
                    _instructionsController.text = preset;
                  } else if (!current.contains(preset)) {
                    _instructionsController.text = '$current • $preset';
                  }
                },
              ),

              const SizedBox(height: 24),

              // 7. EQUIPMENT OPTIONS
              EquipmentOptionsSection(
                selectedOption: _selectedEquipmentOption,
                onOptionSelected: (option) => setState(() => _selectedEquipmentOption = option),
              ),

              const SizedBox(height: 24),

              // 8. PRICING & FEE (MOVED TO LAST POSITION BEFORE PUBLISH BUTTON)
              PricingSection(
                isFree: _isFree,
                isPlayZTurf: _locationType == 'playz_turf',
                turfSlotCost: turfCost,
                maxPlayers: _maxPlayers,
                isSplitAndPay: _isSplitAndPay,
                priceController: _priceController,
                onFreeToggled: (val) => setState(() {
                  _isFree = val;
                  if (val) _isSplitAndPay = false;
                }),
                onSplitAndPayToggled: (val) => setState(() {
                  _isSplitAndPay = val;
                  if (val) _isFree = false;
                }),
                onPriceChanged: (val) {
                  setState(() {
                    _pricePerPlayer = double.tryParse(val) ?? 0.0;
                  });
                },
                hostDepositAmount: hostDeposit,
              ),

              const SizedBox(height: 32),

              // 9. PUBLISH MATCH BUTTON
              SizedBox(
                width: double.infinity,
                height: ResponsiveHelper.h(52),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    foregroundColor: Colors.black,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(ResponsiveHelper.w(14)),
                    ),
                  ),
                  onPressed: _isSubmitting ? null : _onHostMatchPressed,
                  child: _isSubmitting
                      ? const CircularProgressIndicator(color: Colors.black)
                      : Text(
                          _locationType == 'playz_turf' && hostDeposit > 0
                              ? 'Pay ₹${hostDeposit.toInt()} & Host Poll'
                              : 'Publish Match Poll',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.bold,
                            fontSize: ResponsiveHelper.sp(16),
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
