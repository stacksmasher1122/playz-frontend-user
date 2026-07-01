import 'package:flutter/material.dart';
import 'package:redesign/view/USER/Maps/maps_constants.dart';
import 'package:redesign/theme/responsive_helper.dart';


class LocationTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String? tag;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  LocationTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.tag,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(ResponsiveHelper.w(14)),
      decoration: BoxDecoration(
        color: kCard.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(ResponsiveHelper.w(10)),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(ResponsiveHelper.w(10)),
            ),
            child: Icon(icon, color: Colors.white70, size: 20),
          ),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        title,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (tag != null) ...[
                      SizedBox(width: 8),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: kSpotifyGreen.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(ResponsiveHelper.w(4)),
                        ),
                        child: Text(
                          tag!,
                          style: TextStyle(
                            color: kSpotifyGreen,
                            fontSize: ResponsiveHelper.sp(8),
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(color: kMuted, fontSize: 12),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (onEdit != null || onDelete != null)
            PopupMenuButton<String>(
              icon: Icon(
                Icons.more_vert,
                color: Colors.white54,
                size: 20,
              ),
              color: kSurface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
                side: BorderSide(color: Colors.white12),
              ),
              onSelected: (val) {
                if (val == 'edit') {
                  onEdit?.call();
                } else if (val == 'delete') {
                  onDelete?.call();
                }
              },
              itemBuilder: (context) => [
                if (onEdit != null)
                  PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(
                          Icons.edit_outlined,
                          color: kSpotifyGreen,
                          size: 18,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Edit',
                          style: TextStyle(color: Colors.white, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                if (onDelete != null)
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(
                          Icons.delete_outline,
                          color: Colors.redAccent,
                          size: 18,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Delete',
                          style: TextStyle(color: Colors.white, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}
