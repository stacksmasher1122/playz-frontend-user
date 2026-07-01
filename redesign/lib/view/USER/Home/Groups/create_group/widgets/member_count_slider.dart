import 'package:flutter/material.dart';
import 'package:redesign/theme/responsive_helper.dart';

const kSurface = Color(0xFF161616);
const kGreen = Color(0xFF6EDC6A);
const kMuted = Colors.white54;

class MemberCountSlider extends StatelessWidget {
  final double maxMembers;
  final Function(double) onChanged;

  MemberCountSlider({
    super.key,
    required this.maxMembers,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Column(
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: kGreen,
            inactiveTrackColor: kSurface,
            thumbColor: kGreen,
            overlayColor: kGreen.withValues(alpha: 0.2),
            trackHeight: 4,
          ),
          child: Slider(
            value: maxMembers,
            min: 5,
            max: 50,
            divisions: 45,
            onChanged: onChanged,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(12)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('5', style: TextStyle(color: kMuted, fontSize: 11)),
              Text('50', style: TextStyle(color: kMuted, fontSize: 11)),
            ],
          ),
        ),
      ],
    );
  }
}
