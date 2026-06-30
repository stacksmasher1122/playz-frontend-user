import 'package:flutter/material.dart';

class MomentumGraphWidget extends StatelessWidget {
  final List<double> momentumBars; // Normalized values 0.0 to 1.0

  const MomentumGraphWidget({
    super.key,
    required this.momentumBars,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double spacing = 4.0;
        final double barWidth = (constraints.maxWidth - (spacing * (momentumBars.length - 1))) / momentumBars.length;
        
        return SizedBox(
          height: 40,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: momentumBars.map((value) {
              return _AnimatedMomentumBar(
                width: barWidth,
                height: 40 * value,
                value: value,
              );
            }).toList(),
          ),
        );
      },
    );
  }
}

class _AnimatedMomentumBar extends StatefulWidget {
  final double width;
  final double height;
  final double value;

  const _AnimatedMomentumBar({
    required this.width,
    required this.height,
    required this.value,
  });

  @override
  State<_AnimatedMomentumBar> createState() => _AnimatedMomentumBarState();
}

class _AnimatedMomentumBarState extends State<_AnimatedMomentumBar> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    // Add staggered delay based on x position would be ideal, but random or single fast anim works for mock
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOutBack);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final isPeak = widget.value > 0.8;
        return Container(
          width: widget.width,
          height: widget.height * _animation.value,
          decoration: BoxDecoration(
            color: isPeak 
                ? const Color(0xFFC6FF00) // Neon highlight for peaks
                : Colors.grey.shade800.withValues(alpha: 0.5 + (0.5 * widget.value)),
            borderRadius: BorderRadius.circular(widget.width / 2),
            boxShadow: isPeak
                ? [
                    BoxShadow(
                      color: const Color(0xFFC6FF00).withValues(alpha: 0.3),
                      blurRadius: 8,
                      spreadRadius: 1,
                    )
                  ]
                : null,
          ),
        );
      },
    );
  }
}
