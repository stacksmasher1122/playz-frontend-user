import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Groups_Controller/group_info_controller.dart';
import 'package:redesign/theme/responsive_helper.dart';

class AddMembersTile extends StatelessWidget {
  final GroupInfoController ctrl;

  const AddMembersTile({super.key, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final avatarSize = context.minDimensionPct(11).clamp(40.0, 48.0);

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: avatarSize,
        height: avatarSize,
        decoration: BoxDecoration(
          color: AppColors.accent.withValues(alpha: 0.2),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.person_add, color: AppColors.accent),
      ),
      title: Text(
        "Add Members",
        style: AppTypography.headlineSm.copyWith(
          color: AppColors.textPrimary,
          fontSize: context.responsiveFont(15),
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: () => _showAddMembersSheet(context),
    );
  }

  void _showAddMembersSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.8,
          builder: (_, controller) {
            return Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.vertical(top: Radius.circular(context.minDimensionPct(6))),
              ),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(
                      top: context.heightPct(1.5),
                      bottom: context.heightPct(1),
                    ),
                    width: context.widthPct(10),
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.borderDark,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(context.widthPct(4)),
                    child: Text(
                      "Add Members",
                      style: AppTypography.headlineSm.copyWith(
                        color: AppColors.textPrimary,
                        fontSize: context.responsiveFont(18),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: context.widthPct(4)),
                    child: TextField(
                      style: AppTypography.bodySm.copyWith(
                        color: AppColors.textPrimary,
                        fontSize: context.responsiveFont(14),
                      ),
                      decoration: InputDecoration(
                        hintText: "Search name or email...",
                        hintStyle: AppTypography.bodySm.copyWith(
                          color: AppColors.muted,
                          fontSize: context.responsiveFont(14),
                        ),
                        prefixIcon: const Icon(Icons.search, color: AppColors.muted),
                        filled: true,
                        fillColor: AppColors.card,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(context.minDimensionPct(3)),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: (val) => ctrl.searchUsers(val),
                    ),
                  ),
                  Expanded(
                    child: Obx(() {
                      final results = ctrl.searchResults;
                      if (results.isEmpty) {
                        return Center(
                          child: Text(
                            "Search to find people",
                            style: AppTypography.bodySm.copyWith(
                              color: AppColors.muted,
                              fontSize: context.responsiveFont(14),
                            ),
                          ),
                        );
                      }
                      return ListView.builder(
                        controller: controller,
                        padding: EdgeInsets.all(context.widthPct(4)),
                        itemCount: results.length,
                        itemBuilder: (context, index) {
                          final user = results[index];
                          final email = user['email'] ?? '';
                          final name = user['fullName'] ?? user['Name'] ?? email;
                          final picUrl = user['profileImageUrl'] ?? '';
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: AppColors.card,
                              backgroundImage: picUrl.isNotEmpty ? CachedNetworkImageProvider(picUrl) : null,
                              child: picUrl.isEmpty ? const Icon(Icons.person, color: AppColors.muted) : null,
                            ),
                            title: Text(
                              name,
                              style: AppTypography.bodySm.copyWith(
                                color: AppColors.textPrimary,
                                fontSize: context.responsiveFont(14),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              email,
                              style: AppTypography.bodySm.copyWith(
                                color: AppColors.muted,
                                fontSize: context.responsiveFont(12),
                              ),
                            ),
                            trailing: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.accent,
                                foregroundColor: AppColors.background,
                              ),
                              onPressed: () => ctrl.addMember(email, user),
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  "ADD",
                                  style: AppTypography.bodySm.copyWith(
                                    color: AppColors.background,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
