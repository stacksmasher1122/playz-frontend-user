import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';

class MatchControlsWidget extends StatelessWidget {
  final VoidCallback onUndo;
  final VoidCallback onTimeout;
  final VoidCallback onPause;
  final bool isPaused;

  const MatchControlsWidget({
    super.key,
    required this.onUndo,
    required this.onTimeout,
    required this.onPause,
    required this.isPaused,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ControlCard(
            icon: Icons.undo,
            label: 'UNDO',
            onTap: onUndo,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _ControlCard(
            icon: Icons.timer_outlined,
            label: 'TIMEOUT',
            onTap: onTimeout,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _ControlCard(
            icon: isPaused ? Icons.play_arrow : Icons.pause,
            label: isPaused ? 'RESUME' : 'PAUSE',
            onTap: onPause,
          ),
        ),
      ],
    );
  }
}

class _ControlCard extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ControlCard({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  State<_ControlCard> createState() => _ControlCardState();
}

class _ControlCardState extends State<_ControlCard> with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(vsync: this, duration: const Duration(milliseconds: 100));
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _scaleController.forward(),
      onTapUp: (_) {
        _scaleController.reverse();
        widget.onTap();
      },
      onTapCancel: () => _scaleController.reverse(),
      child: ScaleTransition(
        scale: Tween<double>(begin: 1.0, end: 0.95).animate(_scaleController),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.surfaceContainerHighest, width: 1),
          ),
          child: Column(
            children: [
              Icon(widget.icon, color: AppColors.muted, size: 24),
              const SizedBox(height: 8),
              Text(
                widget.label,
                style: AppTypography.labelCaps10.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
