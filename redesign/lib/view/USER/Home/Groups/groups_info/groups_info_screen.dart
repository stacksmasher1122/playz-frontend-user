import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Groups_Controller/group_info_controller.dart';

// Modular Widgets
import 'widgets/groups_info_header.dart';
import 'widgets/info_action_buttons.dart';
import 'widgets/group_media_section.dart';
import 'widgets/group_members_section.dart';
import 'widgets/moderation_section.dart';
import 'widgets/footer_actions.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/common/app_back_button.dart';

class GroupsInfoScreen extends StatefulWidget {
  final String groupId;

  const GroupsInfoScreen({super.key, required this.groupId});

  @override
  State<GroupsInfoScreen> createState() => _GroupsInfoScreenState();
}

class _GroupsInfoScreenState extends State<GroupsInfoScreen> {
  late final GroupInfoController _ctrl;

  @override
  void initState() {
    super.initState();
    // Register the controller if not already present
    if (!Get.isRegistered<GroupInfoController>()) {
      Get.put(GroupInfoController());
    }
    _ctrl = Get.find<GroupInfoController>();
    _ctrl.initGroupInfo(widget.groupId);
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: AppBackButton(),
        ),
        title: Text(
          "SQUAD",
          style: AppTypography.displayLg.copyWith(
            color: AppColors.accent,
            fontSize: context.responsiveFont(18),
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: AppColors.textPrimary),
            onPressed: () {},
          ),
        ],
      ),
      body: Obx(() {
        final group = _ctrl.currentGroup.value;
        if (group == null) {
          return const Center(child: CircularProgressIndicator(color: AppColors.accent));
        }

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(
            horizontal: context.widthPct(4),
            vertical: context.heightPct(2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GroupsInfoHeader(group: group, ctrl: _ctrl),
              SizedBox(height: context.heightPct(2.5)),
              const InfoActionButtons(),
              SizedBox(height: context.heightPct(2.5)),
              GroupMediaSection(ctrl: _ctrl),
              SizedBox(height: context.heightPct(2)),
              GroupMembersSection(group: group, ctrl: _ctrl),
              SizedBox(height: context.heightPct(2)),
              ModerationSection(group: group, ctrl: _ctrl),
              SizedBox(height: context.heightPct(2)),
              FooterActions(ctrl: _ctrl),
              SizedBox(height: context.heightPct(4)),
            ],
          ),
        );
      }),
    );
  }
}
