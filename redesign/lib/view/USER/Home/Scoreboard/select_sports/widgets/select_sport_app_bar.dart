import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

Color kBg = AppColors.background;

class SelectSportAppBar extends StatelessWidget implements PreferredSizeWidget {
  SelectSportAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return SliverAppBar(
      pinned: true,
      backgroundColor: kBg,
      elevation: 0,
      leading: BackButton(),
      title: Text(
        'Select Sport',
        style: TextStyle(fontWeight: FontWeight.w700),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
