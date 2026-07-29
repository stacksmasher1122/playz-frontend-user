import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/model/User_Models/Home_Models/Groups_Model/groups_model.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Groups_Controller/group_info_controller.dart';
import 'package:redesign/theme/responsive_helper.dart';

class ModerationSection extends StatelessWidget {
  final GroupModel group;
  final GroupInfoController ctrl;

  const ModerationSection({
    super.key,
    required this.group,
    required this.ctrl,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(context.minDimensionPct(4)),
        border: Border.all(color: AppColors.borderDark),
      ),
      padding: EdgeInsets.all(context.widthPct(4)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.shield_outlined, color: AppColors.accent, size: 20),
              SizedBox(width: context.widthPct(2)),
              Text(
                "CHAT MODERATION",
                style: AppTypography.labelCaps10.copyWith(
                  color: AppColors.accent,
                  fontSize: context.responsiveFont(12),
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          SizedBox(height: context.heightPct(1.5)),

          // ── Toggle: Profanity Filter for Members ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Profanity Filter (Members)",
                      style: AppTypography.headlineSm.copyWith(
                        color: AppColors.textPrimary,
                        fontSize: context.responsiveFont(14),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: context.heightPct(0.3)),
                    Text(
                      "Block extreme profanity from members",
                      style: AppTypography.bodySm.copyWith(
                        color: AppColors.muted,
                        fontSize: context.responsiveFont(11),
                      ),
                    ),
                  ],
                ),
              ),
              Switch.adaptive(
                value: group.profanityModerationMembers,
                activeTrackColor: AppColors.accent,
                onChanged: (val) =>
                    ctrl.toggleProfanityModerationMembers(val),
              ),
            ],
          ),

          // ── Toggle: Profanity Filter for Admins (only if Members is ON) ──
          if (group.profanityModerationMembers) ...[
            Divider(color: AppColors.borderDark, height: context.heightPct(3)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Profanity Filter (Admins)",
                        style: AppTypography.headlineSm.copyWith(
                          color: AppColors.textPrimary,
                          fontSize: context.responsiveFont(14),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: context.heightPct(0.3)),
                      Text(
                        "Also moderate admin messages",
                        style: AppTypography.bodySm.copyWith(
                          color: AppColors.muted,
                          fontSize: context.responsiveFont(11),
                        ),
                      ),
                    ],
                  ),
                ),
                Switch.adaptive(
                  value: group.profanityModerationAdmins,
                  activeTrackColor: AppColors.accent,
                  onChanged: (val) =>
                      ctrl.toggleProfanityModerationAdmins(val),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
