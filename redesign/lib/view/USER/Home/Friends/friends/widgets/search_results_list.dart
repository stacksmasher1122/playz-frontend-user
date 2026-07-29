import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class SearchResultsList extends StatelessWidget {
  final List<Map<String, dynamic>> results;
  final Function(Map<String, dynamic>) onAdd;

  const SearchResultsList({
    super.key,
    required this.results,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Material(
      color: Colors.transparent,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: context.heightPct(55),
        ),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(context.minDimensionPct(4)),
          border: Border.all(color: AppColors.borderDark),
          boxShadow: [
            BoxShadow(
              color: AppColors.background.withValues(alpha: 0.7),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(context.minDimensionPct(4)),
          child: ListView.separated(
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(vertical: context.heightPct(1)),
            itemCount: results.length,
            separatorBuilder: (_, __) =>
                const Divider(color: AppColors.borderDark, height: 1),
            itemBuilder: (_, i) {
              final user = results[i];
              return SearchResultTile(user: user, onAdd: () => onAdd(user));
            },
          ),
        ),
      ),
    );
  }
}

class SearchResultTile extends StatefulWidget {
  final Map<String, dynamic> user;
  final VoidCallback onAdd;

  const SearchResultTile({super.key, required this.user, required this.onAdd});

  @override
  State<SearchResultTile> createState() => _SearchResultTileState();
}

class _SearchResultTileState extends State<SearchResultTile> {
  bool _tapped = false;

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final name = widget.user['fullName'] ?? 'Unknown';
    final pic = widget.user['profileImageUrl'] ?? '';
    final alreadyFriend = widget.user['alreadyFriend'] == true;
    final alreadyRequested = widget.user['alreadyRequested'] == true;
    final isPublic = widget.user['isPublicProfile'] ?? true;

    String buttonLabel;
    Color buttonColor;
    Color textColor;
    bool enabled;

    if (alreadyFriend || _tapped) {
      buttonLabel = alreadyFriend ? 'Friends' : (isPublic ? 'Added' : 'Sent');
      buttonColor = AppColors.accent.withValues(alpha: 0.15);
      textColor = AppColors.accent;
      enabled = false;
    } else if (alreadyRequested) {
      buttonLabel = 'Sent';
      buttonColor = AppColors.accent.withValues(alpha: 0.15);
      textColor = AppColors.accent;
      enabled = false;
    } else {
      buttonLabel = isPublic ? 'Add' : 'Request';
      buttonColor = AppColors.accent;
      textColor = AppColors.background;
      enabled = true;
    }

    final avatarSize = context.minDimensionPct(11).clamp(38.0, 48.0);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.widthPct(3.5),
        vertical: context.heightPct(1),
      ),
      child: Row(
        children: [
          ClipOval(
            child: pic.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: pic,
                    width: avatarSize,
                    height: avatarSize,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => CircleAvatar(
                      radius: avatarSize / 2,
                      backgroundColor: AppColors.surface,
                    ),
                    errorWidget: (_, __, ___) => CircleAvatar(
                      radius: avatarSize / 2,
                      backgroundColor: AppColors.surface,
                      child: const Icon(Icons.person, color: AppColors.muted),
                    ),
                  )
                : CircleAvatar(
                    radius: avatarSize / 2,
                    backgroundColor: AppColors.surface,
                    child: const Icon(Icons.person, color: AppColors.muted),
                  ),
          ),
          SizedBox(width: context.widthPct(3)),
          Expanded(
            child: Text(
              name,
              style: AppTypography.headlineSm.copyWith(
                color: AppColors.textPrimary,
                fontSize: context.responsiveFont(15),
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(width: context.widthPct(2)),
          GestureDetector(
            onTap: enabled
                ? () {
                    setState(() => _tapped = true);
                    widget.onAdd();
                  }
                : null,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: EdgeInsets.symmetric(
                horizontal: context.widthPct(4),
                vertical: context.heightPct(1),
              ),
              decoration: BoxDecoration(
                color: buttonColor,
                borderRadius: BorderRadius.circular(context.minDimensionPct(5)),
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  buttonLabel,
                  style: AppTypography.bodySm.copyWith(
                    color: textColor,
                    fontSize: context.responsiveFont(13),
                    fontWeight: FontWeight.w700,
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
