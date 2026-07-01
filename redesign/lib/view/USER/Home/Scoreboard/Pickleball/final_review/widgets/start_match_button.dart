import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';

class StartMatchButton extends StatefulWidget {
  final bool isStarting;
  final VoidCallback onTap;

  StartMatchButton({
    super.key,
    required this.isStarting,
    required this.onTap,
  });

  @override
  State<StartMatchButton> createState() => _StartMatchButtonState();
}

class _StartMatchButtonState extends State<StartMatchButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 150));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      color: AppColors.background,
      padding: EdgeInsets.all(ResponsiveHelper.w(16)).copyWith(
        bottom: MediaQuery.of(context).padding.bottom + 16,
      ),
      child: GestureDetector(
        onTapDown: (_) => _controller.forward(),
        onTapUp: (_) {
          _controller.reverse();
          if (!widget.isStarting) widget.onTap();
        },
        onTapCancel: () => _controller.reverse(),
        child: ScaleTransition(
          scale: Tween<double>(begin: 1.0, end: 0.97).animate(_controller),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 300),
            width: double.infinity,
            height: ResponsiveHelper.h(56),
            decoration: BoxDecoration(
              color: AppColors.primaryContainer,
              borderRadius: BorderRadius.circular(ResponsiveHelper.w(14)),
              boxShadow: widget.isStarting ? [] : [
                BoxShadow(
                  color: AppColors.primaryContainer.withOpacity(0.4),
                  blurRadius: 16,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: AnimatedSwitcher(
                duration: Duration(milliseconds: 200),
                child: widget.isStarting
                    ? SizedBox(
                        width: ResponsiveHelper.w(24),
                        height: ResponsiveHelper.h(24),
                        child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2.5),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.play_arrow, color: Colors.black, size: 24),
                          SizedBox(width: 8),
                          Text(
                            'Start Match',
                            style: AppTypography.headlineMd.copyWith(color: Colors.black, fontWeight: FontWeight.w900),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
