import 'package:flutter/material.dart';
import 'package:redesign/theme/app_colors.dart';

const kGreen = AppColors.accent;

class SwipeToReply extends StatefulWidget {
  final Widget child;
  final bool isMe;
  final VoidCallback onSwiped;

  const SwipeToReply({
    super.key,
    required this.child,
    required this.isMe,
    required this.onSwiped,
  });

  @override
  State<SwipeToReply> createState() => _SwipeToReplyState();
}

class _SwipeToReplyState extends State<SwipeToReply>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  double _dragOffset = 0;

  static const _triggerThreshold = 60.0;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // WhatsApp style: always swipe right to reply
      onHorizontalDragUpdate: (details) {
        if (details.delta.dx > 0) {
          setState(() {
            _dragOffset += details.delta.dx;
            if (_dragOffset > _triggerThreshold + 20) {
              _dragOffset = _triggerThreshold + 20;
            }
          });
        } else if (_dragOffset > 0) {
          setState(() {
            _dragOffset += details.delta.dx;
            if (_dragOffset < 0) _dragOffset = 0;
          });
        }
      },
      onHorizontalDragEnd: (_) {
        if (_dragOffset >= _triggerThreshold) {
          widget.onSwiped();
        }
        setState(() => _dragOffset = 0);
      },
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          if (_dragOffset > 10)
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Opacity(
                opacity: (_dragOffset / _triggerThreshold).clamp(0.0, 1.0),
                child: Icon(
                  Icons.reply,
                  color: kGreen.withOpacity(0.8),
                  size: 24,
                ),
              ),
            ),
          Transform.translate(
            offset: Offset(_dragOffset, 0),
            child: widget.child,
          ),
        ],
      ),
    );
  }
}
