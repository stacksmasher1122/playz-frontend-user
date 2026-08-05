import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/controller/maps_controller.dart';
import 'package:redesign/view/USER/Book/book/book_screen.dart';
import 'package:redesign/view/USER/Home/home/home_screen.dart';
import 'package:redesign/view/USER/More/menu/more_screen.dart';
import 'package:redesign/view/USER/Play/play/play_screen.dart';
import 'package:redesign/view/USER/Trainer/trainer/trainer_screen.dart';

class UserNavController extends GetxController {
  final currentIndex = 0.obs;

  void changeTab(int index) {
    currentIndex.value = index;
  }
}

class UserAppNavShell extends StatefulWidget {
  final int initialIndex;
  final int playInitialTab;
  const UserAppNavShell({
    super.key,
    this.initialIndex = 0,
    this.playInitialTab = 0,
  });

  @override
  State<UserAppNavShell> createState() => _UserAppNavShellState();
}

class _UserAppNavShellState extends State<UserAppNavShell> {
  late final UserNavController _navCtrl;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const UserHomePage(),
      const BookTurfScreen(),
      GameDiaryScreen(initialTabIndex: widget.playInitialTab),
      const TrainerDiscoveryScreen(),
      const MoreScreen(),
    ];
    _navCtrl = Get.isRegistered<UserNavController>()
        ? Get.find<UserNavController>()
        : Get.put(UserNavController());
    if (widget.initialIndex != 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _navCtrl.changeTab(widget.initialIndex);
      });
    }

    final mapsCtrl = Get.isRegistered<MapsController>()
        ? Get.find<MapsController>()
        : Get.put(MapsController(), permanent: true);
    mapsCtrl.autoDetectLocationOnStartup();
  }

  void _onTap(int index) {
    _navCtrl.changeTab(index);
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    final iconSize = context.minDimensionPct(6).clamp(20.0, 26.0);
    final navVerticalPad = context.heightPct(1);
    final iconLabelGap = context.heightPct(0.4);

    return Obx(() {
      final currentIndex = _navCtrl.currentIndex.value;

      return Scaffold(
        backgroundColor: AppColors.background,
        extendBody: true,
        body: IndexedStack(index: currentIndex, children: _pages),
        bottomNavigationBar: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: context.minDimensionPct(1.3),
              sigmaY: context.minDimensionPct(1.3),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.background.withValues(alpha: 0.7),
                border: const Border(top: BorderSide(color: AppColors.divider)),
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  top: navVerticalPad,
                  bottom:
                      MediaQuery.of(context).viewPadding.bottom * 0.45 +
                      navVerticalPad,
                ),
                child: Row(
                  children:
                      [
                        const _NavItem(
                          filled: Icons.home,
                          outlined: Icons.home_outlined,
                          label: 'Home',
                          index: 0,
                        ),
                        const _NavItem(
                          filled: Icons.calendar_month,
                          outlined: Icons.calendar_month_outlined,
                          label: 'Book',
                          index: 1,
                        ),
                        const _NavItem(
                          filled: Icons.play_circle,
                          outlined: Icons.play_circle_outline,
                          label: 'Play',
                          index: 2,
                        ),
                        const _NavItem(
                          filled: Icons.supervisor_account_sharp,
                          outlined: Icons.supervisor_account_outlined,
                          label: 'Trainer',
                          index: 3,
                        ),
                        const _NavItem(
                          filled: Icons.menu,
                          outlined: Icons.menu_outlined,
                          label: 'More',
                          index: 4,
                        ),
                      ].map((item) {
                        final selected = item.index == currentIndex;

                        return Expanded(
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () => _onTap(item.index),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  selected ? item.filled : item.outlined,
                                  size: iconSize,
                                  color: selected
                                      ? AppColors.accent
                                      : AppColors.textSecondary,
                                ),
                                SizedBox(height: iconLabelGap),
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
        ),
      );
    });
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

  const _NavItem({
    required this.filled,
    required this.outlined,
    required this.label,
    required this.index,
  });
}
