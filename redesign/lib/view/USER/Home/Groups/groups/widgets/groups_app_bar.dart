import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:redesign/view/USER/Home/Groups/create_group/create_group_screen.dart';
import 'package:redesign/theme/responsive_helper.dart';

const kSurface = Color(0xFF0E0E0E);
const kMuted = Colors.white70;

class GroupsAppBar extends StatelessWidget {
  GroupsAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return SliverToBoxAdapter(
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.7),
              border: Border(
                bottom: BorderSide(color: Colors.white12),
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: EdgeInsets.fromLTRB(16, 12, 16, 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    /// TEXT
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Groups',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: ResponsiveHelper.sp(22),
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Play together. Compete harder.',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: kMuted,
                              fontSize: ResponsiveHelper.sp(13),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(width: 12),

                    /// ACTION ICONS
                    _HeaderIcon(
                      icon: Icons.group_add,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CreateGroupScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HeaderIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  _HeaderIcon({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return InkWell(
      borderRadius: BorderRadius.circular(ResponsiveHelper.w(999)),
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(ResponsiveHelper.w(10)),
        decoration: BoxDecoration(
          color: kSurface,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}
