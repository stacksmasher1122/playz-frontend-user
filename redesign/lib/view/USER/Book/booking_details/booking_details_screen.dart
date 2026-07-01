import 'package:flutter/material.dart';
import 'package:redesign/common/pay_succ.dart';
import 'package:redesign/theme/app_colors.dart';

import 'widgets/addon_card.dart';
import 'widgets/availability_timeline.dart';
import 'widgets/booking_dropdowns.dart';
import 'widgets/booking_summary.dart';
import 'widgets/booking_time_pickers.dart';
import 'widgets/confirmation_bottom_bar.dart';
import 'widgets/date_selector.dart';
import 'widgets/solo_queue_options.dart';
import 'widgets/sport_selector.dart';
import 'package:redesign/theme/responsive_helper.dart';

const kBgColor = Colors.black;
const kMuted = Color(0xFFA7A7A7);

class ConfirmSlotScreen extends StatefulWidget {
  ConfirmSlotScreen({super.key});

  @override
  State<ConfirmSlotScreen> createState() => _ConfirmSlotScreenState();
}

class _ConfirmSlotScreenState extends State<ConfirmSlotScreen> {
  bool soloQueue = false;
  int players = 4;
  double radius = 10;
  bool bringOwnEquipment = false;
  bool splitAndPay = false;
  int baseSlotPrice = 1000;
  late final ScrollController _timelineController;

  static const int _startHour = 1; // 6 AM
  static const int _totalHours = 23; // 6 AM → 6 PM
  static const double _slotWidth = 90;
  static const double _separatorWidth = 2;

  DateTime? selectedDate;
  String? selectedType;
  String? selectedSize;
  final Set<String> _selectedAddons = {};

  final List<String> typeOptions = ['Turf', 'Grass', 'Indoor', 'Synthetic'];
  final List<String> sizeOptions = [
    '3-a-side',
    '5-a-side',
    '7-a-side',
    '11-a-side',
  ];

  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  String? selectedSport;

  bool get _isReadyToPay {
    if (selectedDate == null) return false;
    if (selectedSport == null) return false;
    if (selectedType == null || selectedType!.isEmpty) return false;
    if (selectedSize == null || selectedSize!.isEmpty) return false;
    if (_startTime == null || _endTime == null) return false;
    return _endTime!.hour > _startTime!.hour;
  }

  int get _totalAmount {
    int basePrice = 1000;
    return basePrice;
  }

  @override
  void initState() {
    super.initState();
    _timelineController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _waitForTimelineAndScroll();
    });
  }

  @override
  void dispose() {
    _timelineController.dispose();
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
    final now = DateTime.now();

    int effectiveHour = now.minute >= 30 ? now.hour + 1 : now.hour;

    effectiveHour = effectiveHour.clamp(
      _startHour,
      _startHour + _totalHours - 1,
    );

    final int index = effectiveHour - _startHour;

    final double itemExtent = _slotWidth + _separatorWidth;
    double offset = index * itemExtent;

    final viewportWidth = _timelineController.position.viewportDimension;

    offset -= (viewportWidth - _slotWidth) / 2;

    offset = offset.clamp(
      _timelineController.position.minScrollExtent,
      _timelineController.position.maxScrollExtent,
    );

    _timelineController.animateTo(
      offset,
      duration: Duration(milliseconds: 450),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Scaffold(
      backgroundColor: kBgColor,
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: BackButton(),
        title: Text('Confirm Slot'),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Text('Step 2/3', style: TextStyle(color: kMuted)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 110),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DateSelector(
              selectedDate: selectedDate,
              onDateSelected: (date) => setState(() => selectedDate = date),
            ),
            SizedBox(height: 24),

            _SectionTitle(text: 'Sport & Ground'),
            SizedBox(height: 8),
            SportSelector(
              selectedSport: selectedSport,
              onSportSelected: (sport) => setState(() => selectedSport = sport),
            ),
            SizedBox(height: 20),
            BookingDropdowns(
              selectedType: selectedType,
              selectedSize: selectedSize,
              typeOptions: typeOptions,
              sizeOptions: sizeOptions,
              onTypeSelected: (v) => setState(() => selectedType = v),
              onSizeSelected: (v) => setState(() => selectedSize = v),
            ),
            SizedBox(height: 24),

            AvailabilityTimeline(controller: _timelineController),
            SizedBox(height: 24),

            BookingTimePickers(
              startTime: _startTime,
              endTime: _endTime,
              onPickStartTime: () => _pickTime(isStart: true),
              onPickEndTime: () => _pickTime(isStart: false),
            ),
            SizedBox(height: 32),

            _SectionTitle(text: 'Add-ons & Equipment'),
            SizedBox(height: 5),
            AddonCard(
              title: 'Pro Match Ball',
              price: '+ ₹200',
              isSelected: _selectedAddons.contains('Pro Match Ball'),
              onTap: () => _toggleAddon('Pro Match Ball'),
            ),
            AddonCard(
              title: 'Extra Bibs (Set of 10)',
              price: '+ ₹150',
              isSelected: _selectedAddons.contains('Extra Bibs (Set of 10)'),
              onTap: () => _toggleAddon('Extra Bibs (Set of 10)'),
            ),
            AddonCard(
              title: 'Referee Service',
              price: '+ ₹300',
              isSelected: _selectedAddons.contains('Referee Service'),
              onTap: () => _toggleAddon('Referee Service'),
            ),
            SizedBox(height: 28),

            SoloQueueOptions(
              soloQueue: soloQueue,
              players: players,
              radius: radius,
              splitAndPay: splitAndPay,
              bringOwnEquipment: bringOwnEquipment,
              baseSlotPrice: baseSlotPrice,
              onSoloQueueChanged: (v) => setState(() => soloQueue = v),
              onPlayersChanged: (v) => setState(() => players = v),
              onRadiusChanged: (v) => setState(() => radius = v),
              onSplitAndPayChanged: (v) => setState(() => splitAndPay = v),
              onBringOwnEquipmentChanged: (v) =>
                  setState(() => bringOwnEquipment = v),
            ),
            SizedBox(height: 32),

            BookingSummary(),
          ],
        ),
      ),
      bottomNavigationBar: ConfirmationBottomBar(
        enabled: _isReadyToPay,
        totalAmount: _totalAmount,
        onPayPressed: _onPayPressed,
      ),
    );
  }

  void _toggleAddon(String title) {
    setState(() {
      if (_selectedAddons.contains(title)) {
        _selectedAddons.remove(title);
      } else {
        _selectedAddons.add(title);
      }
    });
  }

  void _onPayPressed() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => BookingConfirmationScreen()));
  }

  Future<void> _pickTime({required bool isStart}) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: isStart
          ? (_startTime ?? TimeOfDay(hour: 8, minute: 0))
          : (_endTime ?? TimeOfDay(hour: 9, minute: 0)),
      helpText: 'Select Hour',
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: AppColors.accent,
              surface: Colors.black,
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked == null) return;
    final selected = TimeOfDay(hour: picked.hour, minute: 0);

    setState(() {
      if (isStart) {
        _startTime = selected;
        if (_endTime == null || _endTime!.hour <= _startTime!.hour) {
          _endTime = TimeOfDay(
            hour: (_startTime!.hour + 1).clamp(0, 23),
            minute: 0,
          );
        }
      } else {
        if (_startTime != null && selected.hour <= _startTime!.hour) return;
        _endTime = selected;
      }
    });
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  _SectionTitle({required this.text});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16)),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: ResponsiveHelper.sp(18),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
