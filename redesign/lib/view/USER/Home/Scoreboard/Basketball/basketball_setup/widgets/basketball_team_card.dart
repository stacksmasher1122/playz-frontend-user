import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/app_dimensions.dart';
import '../../../../../../../model/User_Models/Home_Models/Friends_Model/friends_model.dart';

class BasketballTeamCard extends StatelessWidget {
  final TextEditingController textController;
  final bool isHome;
  final List<FriendModel> selectedPlayers;
  final VoidCallback onAddPlayer;
  final Function(FriendModel) onRemovePlayer;

  const BasketballTeamCard({
    super.key,
    required this.textController,
    required this.isHome,
    required this.selectedPlayers,
    required this.onAddPlayer,
    required this.onRemovePlayer,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingLg),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.accent, shape: BoxShape.circle)),
              const SizedBox(width: AppDimensions.paddingMd),
              Expanded(
                child: TextField(
                  controller: textController,
                  style: AppTypography.headlineLgMobile.copyWith(color: Colors.white),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: isHome ? 'Home Team' : 'Away Team',
                    hintStyle: AppTypography.headlineLgMobile.copyWith(color: Colors.grey),
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle, color: AppColors.accent),
                onPressed: onAddPlayer,
              )
            ],
          ),
          const Divider(color: AppColors.surface, height: AppDimensions.paddingXl),
          if (selectedPlayers.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppDimensions.paddingLg),
              child: Center(
                child: Text('No players added yet.', style: AppTypography.bodySm.copyWith(color: Colors.grey)),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: selectedPlayers.length,
              itemBuilder: (context, index) {
                final friend = selectedPlayers[index];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    backgroundImage: friend.profileImageUrl.isNotEmpty
                        ? NetworkImage(friend.profileImageUrl)
                        : null,
                    backgroundColor: AppColors.surface,
                    child: (friend.profileImageUrl.isEmpty)
                        ? const Icon(Icons.person, color: Colors.white)
                        : null,
                  ),
                  title: Text(friend.fullName, style: AppTypography.bodyLg.copyWith(color: Colors.white)),
                  trailing: IconButton(
                    icon: const Icon(Icons.remove_circle_outline, color: AppColors.error),
                    onPressed: () => onRemovePlayer(friend),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
