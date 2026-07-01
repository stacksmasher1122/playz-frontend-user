import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/view/USER/Book/book/book_screen.dart';
//import 'package:redesign/view/USER/Book/booktest.dart';
// import 'package:redesign/book.dart';
import 'package:redesign/view/USER/Home/home/home_screen.dart';
import 'package:redesign/view/USER/More/menu/more_screen.dart';
import 'package:redesign/view/USER/Play/play/play_screen.dart';
import 'package:redesign/view/USER/Trainer/trainer/trainer_screen.dart';
import 'package:redesign/theme/responsive_helper.dart';

class UserAppNavShell extends StatefulWidget {
  UserAppNavShell({super.key});

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
    return Scaffold(
      backgroundColor: AppColors.background,
      extendBody: true,
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            height: ResponsiveHelper.h(80),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.7),
              border: Border(top: BorderSide(color: Colors.white12)),
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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            selected ? item.filled : item.outlined,
                            size: 26,
                            color: selected ? AppColors.accent : Colors.white60,
                          ),
                          SizedBox(height: 4),
                          Text(
                            item.label,
                            style: TextStyle(
                              fontSize: ResponsiveHelper.sp(11),
                              fontWeight: selected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                              color: selected ? AppColors.accent : Colors.white60,
                            ),
                          ),
                        ],
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
