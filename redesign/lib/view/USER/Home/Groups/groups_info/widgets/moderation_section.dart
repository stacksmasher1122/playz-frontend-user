import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/model/User_Models/Home_Models/Groups_Model/groups_model.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Groups_Controller/group_info_controller.dart';
import 'package:redesign/theme/responsive_helper.dart';

const _kGreen = AppColors.accent;
const _kSurface = Color(0xFF222222);
const _kMuted = Colors.white54;

class ModerationSection extends StatelessWidget {
  final GroupModel group;
  final GroupInfoController ctrl;

  ModerationSection({
    super.key,
    required this.group,
    required this.ctrl,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      decoration: BoxDecoration(
        color: _kSurface.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
      ),
      padding: EdgeInsets.all(ResponsiveHelper.w(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.shield_outlined, color: _kGreen, size: 20),
              SizedBox(width: 8),
              Text(
                "MODERATION",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: ResponsiveHelper.sp(12),
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),

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
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: ResponsiveHelper.sp(14),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      "Block extreme profanity from members",
                      style: TextStyle(color: _kMuted, fontSize: 11),
                    ),
                  ],
                ),
              ),
              Switch.adaptive(
                value: group.profanityModerationMembers,
                activeColor: _kGreen,
                onChanged: (val) =>
                    ctrl.toggleProfanityModerationMembers(val),
              ),
            ],
          ),

          // ── Toggle: Profanity Filter for Admins (only if Members is ON) ──
          if (group.profanityModerationMembers) ...[
            Divider(color: Colors.white12, height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Profanity Filter (Admins)",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: ResponsiveHelper.sp(14),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        "Also moderate admin messages",
                        style: TextStyle(color: _kMuted, fontSize: 11),
                      ),
                    ],
                  ),
                ),
                Switch.adaptive(
                  value: group.profanityModerationAdmins,
                  activeColor: _kGreen,
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
