import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class LiveMatchAppbar extends StatefulWidget implements PreferredSizeWidget {
  LiveMatchAppbar({super.key});

  @override
  State<LiveMatchAppbar> createState() => _LiveMatchAppbarState();
  
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _LiveMatchAppbarState extends State<LiveMatchAppbar> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: AppColors.primary),
        onPressed: () => Navigator.pop(context),
      ),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.sports_tennis, color: AppColors.primaryContainer, size: 24),
          SizedBox(width: 8),
          Text('MATCH CENTER', style: AppTypography.headlineMd),
        ],
      ),
      centerTitle: false,
      titleSpacing: 0,
      actions: [
        Center(
          child: Container(
            margin: EdgeInsets.only(right: 12),
            padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(10), vertical: ResponsiveHelper.h(4)),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.surfaceContainerHighest),
              borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
            ),
            child: Row(
              children: [
                FadeTransition(
                  opacity: Tween<double>(begin: 0.3, end: 1.0).animate(_pulseController),
                  child: Container(
                    width: ResponsiveHelper.w(8),
                    height: ResponsiveHelper.h(8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryContainer,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                SizedBox(width: 6),
                Text(
                  'LIVE',
                  style: AppTypography.labelCaps10.copyWith(color: AppColors.primaryContainer, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: 16.0),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primaryContainer, width: 1.5),
            ),
            child: CircleAvatar(
              radius: 16,
              backgroundImage: NetworkImage('https://i.pravatar.cc/100'),
            ),
          ),
        ),
      ],
    );
  }
}
