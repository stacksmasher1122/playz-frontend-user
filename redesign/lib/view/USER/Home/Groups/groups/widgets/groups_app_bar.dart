import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/view/USER/Home/Groups/create_group/create_group_screen.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/common/app_back_button.dart';

class GroupsAppBar extends StatelessWidget {
  const GroupsAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return SliverToBoxAdapter(
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.background.withValues(alpha: 0.8),
              border: const Border(
                bottom: BorderSide(color: AppColors.borderDark),
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  context.widthPct(4),
                  context.heightPct(1.2),
                  context.widthPct(4),
                  context.heightPct(1.2),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    /// COMMON ROUNDED BACK BUTTON
                    const AppBackButton(),
                    SizedBox(width: context.widthPct(3)),

                    /// TEXT
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Groups',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.displayLg.copyWith(
                              color: AppColors.textPrimary,
                              fontSize: context.responsiveFont(22),
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(height: context.heightPct(0.3)),
                          Text(
                            'Play together. Compete harder.',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.bodySm.copyWith(
                              color: AppColors.textSecondary,
                              fontSize: context.responsiveFont(13),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(width: context.widthPct(3)),

                    /// ACTION ICONS
                    _HeaderIcon(
                      icon: Icons.group_add,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CreateGroupScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HeaderIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _HeaderIcon({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return InkWell(
      borderRadius: BorderRadius.circular(context.minDimensionPct(10)),
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(context.widthPct(2.5)),
        decoration: BoxDecoration(
          color: AppColors.surface,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.borderDark),
        ),
        child: const Icon(Icons.group_add, color: AppColors.textPrimary, size: 20),
      ),
    );
  }
}
