import 'package:flutter/material.dart';
import 'package:redesign/theme/responsive_helper.dart';

Color kSurface = Color(0xFF0E0E0E);
Color kMuted = Color(0xFF9E9E9E);

class SelectSportSearchBar extends StatelessWidget {
  final ValueChanged<String> onChanged;

  SelectSportSearchBar({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 12, 16, 8),
        child: TextField(
          onChanged: onChanged,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Search sports...',
            hintStyle: TextStyle(color: kMuted),
            prefixIcon: Icon(Icons.search, color: kMuted),
            filled: true,
            fillColor: kSurface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ResponsiveHelper.w(14)),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }
}
