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
    ResponsiveHelper.init(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Roster",
              style: AppTypography.headlineSm.copyWith(
                color: AppColors.textPrimary,
                fontSize: context.responsiveFont(16),
                fontWeight: FontWeight.bold,
              ),
            ),
            Obx(() => Text(
              "${controller.selectedPlayers.length}/${controller.teamSize}",
              style: AppTypography.bodyMd.copyWith(
                color: AppColors.accent,
                fontWeight: FontWeight.bold,
                fontSize: context.responsiveFont(14),
              ),
            )),
          ],
        ),
        SizedBox(height: context.heightPct(1.5)),

        // Selected Players List
        Obx(() => ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: controller.selectedPlayers.length,
          itemBuilder: (context, index) {
            final player = controller.selectedPlayers[index];
            final isMe = player.userId == controller.currentUserId;

            return Container(
              margin: EdgeInsets.only(bottom: context.heightPct(1.5)),
              padding: EdgeInsets.all(context.widthPct(3)),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(context.minDimensionPct(3)),
                border: Border.all(color: AppColors.borderDark),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: context.minDimensionPct(4.5).clamp(16.0, 22.0),
                    backgroundColor: AppColors.surface,
                    backgroundImage: player.profileImageUrl.isNotEmpty
                        ? CachedNetworkImageProvider(player.profileImageUrl)
                        : null,
                    child: player.profileImageUrl.isEmpty
                        ? const Icon(Icons.person_rounded, color: AppColors.muted, size: 18)
                        : null,
                  ),
                  SizedBox(width: context.widthPct(3)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isMe ? "${player.name} (you)" : player.name,
                          style: AppTypography.bodyLg.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: context.responsiveFont(14),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: context.heightPct(0.5)),
                        // Role Dropdown
                        Container(
                          height: context.heightPct(4).clamp(28.0, 36.0),
                          padding: EdgeInsets.symmetric(horizontal: context.widthPct(2)),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(context.minDimensionPct(1.5)),
                            border: Border.all(color: AppColors.borderDark),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: controller.availableRoles.containsKey(player.sportRole)
                                  ? player.sportRole
                                  : controller.availableRoles.keys.first,
                              dropdownColor: AppColors.card,
                              icon: const Icon(Icons.arrow_drop_down_rounded, color: AppColors.muted, size: 18),
                              style: AppTypography.bodySm.copyWith(
                                color: AppColors.accent,
                                fontWeight: FontWeight.w600,
                                fontSize: context.responsiveFont(12),
                              ),
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
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline_rounded, color: AppColors.error, size: 22),
                    onPressed: () => controller.removePlayer(player.userId),
                  ),
                ],
              ),
            );
          },
        )),

        SizedBox(height: context.heightPct(2.5)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Add Players",
              style: AppTypography.headlineSm.copyWith(
                color: AppColors.textPrimary,
                fontSize: context.responsiveFont(16),
                fontWeight: FontWeight.bold,
              ),
            ),
            Obx(() {
              if (controller.selectedPlayers.any((p) => p.userId == controller.currentUserId)) {
                return const SizedBox.shrink();
              }
              return TextButton.icon(
                onPressed: controller.addCurrentUserAction,
                icon: const Icon(Icons.person_add_rounded, color: AppColors.accent, size: 18),
                label: Text(
                  "Add Myself",
                  style: AppTypography.labelCaps10.copyWith(
                    color: AppColors.accent,
                    fontSize: context.responsiveFont(12),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }),
          ],
        ),
        SizedBox(height: context.heightPct(1.2)),

        CommonTextField(
          controller: controller.searchController,
          hintText: "Search name or username...",
          prefixIcon: const Icon(Icons.search_rounded, color: AppColors.accent),
          onChanged: (val) {
            controller.searchPlayers(val);
          },
        ),
        SizedBox(height: context.heightPct(1.5)),

        // Search Results
        Obx(() {
          if (controller.isSearching.value) {
            return const Center(child: CircularProgressIndicator(color: AppColors.accent));
          }

          if (controller.searchController.text.isNotEmpty && controller.searchResults.isEmpty) {
            return Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: context.heightPct(2)),
                child: Text(
                  "No players found",
                  style: AppTypography.bodyMd.copyWith(
                    color: AppColors.muted,
                    fontSize: context.responsiveFont(13),
                  ),
                ),
              ),
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
                      ? const Icon(Icons.person_rounded, color: AppColors.muted)
                      : null,
                ),
                title: Row(
                  children: [
                    Expanded(
                      child: Text(
                        result['name'],
                        style: AppTypography.bodyLg.copyWith(
                          color: AppColors.textPrimary,
                          fontSize: context.responsiveFont(14),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (result['isFriend'] == true) ...[
                      SizedBox(width: context.widthPct(1.5)),
                      const Icon(Icons.handshake_rounded, color: AppColors.accent, size: 16),
                    ],
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.add_circle_rounded, color: AppColors.accent),
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
