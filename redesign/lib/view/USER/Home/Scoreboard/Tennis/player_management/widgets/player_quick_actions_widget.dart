import 'package:flutter/material.dart';
import '../../../../../../../theme/app_colors.dart';
import '../../../../../../../theme/app_typography.dart';
import '../../../../../../../theme/app_dimensions.dart';

class PlayerQuickActionsWidget extends StatefulWidget {
  const PlayerQuickActionsWidget({super.key});

  @override
  State<PlayerQuickActionsWidget> createState() =>
      _PlayerQuickActionsWidgetState();
}

class _PlayerQuickActionsWidgetState extends State<PlayerQuickActionsWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildActionButton(
            icon: Icons.group_add,
            iconColor: AppColors.onSurfaceVariant,
            label: 'EXISTING',
            onTap: () => debugPrint("Existing clicked"),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildActionButton(
            icon: Icons.person_add,
            iconColor: AppColors.primaryContainer,
            label: 'CREATE NEW',
            onTap: () => debugPrint("Create New clicked"),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color iconColor,
    required String label,
    required VoidCallback onTap,
  }) {
    return _ActionButtonItem(
      icon: icon,
      iconColor: iconColor,
      label: label,
      onTap: onTap,
    );
  }
}

class _ActionButtonItem extends StatefulWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final VoidCallback onTap;

  const _ActionButtonItem({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.onTap,
  });

  @override
  State<_ActionButtonItem> createState() => _ActionButtonItemState();
}

class _ActionButtonItemState extends State<_ActionButtonItem> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.surfaceContainer,
            borderRadius: BorderRadius.circular(AppDimensions.borderRadiusXl),
            border: Border.all(
              color: isHovered
                  ? AppColors.primaryContainer.withValues(alpha: 0.3)
                  : Colors.white10,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(widget.icon, color: widget.iconColor, size: 20),
              const SizedBox(width: 8),
              Text(
                widget.label,
                style: AppTypography.labelCaps10.copyWith(
                  color: AppColors.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
