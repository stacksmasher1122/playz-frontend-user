import 'package:flutter/material.dart';
import 'package:redesign/theme/responsive_helper.dart';

Color kSurface = Color(0xFF0E0E0E);
Color kMuted = Color(0xFFA7A7A7);

class ScopeTabs extends StatelessWidget {
  final int selected;
  final ValueChanged<int> onChanged;

  ScopeTabs({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final tabs = ['Friends', 'Local', 'Global', 'Groups'];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16), vertical: ResponsiveHelper.h(8)),
      child: Row(
        children: List.generate(tabs.length, (i) {
          final active = selected == i;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(i),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(10)),
                margin: EdgeInsets.only(right: i < tabs.length - 1 ? 8 : 0),
                decoration: BoxDecoration(
                  color: active ? kSurface : Colors.transparent,
                  borderRadius: BorderRadius.circular(ResponsiveHelper.w(14)),
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
