import 'package:flutter/material.dart';
import 'package:redesign/theme/responsive_helper.dart';

const kSurface = Color(0xFF0E0E0E);
const kMuted = Color(0xFFA7A7A7);

class FeeSuccessSimpleCard extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final Widget? trailing;

  FeeSuccessSimpleCard({
    super.key,
    required this.title,
    required this.children,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      decoration: BoxDecoration(
        color: kSurface,
        borderRadius: BorderRadius.circular(ResponsiveHelper.w(18)),
      ),
      padding: EdgeInsets.all(ResponsiveHelper.w(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: TextStyle(
                  color: kMuted,
                  fontSize: ResponsiveHelper.sp(12),
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                ),
              ),
              Spacer(),
              if (trailing != null) trailing!,
            ],
          ),
          SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}
