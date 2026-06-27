import 'package:flutter/material.dart';

const Color kSurface = Color(0xFF0E0E0E);
const Color kMuted = Color(0xFF9E9E9E);

class SelectSportSearchBar extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const SelectSportSearchBar({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
        child: TextField(
          onChanged: onChanged,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Search sports...',
            hintStyle: const TextStyle(color: kMuted),
            prefixIcon: const Icon(Icons.search, color: kMuted),
            filled: true,
            fillColor: kSurface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }
}
