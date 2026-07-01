import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class PlayerActions extends StatelessWidget {
  final VoidCallback onCreate;
  final VoidCallback onSelect;
  final VoidCallback onImport;

  PlayerActions({
    super.key,
    required this.onCreate,
    required this.onSelect,
    required this.onImport,
  });

  Widget _buildButton({
    required String text,
    required IconData icon,
    required Color bgColor,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return _AnimatedActionBtn(
      text: text,
      icon: icon,
      bgColor: bgColor,
      textColor: textColor,
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Column(
      children: [
        _buildButton(
          text: 'CREATE NEW PLAYER',
          icon: Icons.person_add_alt_1_outlined,
          bgColor: AppColors.primaryContainer,
          textColor: Colors.black,
          onTap: onCreate,
        ),
        SizedBox(height: 12),
        _buildButton(
          text: 'SELECT EXISTING',
          icon: Icons.search,
          bgColor: AppColors.surfaceContainerHighest,
          textColor: AppColors.primary,
          onTap: onSelect,
        ),
        SizedBox(height: 12),
        _buildButton(
          text: 'IMPORT FROM TOURNAMENT',
          icon: Icons.cloud_download_outlined,
          bgColor: AppColors.surfaceContainerHighest,
          textColor: AppColors.primary,
          onTap: onImport,
        ),
      ],
    );
  }
}

class _AnimatedActionBtn extends StatefulWidget {
  final String text;
  final IconData icon;
  final Color bgColor;
  final Color textColor;
  final VoidCallback onTap;

  _AnimatedActionBtn({
    required this.text,
    required this.icon,
    required this.bgColor,
    required this.textColor,
    required this.onTap,
  });

  @override
  State<_AnimatedActionBtn> createState() => _AnimatedActionBtnState();
}

class _AnimatedActionBtnState extends State<_AnimatedActionBtn> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 100));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: Tween<double>(begin: 1.0, end: 0.97).animate(_controller),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(16)),
          decoration: BoxDecoration(
            color: widget.bgColor,
            borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(widget.icon, color: widget.textColor, size: 20),
              SizedBox(width: 8),
              Text(
                widget.text,
                style: AppTypography.labelCaps.copyWith(color: widget.textColor, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
