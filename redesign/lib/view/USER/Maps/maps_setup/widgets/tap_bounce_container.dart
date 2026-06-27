import 'package:flutter/material.dart';

class TapBounceContainer extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;

  const TapBounceContainer({super.key, required this.child, this.onTap});

  @override
  State<TapBounceContainer> createState() => _TapBounceContainerState();
}

class _TapBounceContainerState extends State<TapBounceContainer> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _isPressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: widget.child,
      ),
    );
  }
}
