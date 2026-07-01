import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Groups_Controller/groups_controller.dart';
import 'package:redesign/model/User_Models/Home_Models/Groups_Model/groups_model.dart';

const kSurface = Color(0xFF0E0E0E);
const kGreen = AppColors.accent;
const kMuted = Colors.white70;

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
    final ctrl = Get.find<GroupsController>();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Column(
        children: [
          // ── Search Bar ──
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: kSurface,
              borderRadius: BorderRadius.circular(999),
            ),
            child: TextField(
              controller: _searchCtrl,
              focusNode: _focusNode,
              style: const TextStyle(color: Colors.white),
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                icon: const Icon(Icons.search, color: kMuted),
                hintText: 'Search groups to join...',
                hintStyle: const TextStyle(color: kMuted),
                border: InputBorder.none,
                suffixIcon: Obx(() {
                  if (ctrl.searchQuery.value.isEmpty) {
                    return const SizedBox.shrink();
                  }
                  return IconButton(
                    icon: const Icon(Icons.close, color: kMuted, size: 18),
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
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: kGreen,
                      strokeWidth: 2,
                    ),
                  ),
                ),
              );
            }

            if (ctrl.searchResults.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Center(
                  child: Text(
                    'No groups found for "${ctrl.searchQuery.value}"',
                    style: const TextStyle(color: kMuted, fontSize: 13),
                  ),
                ),
              );
            }

            return Container(
              margin: const EdgeInsets.only(top: 8),
              constraints: const BoxConstraints(maxHeight: 300),
              decoration: BoxDecoration(
                color: const Color(0xFF161616),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white10),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: ListView.separated(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  physics: const BouncingScrollPhysics(),
                  itemCount: ctrl.searchResults.length,
                  separatorBuilder: (_, __) => const Divider(
                    height: 1,
                    color: Colors.white10,
                    indent: 70,
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
    final ctrl = Get.find<GroupsController>();
    final group = widget.group;
    final memberCount = group.members.length;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          // ── Avatar ──
          group.imageUrl.isNotEmpty
              ? CircleAvatar(
                  radius: 22,
                  backgroundColor: kSurface,
                  child: ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: group.imageUrl,
                      width: 44,
                      height: 44,
                      fit: BoxFit.cover,
                      errorWidget: (_, __, ___) =>
                          const Icon(Icons.group, color: kMuted, size: 20),
                    ),
                  ),
                )
              : CircleAvatar(
                  radius: 22,
                  backgroundColor: kSurface,
                  child: Text(
                    group.name.isNotEmpty ? group.name[0].toUpperCase() : 'G',
                    style: const TextStyle(
                      color: kGreen,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
          const SizedBox(width: 12),

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
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    if (!group.isPublic) ...[
                      const SizedBox(width: 4),
                      Icon(Icons.lock,
                          color: Colors.white.withValues(alpha: 0.4), size: 12),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  '$memberCount member${memberCount == 1 ? '' : 's'} • ${group.sport}',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.4),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),

          // ── Join / Request Button ──
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: _actionTaken
                ? Container(
                    key: const ValueKey('done'),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 7),
                    decoration: BoxDecoration(
                      color: kGreen.withAlpha(38),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      group.isPublic ? 'Joined' : 'Requested',
                      style: const TextStyle(
                        color: kGreen,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
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
                      backgroundColor: group.isPublic ? kGreen : Colors.transparent,
                      foregroundColor:
                          group.isPublic ? Colors.black : kGreen,
                      elevation: 0,
                      minimumSize: const Size(64, 32),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: group.isPublic
                            ? BorderSide.none
                            : const BorderSide(color: kGreen, width: 1.2),
                      ),
                    ),
                    child: Text(
                      group.isPublic ? 'JOIN' : 'REQUEST',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
