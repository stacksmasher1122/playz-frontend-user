import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:redesign/theme/responsive_helper.dart';

const kMuted = Color(0xFFA7A7A7);

class ProBlurredHeader extends StatelessWidget {
  ProBlurredHeader({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final topInset = MediaQuery.of(context).padding.top;

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          padding: EdgeInsets.fromLTRB(16, topInset + 12, 16, 16),
          decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.6)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.arrow_back, color: Colors.white),
              SizedBox(height: 10),
              Text(
                'Trainer Pro Access',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: ResponsiveHelper.sp(20),
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Invest in your coaching career',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: kMuted, fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
