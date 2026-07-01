import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../controller/User_Controller/Home_Controller/Scoreboard_Controller/Tennis/player_management_controller.dart';
import '../../../../../../../theme/app_colors.dart';
import '../../../../../../../theme/app_typography.dart';
import '../../../../../../../theme/app_dimensions.dart';

class SuggestedPlayersWidget extends StatefulWidget {
  const SuggestedPlayersWidget({super.key});

  @override
  State<SuggestedPlayersWidget> createState() => _SuggestedPlayersWidgetState();
}

class _SuggestedPlayersWidgetState extends State<SuggestedPlayersWidget> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PlayerManagementController>();

    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingLg),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusXl),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'SUGGESTED FROM RECENT MATCHES',
            style: AppTypography.labelCaps10.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ...controller.suggestedPlayers.map(
                  (player) => _buildSuggestedPlayer(player, controller),
                ),
                _buildMoreButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestedPlayer(player, PlayerManagementController controller) {
    return _SuggestedPlayerItem(player: player, controller: controller);
  }

  Widget _buildMoreButton() {
    return const _MoreButton();
  }
}

class _SuggestedPlayerItem extends StatefulWidget {
  final dynamic player;
  final PlayerManagementController controller;

  const _SuggestedPlayerItem({required this.player, required this.controller});

  @override
  State<_SuggestedPlayerItem> createState() => _SuggestedPlayerItemState();
}

class _SuggestedPlayerItemState extends State<_SuggestedPlayerItem> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: MouseRegion(
        onEnter: (_) => setState(() => isHovered = true),
        onExit: (_) => setState(() => isHovered = false),
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () => widget.controller.selectPlayerB(widget.player),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white10),
            ),
            child: ClipOval(
              child: ColorFiltered(
                colorFilter: isHovered
                    ? const ColorFilter.mode(
                        Colors.transparent,
                        BlendMode.multiply,
                      )
                    : const ColorFilter.matrix([
                        0.2126,
                        0.7152,
                        0.0722,
                        0,
                        0,
                        0.2126,
                        0.7152,
                        0.0722,
                        0,
                        0,
                        0.2126,
                        0.7152,
                        0.0722,
                        0,
                        0,
                        0,
                        0,
                        0,
                        1,
                        0,
                      ]), // Grayscale filter
                child: Image.network(
                  widget.player.imagePath,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MoreButton extends StatefulWidget {
  const _MoreButton();

  @override
  State<_MoreButton> createState() => _MoreButtonState();
}

class _MoreButtonState extends State<_MoreButton> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isHovered
              ? AppColors.surfaceContainerHigh
              : AppColors.surfaceContainerHighest,
          border: Border.all(color: Colors.white10),
        ),
        child: const Center(
          child: Icon(Icons.more_horiz, color: AppColors.onSurfaceVariant),
        ),
      ),
    );
  }
}
