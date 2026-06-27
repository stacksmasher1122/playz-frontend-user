import 'package:flutter/material.dart';

const kMuted = Color(0xFFA7A7A7);

class ProTrustTags extends StatelessWidget {
  const ProTrustTags({super.key});

  @override
  Widget build(BuildContext context) {
    final tags = const [
      ProTrustTag(icon: Icons.verified, label: 'VERIFIED'),
      ProTrustTag(icon: Icons.flash_on, label: 'INSTANT'),
      ProTrustTag(icon: Icons.public, label: 'GLOBAL'),
      ProTrustTag(icon: Icons.workspace_premium, label: 'PREMIER'),
    ];

    return SizedBox(
      height: 34,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: tags.length,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (_, i) => tags[i],
      ),
    );
  }
}

class ProTrustTag extends StatelessWidget {
  final IconData icon;
  final String label;

  const ProTrustTag({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: kMuted),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            color: kMuted,
            fontSize: 11.5,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.6,
          ),
        ),
      ],
    );
  }
}
