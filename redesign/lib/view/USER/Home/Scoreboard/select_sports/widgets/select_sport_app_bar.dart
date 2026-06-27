import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';

const Color kBg = AppColors.background;

class SelectSportAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SelectSportAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      backgroundColor: kBg,
      elevation: 0,
      leading: const BackButton(),
      title: const Text(
        'Select Sport',
        style: TextStyle(fontWeight: FontWeight.w700),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
