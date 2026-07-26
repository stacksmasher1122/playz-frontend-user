import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/controller/User_Controller/Match_Controller/match_controller.dart';
import 'package:redesign/controller/User_Controller/Booking_Controller/booking_controller.dart';
import 'package:redesign/controller/user_profile_controller.dart';
import 'package:redesign/shared_preferences/userPreferences.dart';
import 'package:redesign/model/User_Models/Booking_Models/turf_model.dart';
import 'package:redesign/model/User_Models/Booking_Models/ground_model.dart';
import 'package:redesign/model/User_Models/Booking_Models/slot_model.dart';

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

  late Razorpay _razorpay;

  // Form State
  String _selectedSport = 'Football';
  bool _isCompetitive = false; // Casual vs Competitive
  int _maxPlayers = 10;
  double _pricePerPlayer = 100.0;
  final bool _isFree = false;

  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = const TimeOfDay(hour: 18, minute: 0);

  // Location Mode: 'playz_turf' vs 'custom'
  String _locationType = 'playz_turf';

  // PlayZ Turf Selection
  TurfModel? _selectedTurf;
  GroundModel? _selectedGround;
  SlotModel? _selectedSlot;

  // Custom Location Input
  final TextEditingController _customAddressController = TextEditingController();

  bool _isSubmitting = false;

  final List<String> _sportsList = [
    'Football',
    'Cricket',
    'Badminton',
    'Basketball',
    'Tennis',
    'Volleyball',
  ];

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);

    // Initial fetch of registered turfs
    _bookingController.fetchAllTurfs();
  }

  @override
  void dispose() {
    _razorpay.clear();
    _customAddressController.dispose();
    super.dispose();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    _submitMatchPoll(paymentId: response.paymentId);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Get.snackbar(
      'Payment Interrupted',
      response.message ?? 'Payment failed or was cancelled.',
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
    );
    setState(() => _isSubmitting = false);
  }

  Future<void> _onHostMatchPressed() async {
    if (_locationType == 'custom' && _customAddressController.text.trim().isEmpty) {
      Get.snackbar('Missing Address', 'Please enter a ground address or venue location.');
      return;
    }

    if (_locationType == 'playz_turf') {
      if (_selectedTurf == null || _selectedGround == null) {
        Get.snackbar('Select Turf', 'Please select a PlayZ Turf and Ground.');
        return;
      }

      final slotPrice = _selectedSlot?.price ?? _selectedGround?.defaultPrice ?? 1000.0;
      if (slotPrice > 0) {
        _openRazorpay(slotPrice);
        return;
      }
    }

    await _submitMatchPoll();
  }

  void _openRazorpay(double amount) {
    setState(() => _isSubmitting = true);

    var options = {
      'key': 'rzp_test_YourKeyHere',
      'amount': (amount * 100).toInt(),
      'name': _selectedTurf?.turfName ?? 'PlayZ Arena',
      'description': 'Match Turf Booking Deposit',
      'prefill': {
        'contact': _profileController.rxUser.value?.secondaryPhone ?? '',
        'email': _profileController.userEmail,
      },
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error launching Razorpay: $e');
      _submitMatchPoll(paymentId: 'DEV_PASS_${DateTime.now().millisecondsSinceEpoch}');
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

    final dateStr = DateFormat('yyyy-MM-dd').format(_selectedDate);

    if (!mounted) return;
    final timeStr = _selectedTime.format(context);

    final addressStr = _locationType == 'playz_turf'
        ? '${_selectedTurf?.turfName ?? ''} - ${_selectedGround?.name ?? ''}, ${_selectedTurf?.city ?? ''}'
        : _customAddressController.text.trim();

    final matchMap = {
      'hostId': docId,
      'hostName': hostName,
      'avatarUrl': avatarUrl,
      'hostXp': 200,
      'time': '$dateStr, $timeStr',
      'date': dateStr,
      'price': _isFree ? 'Free' : '₹${_pricePerPlayer.toInt()}',
      'priceNum': _isFree ? 0 : _pricePerPlayer.toInt(),
      'currentPlayers': 1,
      'maxPlayers': _maxPlayers,
      'address': addressStr,
      'distance': '1.2 km',
      'latitude': _locationType == 'playz_turf' ? (_selectedTurf?.latitude ?? 0.0) : 18.5204,
      'longitude': _locationType == 'playz_turf' ? (_selectedTurf?.longitude ?? 0.0) : 73.8567,
      'sport': _selectedSport,
      'type': _isCompetitive ? 'Competitive' : 'Casual',
      'isCompetitive': _isCompetitive,
      'locationType': _locationType,
      'turfId': _selectedTurf?.id,
      'groundId': _selectedGround?.id,
      'slotId': _selectedSlot?.id,
      'paymentId': paymentId ?? '',
      'playerIds': [docId],
    };

    final success = await _matchController.createMatch(matchMap);
    setState(() => _isSubmitting = false);

    if (success) {
      Get.back();
      Get.snackbar(
        'Match Hosted! ⚽',
        'Your ${_isCompetitive ? "Competitive" : "Casual"} match poll is now live!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

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
              /// SPORT SELECTOR
              Text(
                'Select Sport',
                style: GoogleFonts.inter(
                  color: AppColors.accent,
                  fontWeight: FontWeight.bold,
                  fontSize: ResponsiveHelper.sp(14),
                ),
              ),
              SizedBox(height: 8),

              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _sportsList.map((sport) {
                  final isSelected = _selectedSport == sport;
                  return ChoiceChip(
                    label: Text(sport),
                    selected: isSelected,
                    selectedColor: AppColors.accent,
                    backgroundColor: Colors.grey.shade900,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.black : Colors.white70,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    ),
                    onSelected: (val) {
                      if (val) setState(() => _selectedSport = sport);
                    },
                  );
                }).toList(),
              ),

              SizedBox(height: 20),

              /// MATCH MODE: CASUAL VS COMPETITIVE
              Text(
                'Match Mode',
                style: GoogleFonts.inter(
                  color: AppColors.accent,
                  fontWeight: FontWeight.bold,
                  fontSize: ResponsiveHelper.sp(14),
                ),
              ),
              SizedBox(height: 8),

              Row(
                children: [
                  Expanded(
                    child: _ModeCard(
                      title: 'Casual Match',
                      subtitle: 'Friendly, low-stakes game',
                      icon: Icons.sports_soccer,
                      isSelected: !_isCompetitive,
                      activeColor: const Color(0xFF1E3A8A),
                      onTap: () => setState(() => _isCompetitive = false),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _ModeCard(
                      title: 'Competitive',
                      subtitle: 'High intensity & rank XP',
                      icon: Icons.emoji_events,
                      isSelected: _isCompetitive,
                      activeColor: const Color(0xFF4C1D95),
                      onTap: () => setState(() => _isCompetitive = true),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20),

              /// PRICE PER PLAYER & MAX PLAYERS
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Price Per Player',
                          style: GoogleFonts.inter(
                            color: AppColors.accent,
                            fontWeight: FontWeight.bold,
                            fontSize: ResponsiveHelper.sp(14),
                          ),
                        ),
                        SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1A1A1A),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.white12),
                          ),
                          child: Row(
                            children: [
                              const Text('₹', style: TextStyle(color: Colors.white70, fontSize: 16)),
                              SizedBox(width: 6),
                              Expanded(
                                child: TextFormField(
                                  initialValue: '100',
                                  enabled: !_isFree,
                                  keyboardType: TextInputType.number,
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                  decoration: const InputDecoration(border: InputBorder.none),
                                  onChanged: (val) {
                                    _pricePerPlayer = double.tryParse(val) ?? 0;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Players Needed',
                          style: GoogleFonts.inter(
                            color: AppColors.accent,
                            fontWeight: FontWeight.bold,
                            fontSize: ResponsiveHelper.sp(14),
                          ),
                        ),
                        SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1A1A1A),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.white12),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<int>(
                              value: _maxPlayers,
                              dropdownColor: const Color(0xFF1A1A1A),
                              isExpanded: true,
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              items: [2, 4, 6, 8, 10, 12, 14, 16, 18, 22].map((playerCount) {
                                return DropdownMenuItem<int>(
                                  value: playerCount,
                                  child: Text('$playerCount Players'),
                                );
                              }).toList(),
                              onChanged: (val) {
                                if (val != null) setState(() => _maxPlayers = val);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20),

              /// DATE & TIME SELECTION
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white24),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _selectedDate,
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(days: 30)),
                        );
                        if (picked != null) setState(() => _selectedDate = picked);
                      },
                      icon: const Icon(Icons.calendar_today, size: 18, color: AppColors.accent),
                      label: Text(DateFormat('EEE, dd MMM').format(_selectedDate)),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white24),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () async {
                        final picked = await showTimePicker(
                          context: context,
                          initialTime: _selectedTime,
                        );
                        if (picked != null) setState(() => _selectedTime = picked);
                      },
                      icon: const Icon(Icons.access_time, size: 18, color: AppColors.accent),
                      label: Text(_selectedTime.format(context)),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 24),

              /// LOCATION TYPE SELECTOR: PLAYZ TURF VS CUSTOM GROUND
              Text(
                'Venue & Ground Location',
                style: GoogleFonts.inter(
                  color: AppColors.accent,
                  fontWeight: FontWeight.bold,
                  fontSize: ResponsiveHelper.sp(14),
                ),
              ),
              SizedBox(height: 8),

              Row(
                children: [
                  ChoiceChip(
                    label: const Text('PlayZ Turf'),
                    selected: _locationType == 'playz_turf',
                    selectedColor: AppColors.accent,
                    backgroundColor: Colors.grey.shade900,
                    labelStyle: TextStyle(
                      color: _locationType == 'playz_turf' ? Colors.black : Colors.white70,
                      fontWeight: FontWeight.bold,
                    ),
                    onSelected: (val) {
                      if (val) setState(() => _locationType = 'playz_turf');
                    },
                  ),
                  SizedBox(width: 10),
                  ChoiceChip(
                    label: const Text('Custom / Unofficial Ground'),
                    selected: _locationType == 'custom',
                    selectedColor: AppColors.accent,
                    backgroundColor: Colors.grey.shade900,
                    labelStyle: TextStyle(
                      color: _locationType == 'custom' ? Colors.black : Colors.white70,
                      fontWeight: FontWeight.bold,
                    ),
                    onSelected: (val) {
                      if (val) setState(() => _locationType = 'custom');
                    },
                  ),
                ],
              ),

              SizedBox(height: 12),

              if (_locationType == 'playz_turf') ...[
                /// SELECT PLAYZ TURF DROPDOWN
                Obx(() {
                  final turfs = _bookingController.allTurfs;
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A1A),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white12),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<TurfModel>(
                        value: _selectedTurf,
                        hint: const Text('Select PlayZ Turf Arena', style: TextStyle(color: Colors.white54)),
                        dropdownColor: const Color(0xFF1A1A1A),
                        isExpanded: true,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                        items: turfs.map((t) {
                          return DropdownMenuItem<TurfModel>(
                            value: t,
                            child: Text('${t.turfName} (${t.city})'),
                          );
                        }).toList(),
                        onChanged: (turf) {
                          setState(() {
                            _selectedTurf = turf;
                            _selectedGround = null;
                            _selectedSlot = null;
                          });
                          if (turf != null) {
                            _bookingController.fetchTurfGrounds(turf.ownerId, turf.id);
                          }
                        },
                      ),
                    ),
                  );
                }),

                if (_selectedTurf != null) ...[
                  SizedBox(height: 10),
                  Obx(() {
                    final grounds = _bookingController.grounds;
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1A1A),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white12),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<GroundModel>(
                          value: _selectedGround,
                          hint: const Text('Select Ground / Court', style: TextStyle(color: Colors.white54)),
                          dropdownColor: const Color(0xFF1A1A1A),
                          isExpanded: true,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                          items: grounds.map((g) {
                            return DropdownMenuItem<GroundModel>(
                              value: g,
                              child: Text('${g.name} (₹${g.defaultPrice.toInt()}/hr)'),
                            );
                          }).toList(),
                          onChanged: (ground) {
                            setState(() {
                              _selectedGround = ground;
                              _selectedSlot = null;
                            });
                          },
                        ),
                      ),
                    );
                  }),
                ],
              ] else ...[
                /// CUSTOM ADDRESS INPUT FOR GOOGLE MAPS LOCATION
                TextField(
                  controller: _customAddressController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Enter Google Maps location / full text address...',
                    hintStyle: const TextStyle(color: Colors.white38),
                    prefixIcon: const Icon(Icons.location_on, color: AppColors.accent),
                    filled: true,
                    fillColor: const Color(0xFF1A1A1A),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.white12),
                    ),
                  ),
                ),
              ],

              SizedBox(height: 32),

              /// SUBMIT BUTTON
              SizedBox(
                width: double.infinity,
                height: ResponsiveHelper.h(50),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(ResponsiveHelper.w(14)),
                    ),
                  ),
                  onPressed: _isSubmitting ? null : _onHostMatchPressed,
                  child: _isSubmitting
                      ? const CircularProgressIndicator(color: Colors.black)
                      : Text(
                          'Publish Match Poll',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.bold,
                            fontSize: ResponsiveHelper.sp(16),
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ModeCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final Color activeColor;
  final VoidCallback onTap;

  const _ModeCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.activeColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? activeColor : const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppColors.accent : Colors.white12,
            width: isSelected ? 1.8 : 1.0,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: isSelected ? Colors.white : Colors.white54, size: 20),
                const Spacer(),
                if (isSelected)
                  const Icon(Icons.check_circle, color: AppColors.accent, size: 18),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: GoogleFonts.inter(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: GoogleFonts.inter(
                color: Colors.white70,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
