import 'package:flutter/material.dart';

class StatusBadge extends StatelessWidget {
  final String label;
  final Color color;
  final Color? textColor;

  const StatusBadge(this.label, this.color, {super.key, this.textColor});

  @override
  Widget build(BuildContext context) {
    final resolvedTextColor = textColor ?? color;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12), // soft fill
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: color.withOpacity(0.6), // 🔥 outline
          width: 1,
        ),
      ),
      child: Text(
        label.toUpperCase(),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: resolvedTextColor,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.6,
        ),
      ),
    );
  }
}
