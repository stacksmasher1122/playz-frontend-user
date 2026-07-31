import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Groups_Controller/groups_controller.dart';
import 'package:redesign/model/User_Models/Home_Models/Groups_Model/groups_model.dart';
import 'package:redesign/theme/responsive_helper.dart';

class SearchAndFilters extends StatefulWidget {
  const SearchAndFilters({super.key});

  @override
  State<SearchAndFilters> createState() => _SearchAndFiltersState();
}

class _SearchAndFiltersState extends State<SearchAndFilters> {
  final TextEditingController _searchCtrl = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  Timer? _debounce;

  @override
  void dispose() {
    _searchCtrl.dispose();
    _focusNode.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      Get.find<GroupsController>().searchGroups(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final ctrl = Get.find<GroupsController>();

    return Padding(
      padding: EdgeInsets.fromLTRB(
        context.widthPct(4),
        context.heightPct(1.2),
        context.widthPct(4),
        context.heightPct(0.8),
      ),
      child: Column(
        children: [
          // ── Search Bar ──
          Container(
            padding: EdgeInsets.symmetric(horizontal: context.widthPct(3.5)),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(context.minDimensionPct(10)),
              border: Border.all(color: AppColors.borderDark),
            ),
            child: TextField(
              controller: _searchCtrl,
              focusNode: _focusNode,
              style: AppTypography.bodySm.copyWith(
                color: AppColors.textPrimary,
                fontSize: context.responsiveFont(14),
              ),
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                icon: const Icon(Icons.search, color: AppColors.muted),
                hintText: 'Search groups to join...',
                hintStyle: AppTypography.bodySm.copyWith(
                  color: AppColors.muted,
                  fontSize: context.responsiveFont(14),
                ),
                border: InputBorder.none,
                suffixIcon: Obx(() {
                  if (ctrl.searchQuery.value.isEmpty) {
                    return const SizedBox.shrink();
                  }
                  return IconButton(
                    icon: const Icon(Icons.close, color: AppColors.muted, size: 18),
                    onPressed: () {
                      _searchCtrl.clear();
                      ctrl.searchGroups('');
                      _focusNode.unfocus();
                    },
                  );
                }),
              ),
            ),
          ),

          // ── Search Results ──
          Obx(() {
            if (ctrl.searchQuery.value.isEmpty) return const SizedBox.shrink();

            if (ctrl.isSearching.value) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: context.heightPct(2)),
                child: Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: const CircularProgressIndicator(
                      color: AppColors.accent,
                      strokeWidth: 2,
                    ),
                  ),
                ),
              );
            }

            if (ctrl.searchResults.isEmpty) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: context.heightPct(1.5)),
                child: Center(
                  child: Text(
                    'No groups found for "${ctrl.searchQuery.value}"',
                    style: AppTypography.bodySm.copyWith(
                      color: AppColors.muted,
                      fontSize: context.responsiveFont(13),
                    ),
                  ),
                ),
              );
            }

            return Container(
              margin: EdgeInsets.only(top: context.heightPct(1)),
              constraints: BoxConstraints(maxHeight: context.heightPct(35)),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(context.minDimensionPct(4)),
                border: Border.all(color: AppColors.borderDark),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(context.minDimensionPct(4)),
                child: ListView.separated(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  physics: const BouncingScrollPhysics(),
                  itemCount: ctrl.searchResults.length,
                  separatorBuilder: (_, __) => Divider(
                    height: context.heightPct(0.1),
                    color: AppColors.borderDark,
                    indent: context.widthPct(16),
                  ),
                  itemBuilder: (context, i) {
                    final group = ctrl.searchResults[i];
                    return _SearchResultTile(group: group);
                  },
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _SearchResultTile extends StatefulWidget {
  final GroupModel group;

  const _SearchResultTile({required this.group});

  @override
  State<_SearchResultTile> createState() => _SearchResultTileState();
}

class _SearchResultTileState extends State<_SearchResultTile> {
  bool _actionTaken = false;

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final ctrl = Get.find<GroupsController>();
    final group = widget.group;
    final memberCount = group.members.length;
    final avatarRadius = context.minDimensionPct(5.5).clamp(20.0, 24.0);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.widthPct(3.5),
        vertical: context.heightPct(1.2),
      ),
      child: Row(
        children: [
          // ── Avatar ──
          Stack(
            clipBehavior: Clip.none,
            children: [
              group.imageUrl.isNotEmpty
                  ? ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: group.imageUrl,
                        width: avatarRadius * 2,
                        height: avatarRadius * 2,
                        fit: BoxFit.cover,
                        placeholder: (_, __) => CircleAvatar(
                          radius: avatarRadius,
                          backgroundColor: AppColors.surface,
                        ),
                        errorWidget: (_, __, ___) => CircleAvatar(
                          radius: avatarRadius,
                          backgroundColor: AppColors.surface,
                          child: const Icon(Icons.group, color: AppColors.muted, size: 20),
                        ),
                      ),
                    )
                  : CircleAvatar(
                      radius: avatarRadius,
                      backgroundColor: AppColors.surface,
                      child: Text(
                        group.name.isNotEmpty ? group.name[0].toUpperCase() : 'G',
                        style: AppTypography.headlineSm.copyWith(
                          color: AppColors.accent,
                          fontSize: context.responsiveFont(18),
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
              if (group.isPlayZGlobalGroup)
                Positioned(
                  bottom: -2,
                  right: -2,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: AppColors.background,
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(1.5),
                    child: const Icon(
                      Icons.verified_rounded,
                      color: Color(0xFF1DB954),
                      size: 16,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(width: context.widthPct(3)),

          // ── Info ──
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        group.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.headlineSm.copyWith(
                          color: AppColors.textPrimary,
                          fontSize: context.responsiveFont(14),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    if (group.isPlayZGlobalGroup) ...[
                      SizedBox(width: context.widthPct(1)),
                      const Icon(
                        Icons.verified_rounded,
                        color: Color(0xFF1DB954),
                        size: 15,
                      ),
                    ],
                    if (!group.isPublic) ...[
                      SizedBox(width: context.widthPct(1)),
                      const Icon(
                        Icons.lock,
                        color: AppColors.muted,
                        size: 12,
                      ),
                    ],
                  ],
                ),
                SizedBox(height: context.heightPct(0.3)),
                Text(
                  '$memberCount member${memberCount == 1 ? '' : 's'} • ${group.sport}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.muted,
                    fontSize: context.responsiveFont(11),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(width: context.widthPct(2)),

          // ── Join / Request Button ──
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: _actionTaken
                ? Container(
                    key: const ValueKey('done'),
                    padding: EdgeInsets.symmetric(
                      horizontal: context.widthPct(3.5),
                      vertical: context.heightPct(0.8),
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(context.minDimensionPct(4)),
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        group.isPublic ? 'Joined' : 'Requested',
                        style: AppTypography.bodySm.copyWith(
                          color: AppColors.accent,
                          fontSize: context.responsiveFont(12),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  )
                : ElevatedButton(
                    key: const ValueKey('action'),
                    onPressed: () async {
                      setState(() => _actionTaken = true);
                      if (group.isPublic) {
                        await ctrl.joinPublicGroup(group);
                      } else {
                        await ctrl.requestToJoinGroup(group);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: group.isPublic ? AppColors.accent : Colors.transparent,
                      foregroundColor:
                          group.isPublic ? AppColors.background : AppColors.accent,
                      elevation: 0,
                      minimumSize: const Size(64, 32),
                      padding: EdgeInsets.symmetric(horizontal: context.widthPct(4)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(context.minDimensionPct(4)),
                        side: group.isPublic
                            ? BorderSide.none
                            : const BorderSide(color: AppColors.accent, width: 1.2),
                      ),
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        group.isPublic ? 'JOIN' : 'REQUEST',
                        style: AppTypography.bodySm.copyWith(
                          color: group.isPublic ? AppColors.background : AppColors.accent,
                          fontSize: context.responsiveFont(11),
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
