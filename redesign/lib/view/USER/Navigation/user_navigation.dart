import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/view/USER/Book/book/book_screen.dart';
import 'package:redesign/view/USER/Home/home/home_screen.dart';
import 'package:redesign/view/USER/More/menu/more_screen.dart';
import 'package:redesign/view/USER/Play/play/play_screen.dart';
import 'package:redesign/view/USER/Trainer/trainer/trainer_screen.dart';

class UserAppNavShell extends StatefulWidget {
  const UserAppNavShell({super.key});

  @override
  State<UserAppNavShell> createState() => _UserAppNavShellState();
}

class _UserAppNavShellState extends State<UserAppNavShell> {
  int _currentIndex = 0;

  final _pages = [
    UserHomePage(),
    BookTurfScreen(),
    GameDiaryScreen(),
    TrainerDiscoveryScreen(),
    MoreScreen(),
  ];

  void _onTap(int index) {
    if (index == _currentIndex) return;
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    final navBarHeight = context.heightPct(9).clamp(64.0, 88.0);
    final iconSize = context.minDimensionPct(6.5).clamp(22.0, 28.0);

    return Scaffold(
      backgroundColor: AppColors.background,
      extendBody: true,
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            height: navBarHeight,
            padding: EdgeInsets.only(
              top: context.heightPct(0.5),
              bottom: context.bottomInset,
            ),
            decoration: BoxDecoration(
              color: AppColors.background.withValues(alpha: 0.7),
              border: const Border(top: BorderSide(color: AppColors.divider)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children:
                  [
                    _NavItem(
                      filled: Icons.home,
                      outlined: Icons.home_outlined,
                      label: 'Home',
                      index: 0,
                    ),
                    _NavItem(
                      filled: Icons.calendar_month,
                      outlined: Icons.calendar_month_outlined,
                      label: 'Book',
                      index: 1,
                    ),
                    _NavItem(
                      filled: Icons.play_circle,
                      outlined: Icons.play_circle_outline,
                      label: 'Play',
                      index: 2,
                    ),
                    _NavItem(
                      filled: Icons.supervisor_account_sharp,
                      outlined: Icons.supervisor_account_outlined,
                      label: 'Trainer',
                      index: 3,
                    ),
                    _NavItem(
                      filled: Icons.menu,
                      outlined: Icons.menu_outlined,
                      label: 'More',
                      index: 4,
                    ),
                  ].map((item) {
                    final selected = item.index == _currentIndex;

                    return GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => _onTap(item.index),
                      child: SizedBox(
                        width: context.widthPct(18),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              selected ? item.filled : item.outlined,
                              size: iconSize,
                              color: selected
                                  ? AppColors.accent
                                  : AppColors.textSecondary,
                            ),
                            SizedBox(height: context.heightPct(0.5)),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                item.label,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTypography.labelCaps10.copyWith(
                                  fontSize: context.responsiveFont(11),
                                  fontWeight: selected
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                  color: selected
                                      ? AppColors.accent
                                      : AppColors.textSecondary,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}

/* ============================================================
   NAV ITEM MODEL
   ============================================================ */
class _NavItem {
  final IconData filled;
  final IconData outlined;
  final String label;
  final int index;

  _NavItem({
    required this.filled,
    required this.outlined,
    required this.label,
    required this.index,
  });
}
