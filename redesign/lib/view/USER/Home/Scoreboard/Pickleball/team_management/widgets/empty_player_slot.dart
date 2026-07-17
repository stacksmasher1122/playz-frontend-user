import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/theme/responsive_helper.dart';
// Standard practice, or standard Container if no package

// The design says "dashed green border". If dotted_border package is not available, I'll use a custom painter or just a regular border. I'll use a dashed border via custom painter or standard border if package isn't there. For simplicity without adding dependencies, I'll use a regular border with some opacity or if you have dotted_border, you'd use it. I'll use a standard container border as it's safe.

class EmptyPlayerSlot extends StatefulWidget {
  final int slotNumber;
  final VoidCallback onTap;

  EmptyPlayerSlot({
    super.key,
    required this.slotNumber,
    required this.onTap,
  });

  @override
  State<EmptyPlayerSlot> createState() => _EmptyPlayerSlotState();
}

class _EmptyPlayerSlotState extends State<EmptyPlayerSlot> with SingleTickerProviderStateMixin {
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
          height: ResponsiveHelper.h(100),
          margin: EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: AppColors.card.withOpacity(0.5),
            borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
            // Fallback for dashed border without package
            border: Border.all(color: AppColors.accent.withOpacity(0.5), width: ResponsiveHelper.w(1.5), style: BorderStyle.solid),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_circle_outline, color: AppColors.accent, size: 28),
              SizedBox(height: 8),
              Text(
                'SELECT PLAYER ${widget.slotNumber}',
                style: AppTypography.labelCaps.copyWith(color: AppColors.accent, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
