import 'package:flutter/material.dart';
import 'package:redesign/theme/responsive_helper.dart';

const kSurface = Color(0xFF0E0E0E);
const kMuted = Colors.white70;

class SearchBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  SearchBarWidget({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(14)),
        decoration: BoxDecoration(
          color: kSurface,
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(28)),
        ),
        child: TextField(
          controller: controller,
          focusNode: focusNode,
          onChanged: onChanged,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            icon: Icon(Icons.search, color: kMuted),
            hintText: 'Find friends, squads, or nearby players...',
            hintStyle: TextStyle(color: kMuted),
            border: InputBorder.none,
            suffixIcon: ValueListenableBuilder<TextEditingValue>(
              valueListenable: controller,
              builder: (_, value, __) {
                if (value.text.isEmpty) return SizedBox.shrink();
                return IconButton(
                  icon: Icon(Icons.close, color: kMuted, size: 20),
                  onPressed: onClear,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
