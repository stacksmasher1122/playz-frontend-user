import 'package:flutter/material.dart';

const Color kSurface = Color(0xFF0E0E0E);
const Color kMuted = Color(0xFFA7A7A7);

class ScopeTabs extends StatelessWidget {
  final int selected;
  final ValueChanged<int> onChanged;

  const ScopeTabs({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final tabs = ['Friends', 'Local', 'Global', 'Groups'];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: List.generate(tabs.length, (i) {
          final active = selected == i;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 10),
                margin: EdgeInsets.only(right: i < tabs.length - 1 ? 8 : 0),
                decoration: BoxDecoration(
                  color: active ? kSurface : Colors.transparent,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  tabs[i],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: active ? Colors.white : kMuted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
