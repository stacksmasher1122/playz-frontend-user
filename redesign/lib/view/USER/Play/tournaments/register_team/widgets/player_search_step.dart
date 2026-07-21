import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../../../controller/User_Controller/Tournament_Controller/register_team_controller.dart';
import '../../../../Tournament/create_tournament_prize_pool/widget/common_textfield.dart';

class PlayerSearchStep extends StatelessWidget {
  final RegisterTeamController controller;

  const PlayerSearchStep({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Roster",
              style: AppTypography.headlineSm.copyWith(color: AppColors.onPrimary),
            ),
            Obx(() => Text(
              "${controller.selectedPlayers.length}/${controller.teamSize}",
              style: AppTypography.bodyMd.copyWith(color: AppColors.accent),
            )),
          ],
        ),
        SizedBox(height: ResponsiveHelper.h(16)),

        // Selected Players List
        Obx(() => ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: controller.selectedPlayers.length,
          itemBuilder: (context, index) {
            final player = controller.selectedPlayers[index];
            final isMe = player.userId == controller.currentUserId;

            return Container(
              margin: EdgeInsets.only(bottom: ResponsiveHelper.h(12)),
              padding: EdgeInsets.all(ResponsiveHelper.w(12)),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: ResponsiveHelper.w(20),
                    backgroundColor: AppColors.surface,
                    backgroundImage: player.profileImageUrl.isNotEmpty
                        ? CachedNetworkImageProvider(player.profileImageUrl)
                        : null,
                    child: player.profileImageUrl.isEmpty
                        ? Icon(Icons.person, color: AppColors.muted)
                        : null,
                  ),
                  SizedBox(width: ResponsiveHelper.w(12)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isMe ? "${player.name} (You)" : player.name,
                          style: AppTypography.bodyLg.copyWith(color: AppColors.onPrimary)
                        ),
                        SizedBox(height: ResponsiveHelper.h(4)),
                        // Role Dropdown
                        Container(
                          height: ResponsiveHelper.h(30),
                          padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(8)),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(ResponsiveHelper.w(6)),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: controller.availableRoles.containsKey(player.sportRole)
                                  ? player.sportRole
                                  : controller.availableRoles.keys.first,
                              dropdownColor: AppColors.card,
                              icon: Icon(Icons.arrow_drop_down, color: AppColors.muted, size: 16),
                              style: AppTypography.bodySm.copyWith(color: AppColors.accent),
                              items: controller.availableRoles.keys.map((role) {
                                return DropdownMenuItem(
                                  value: role,
                                  child: Text(role),
                                );
                              }).toList(),
                              onChanged: (val) {
                                if (val != null) controller.updatePlayerRole(player.userId, val);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!isMe)
                    IconButton(
                      icon: Icon(Icons.remove_circle_outline, color: AppColors.error),
                      onPressed: () => controller.removePlayer(player.userId),
                    ),
                ],
              ),
            );
          },
        )),

        SizedBox(height: ResponsiveHelper.h(24)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Add Players",
              style: AppTypography.headlineSm.copyWith(color: AppColors.onPrimary),
            ),
            Obx(() {
              if (controller.selectedPlayers.any((p) => p.userId == controller.currentUserId)) {
                return const SizedBox.shrink();
              }
              return TextButton.icon(
                onPressed: controller.addCurrentUserAction,
                icon: Icon(Icons.person_add, color: AppColors.accent, size: ResponsiveHelper.w(18)),
                label: Text("Add Myself", style: AppTypography.labelCaps.copyWith(color: AppColors.accent)),
              );
            }),
          ],
        ),
        SizedBox(height: ResponsiveHelper.h(12)),

        CommonTextField(
          controller: controller.searchController,
          hintText: "Search name or username...",
          prefixIcon: Icon(Icons.search, color: AppColors.muted),
          onChanged: (val) {
            // Simple debounce handled in UI or controller
            controller.searchPlayers(val);
          },
        ),
        SizedBox(height: ResponsiveHelper.h(16)),

        // Search Results
        Obx(() {
          if (controller.isSearching.value) {
            return Center(child: CircularProgressIndicator(color: AppColors.accent));
          }

          if (controller.searchController.text.isNotEmpty && controller.searchResults.isEmpty) {
            return Center(
              child: Text("No players found", style: AppTypography.bodyMd.copyWith(color: AppColors.muted)),
            );
          }

          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.searchResults.length,
            itemBuilder: (context, index) {
              final result = controller.searchResults[index];
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  backgroundColor: AppColors.card,
                  backgroundImage: result['profileImageUrl'].toString().isNotEmpty
                      ? CachedNetworkImageProvider(result['profileImageUrl'])
                      : null,
                  child: result['profileImageUrl'].toString().isEmpty
                      ? Icon(Icons.person, color: AppColors.muted)
                      : null,
                ),
                title: Row(
                  children: [
                    Text(result['name'], style: AppTypography.bodyLg.copyWith(color: AppColors.onPrimary)),
                    if (result['isFriend'] == true) ...[
                      SizedBox(width: ResponsiveHelper.w(6)),
                      Icon(Icons.handshake, color: AppColors.accent, size: ResponsiveHelper.w(16)),
                    ]
                  ],
                ),
                trailing: IconButton(
                  icon: Icon(Icons.add_circle, color: AppColors.accent),
                  onPressed: () => controller.addPlayer(result),
                ),
              );
            },
          );
        }),
      ],
    );
  }
}
