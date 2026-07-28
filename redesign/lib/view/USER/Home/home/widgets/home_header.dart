import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/controller/user_profile_controller.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

/* ============================================================
   HOME HEADER (GREETING + TOGGLE)
   ============================================================ */
class HomeHeader extends StatelessWidget {
  final bool isTrainer;
  final _controller = Get.find<UserProfileController>();

  HomeHeader({
    super.key,
    required this.isTrainer,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);

    if (isTrainer) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: _greeting(context)),
          SizedBox(width: context.widthPct(4)),
          _toggle(),
        ],
      );
    } else {
      return _greeting(context);
    }
  }

  Widget _greeting(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: context.heightPct(1)),
        Obx(() {
          final fullName = _controller.rxUser.value?.fullName ?? 'User';
          final firstName = fullName.split(' ').first;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  "Hey $firstName! 👋",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.headlineLg.copyWith(
                    fontSize: context.responsiveFont(20),
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              SizedBox(height: context.heightPct(0.5)),
              Text(
                "Ready for some competition?",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.bodySm.copyWith(
                  fontSize: context.responsiveFont(13),
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          );
        }),
      ],
    );
  }

  Widget _toggle() {
    return Flexible(
      child: Column(
        children: [
          const SizedBox(height: 15),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 150, minWidth: 110),
            child: const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
