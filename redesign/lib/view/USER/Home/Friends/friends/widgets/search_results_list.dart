import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/responsive_helper.dart';

const kSurface = Color(0xFF0E0E0E);
const kGreen = AppColors.accent;
const kMuted = Colors.white70;

class SearchResultsList extends StatelessWidget {
  final List<Map<String, dynamic>> results;
  final Function(Map<String, dynamic>) onAdd;

  SearchResultsList({
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
          maxHeight: MediaQuery.of(context).size.height * 0.55,
        ),
        decoration: BoxDecoration(
          color: Color(0xFF141414),
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(18)),
          border: Border.all(color: Colors.white.withAlpha(12)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(180),
              blurRadius: 24,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(18)),
          child: ListView.separated(
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(8)),
            itemCount: results.length,
            separatorBuilder: (_, __) =>
                Divider(color: Colors.white10, height: 1),
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

  SearchResultTile({super.key, required this.user, required this.onAdd});

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
      buttonColor = kGreen.withAlpha(38);
      textColor = kGreen;
      enabled = false;
    } else if (alreadyRequested) {
      buttonLabel = 'Sent';
      buttonColor = kGreen.withAlpha(38);
      textColor = kGreen;
      enabled = false;
    } else {
      buttonLabel = isPublic ? 'Add' : 'Request';
      buttonColor = kGreen;
      textColor = Colors.black;
      enabled = true;
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(14), vertical: ResponsiveHelper.h(8)),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundImage: pic.isNotEmpty
                ? CachedNetworkImageProvider(pic) as ImageProvider
                : null,
            backgroundColor: kSurface,
            child: pic.isEmpty
                ? Icon(Icons.person, color: kMuted)
                : null,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              name,
              style: TextStyle(
                color: Colors.white,
                fontSize: ResponsiveHelper.sp(15),
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          GestureDetector(
            onTap: enabled
                ? () {
                    setState(() => _tapped = true);
                    widget.onAdd();
                  }
                : null,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 250),
              padding:
                  EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16), vertical: ResponsiveHelper.h(8)),
              decoration: BoxDecoration(
                color: buttonColor,
                borderRadius: BorderRadius.circular(ResponsiveHelper.w(20)),
              ),
              child: Text(
                buttonLabel,
                style: TextStyle(
                  color: textColor,
                  fontSize: ResponsiveHelper.sp(13),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
