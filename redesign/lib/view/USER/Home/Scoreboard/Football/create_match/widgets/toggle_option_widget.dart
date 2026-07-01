import 'package:flutter/material.dart';

class ToggleOptionWidget extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const ToggleOptionWidget({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: value ? Colors.white : Colors.grey,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          RepaintBoundary(
            child: Switch(
              value: value,
              onChanged: onChanged,
              activeThumbColor: Colors.black,
              activeTrackColor: const Color(0xFFC6FF00), // Lime Green
              inactiveThumbColor: Colors.grey,
              inactiveTrackColor: Colors.grey.shade800,
            ),
          ),
        ],
      ),
    );
  }
}
