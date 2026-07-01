import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../../../../theme/app_colors.dart';
import '../../../../../../../theme/app_typography.dart';

class PmAppbarWidget extends StatefulWidget {
  const PmAppbarWidget({super.key});

  @override
  State<PmAppbarWidget> createState() => _PmAppbarWidgetState();
}

class _PmAppbarWidgetState extends State<PmAppbarWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.8),
        border: const Border(
          bottom: BorderSide(color: Colors.white10, width: 1),
        ),
      ),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 12.0,
            ),
            child: Row(
              children: [
                // Profile Image
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white10, width: 1),
                    image: const DecorationImage(
                      image: NetworkImage(
                        'https://images.unsplash.com/photo-1599566150163-29194dcaad36?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&q=80',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Title
                Text(
                  'PlayZ Match Center',
                  style: AppTypography.headlineSora.copyWith(
                    color: AppColors.primaryContainer,
                  ),
                ),

                const Spacer(),

                // Action Buttons
                _buildIconButton(Icons.search),
                const SizedBox(width: 8),
                _buildIconButton(Icons.settings),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIconButton(IconData icon) {
    return _IconButtonItem(icon: icon);
  }
}

class _IconButtonItem extends StatefulWidget {
  final IconData icon;

  const _IconButtonItem({required this.icon});

  @override
  State<_IconButtonItem> createState() => _IconButtonItemState();
}

class _IconButtonItemState extends State<_IconButtonItem> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.transparent,
        ),
        child: Icon(
          widget.icon,
          color: isHovered
              ? AppColors.primaryContainer
              : AppColors.onSurfaceVariant,
          size: 24,
        ),
      ),
    );
  }
}
