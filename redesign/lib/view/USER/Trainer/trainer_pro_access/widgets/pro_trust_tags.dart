import 'package:flutter/material.dart';
import 'package:redesign/theme/responsive_helper.dart';

const kMuted = Color(0xFFA7A7A7);

class ProTrustTags extends StatelessWidget {
  ProTrustTags({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final tags = [
      ProTrustTag(icon: Icons.verified, label: 'VERIFIED'),
      ProTrustTag(icon: Icons.flash_on, label: 'INSTANT'),
      ProTrustTag(icon: Icons.public, label: 'GLOBAL'),
      ProTrustTag(icon: Icons.workspace_premium, label: 'PREMIER'),
    ];

    return SizedBox(
      height: ResponsiveHelper.h(34),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
        itemCount: tags.length,
        separatorBuilder: (_, __) => SizedBox(width: 14),
        itemBuilder: (_, i) => tags[i],
      ),
    );
  }
}

class ProTrustTag extends StatelessWidget {
  final IconData icon;
  final String label;

  ProTrustTag({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: kMuted),
        SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            color: kMuted,
            fontSize: ResponsiveHelper.sp(11.5),
            fontWeight: FontWeight.w600,
            letterSpacing: 0.6,
          ),
        ),
      ],
    );
  }
}
