import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Groups_Controller/group_info_controller.dart';

// Modular Widgets
import 'widgets/groups_info_header.dart';
import 'widgets/info_action_buttons.dart';
import 'widgets/group_media_section.dart';
import 'widgets/group_members_section.dart';
import 'widgets/moderation_section.dart';
import 'widgets/footer_actions.dart';
import 'package:redesign/theme/responsive_helper.dart';

const _kGreen = AppColors.accent;
const _kBg = AppColors.surface;

class GroupsInfoScreen extends StatefulWidget {
  final String groupId;

  GroupsInfoScreen({super.key, required this.groupId});

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
      backgroundColor: _kBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "SQUAD",
          style: TextStyle(
            color: _kGreen,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Obx(() {
        final group = _ctrl.currentGroup.value;
        if (group == null) {
          return Center(child: CircularProgressIndicator(color: _kGreen));
        }

        return SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16), vertical: ResponsiveHelper.h(20)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GroupsInfoHeader(group: group, ctrl: _ctrl),
              SizedBox(height: 24),
              InfoActionButtons(),
              SizedBox(height: 24),
              GroupMediaSection(ctrl: _ctrl),
              SizedBox(height: 16),
              GroupMembersSection(group: group, ctrl: _ctrl),
              SizedBox(height: 16),
              if (_ctrl.isAdmin.value) ModerationSection(group: group, ctrl: _ctrl),
              if (_ctrl.isAdmin.value) SizedBox(height: 16),
              FooterActions(ctrl: _ctrl),
              SizedBox(height: 40),
            ],
          ),
        );
      }),
    );
  }
}
