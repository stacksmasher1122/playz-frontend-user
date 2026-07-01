import 'package:flutter/material.dart';
import 'package:redesign/theme/responsive_helper.dart';

class ToggleOptionWidget extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  ToggleOptionWidget({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(12.0)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: value ? Colors.white : Colors.grey,
              fontSize: ResponsiveHelper.sp(14),
              fontWeight: FontWeight.bold,
            ),
          ),
          RepaintBoundary(
            child: Switch(
              value: value,
              onChanged: onChanged,
              activeThumbColor: Colors.black,
              activeTrackColor: Color(0xFFC6FF00), // Lime Green
              inactiveThumbColor: Colors.grey,
              inactiveTrackColor: Colors.grey.shade800,
            ),
          ),
        ],
      ),
    );
  }
}
