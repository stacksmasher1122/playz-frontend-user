import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'step_header.dart';
import 'package:redesign/theme/responsive_helper.dart';

const kGreen = AppColors.accent;
const kCard = Color(0xFF1A1A1A);
const kMuted = Color(0xFFA7A7A7);

class AvailabilitySection extends StatefulWidget {
  AvailabilitySection({super.key});

  @override
  State<AvailabilitySection> createState() => _AvailabilitySectionState();
}

class _AvailabilitySectionState extends State<AvailabilitySection> {
  final Set<String> _selectedDays = {'M', 'T', 'W', 'F'};
  final Set<String> _selectedSlots = {'Morning (6–10 AM)', 'Evening (5–9 PM)'};

  final days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
  final slots = [
    'Morning (6–10 AM)',
    'Afternoon (12–4 PM)',
    'Evening (5–9 PM)',
  ];

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// STEP HEADER
        StepHeader(step: 5, title: 'Availability'),

        SizedBox(height: 16),

        /// DAYS
        Text(
          'Days Available',
          style: TextStyle(
            color: kMuted,
            fontSize: ResponsiveHelper.sp(13),
            fontWeight: FontWeight.w500,
          ),
        ),

        SizedBox(height: 12),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(days.length, (i) {
            final day = days[i];
            final selected = _selectedDays.contains('$i-$day');

            return DayCircle(
              label: day,
              selected: selected,
              onTap: () {
                setState(() {
                  selected
                      ? _selectedDays.remove('$i-$day')
                      : _selectedDays.add('$i-$day');
                });
              },
            );
          }),
        ),

        SizedBox(height: 20),

        /// TIME SLOTS
        Text(
          'Preferred Time Slots',
          style: TextStyle(
            color: kMuted,
            fontSize: ResponsiveHelper.sp(13),
            fontWeight: FontWeight.w500,
          ),
        ),

        SizedBox(height: 12),

        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: slots.map((slot) {
            final selected = _selectedSlots.contains(slot);
            return TimeSlotChip(
              label: slot,
              selected: selected,
              onTap: () {
                setState(() {
                  selected
                      ? _selectedSlots.remove(slot)
                      : _selectedSlots.add(slot);
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}

class DayCircle extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  DayCircle({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return InkWell(
      customBorder: CircleBorder(),
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        width: ResponsiveHelper.w(42),
        height: ResponsiveHelper.h(42),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: selected ? kGreen : kCard,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.black : Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class TimeSlotChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  TimeSlotChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return InkWell(
      borderRadius: BorderRadius.circular(ResponsiveHelper.w(24)),
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16), vertical: ResponsiveHelper.h(10)),
        decoration: BoxDecoration(
          color: selected ? kGreen.withValues(alpha: 0.15) : kCard,
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(24)),
          border: Border.all(
            color: selected ? kGreen : Colors.transparent,
            width: ResponsiveHelper.w(1.2),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? kGreen : Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: ResponsiveHelper.sp(13),
          ),
        ),
      ),
    );
  }
}
