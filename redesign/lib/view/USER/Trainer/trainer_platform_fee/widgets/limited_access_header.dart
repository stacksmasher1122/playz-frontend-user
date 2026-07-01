import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:redesign/theme/responsive_helper.dart';

const kMuted = Color(0xFFA7A7A7);

class LimitedAccessHeader extends StatelessWidget {
  LimitedAccessHeader({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return SliverToBoxAdapter(
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
          child: Container(
            color: Colors.black.withValues(alpha: 0.7),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: EdgeInsets.fromLTRB(16, 12, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Limited Access Mode',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: ResponsiveHelper.sp(20),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'You can upgrade anytime',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: kMuted,
                        fontSize: ResponsiveHelper.sp(13),
                      ),
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
