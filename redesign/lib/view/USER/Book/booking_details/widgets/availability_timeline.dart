import 'package:flutter/material.dart';

class AvailabilityTimeline extends StatelessWidget {
  final ScrollController controller;

  const AvailabilityTimeline({
    super.key,
    required this.controller,
  });

  static const _kMuted = Color(0xFFA7A7A7);
  static const int _startHour = 1; 
  static const int _totalHours = 23;

  @override
  Widget build(BuildContext context) {
    final List<TimeSlot> slots = List.generate(_totalHours, (index) {
      final int start = _startHour + index;
      final int end = start + 1;

      return TimeSlot(
        start: _formatHour(start),
        end: _formatHour(end),
        isFree: index.isEven, // mock availability
      );
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Availability',
            style: TextStyle(
              color: _kMuted,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(height: 12),

        /// SINGLE SCROLLABLE TIMELINE
        SingleChildScrollView(
          controller: controller,
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// TIME LABELS (6 AM → 6 PM)
              Row(
                children: [
                  _TimeLabel(slots.first.start),
                  ...slots.map((s) => _TimeLabel(s.end)).toList(),
                ],
              ),

              const SizedBox(height: 6),

              /// BLOCKS
              Row(
                children: List.generate(slots.length, (index) {
                  final slot = slots[index];
                  final bool isFirst = index == 0;
                  final bool isLast = index == slots.length - 1;

                  return Row(
                    children: [
                      _TimelineBlock(
                        slot: slot,
                        isFirst: isFirst,
                        isLast: isLast,
                      ),
                      if (!isLast)
                        Container(
                          width: 2,
                          height: 44,
                          color: Colors.grey.shade800,
                        ),
                    ],
                  );
                }),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        /// LEGEND
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              _LegendDot(color: Color(0xFFD60101)),
              SizedBox(width: 6),
              Text('Booked', style: TextStyle(color: _kMuted)),
              SizedBox(width: 16),
              _LegendDot(color: Color(0xFF00B45D)),
              SizedBox(width: 6),
              Text('Free', style: TextStyle(color: _kMuted)),
            ],
          ),
        ),
      ],
    );
  }

  String _formatHour(int hour) {
    final int h = hour % 24;
    final int displayHour = h == 0 ? 12 : h > 12 ? h - 12 : h;
    final String period = h >= 12 ? 'PM' : 'AM';
    return '$displayHour $period';
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  const _LegendDot({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class _TimeLabel extends StatelessWidget {
  final String time;
  const _TimeLabel(this.time);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      alignment: Alignment.centerLeft,
      child: Text(time, style: const TextStyle(color: Color(0xFFA7A7A7), fontSize: 12)),
    );
  }
}

class _TimelineBlock extends StatelessWidget {
  final TimeSlot slot;
  final bool isFirst;
  final bool isLast;

  const _TimelineBlock({
    required this.slot,
    required this.isFirst,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      height: 44,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: slot.isFree
            ? const Color.fromARGB(255, 0, 180, 93)
            : const Color.fromARGB(255, 214, 1, 1),
        borderRadius: BorderRadius.horizontal(
          left: isFirst ? const Radius.circular(12) : Radius.zero,
          right: isLast ? const Radius.circular(12) : Radius.zero,
        ),
      ),
      child: Text(
        slot.isFree ? 'FREE' : 'BOOKED',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

class TimeSlot {
  final String start;
  final String end;
  final bool isFree;

  TimeSlot({required this.start, required this.end, required this.isFree});
}
