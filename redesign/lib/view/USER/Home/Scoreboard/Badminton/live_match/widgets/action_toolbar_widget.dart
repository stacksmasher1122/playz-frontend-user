import 'package:flutter/material.dart';

class ActionToolbarWidget extends StatelessWidget {
  final VoidCallback onUndo;
  final VoidCallback onPause;
  final VoidCallback onEndMatch;
  final bool isPaused;

  const ActionToolbarWidget({
    super.key,
    required this.onUndo,
    required this.onPause,
    required this.onEndMatch,
    required this.isPaused,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.grey.shade900,
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _ActionButton(
            icon: Icons.undo_rounded,
            label: 'Undo',
            color: Colors.white,
            onTap: onUndo,
          ),
          _ActionButton(
            icon: isPaused ? Icons.play_arrow_rounded : Icons.pause_rounded,
            label: isPaused ? 'Resume' : 'Pause',
            color: Colors.white,
            onTap: onPause,
          ),
          _ActionButton(
            icon: Icons.cancel_outlined,
            label: 'End Match',
            color: Colors.red.shade400,
            onTap: onEndMatch,
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
