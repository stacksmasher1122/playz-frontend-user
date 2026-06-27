import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/model/User_Models/Home_Models/Groups_Model/group_request_model.dart';

const _kCardBg = Color(0xFF1A1A1A);
const _kGreen = AppColors.accent;
const _kMuted = Colors.white70;

class GroupRequestCard extends StatefulWidget {
  final GroupRequestModel request;
  final VoidCallback onApprove;
  final VoidCallback onDecline;

  const GroupRequestCard({
    super.key,
    required this.request,
    required this.onApprove,
    required this.onDecline,
  });

  @override
  State<GroupRequestCard> createState() => _GroupRequestCardState();
}

class _GroupRequestCardState extends State<GroupRequestCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnim;
  bool _approved = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onApprove() {
    setState(() => _approved = true);
    widget.onApprove();
  }

  @override
  Widget build(BuildContext context) {
    final req = widget.request;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ScaleTransition(
        scale: _scaleAnim,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: _kCardBg,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withAlpha(10)),
          ),
          child: Row(
            children: [
              // ── Avatar ──
              CircleAvatar(
                radius: 30,
                backgroundImage: req.senderPic.isNotEmpty
                    ? CachedNetworkImageProvider(req.senderPic) as ImageProvider
                    : null,
                backgroundColor: const Color(0xFF0E0E0E),
                child: req.senderPic.isEmpty
                    ? const Icon(Icons.person, color: _kMuted)
                    : null,
              ),

              const SizedBox(width: 16),

              // ── Name ──
              Expanded(
                child: Text(
                  req.senderName.isNotEmpty ? req.senderName : req.senderEmail,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

              // ── Approve Button ──
              GestureDetector(
                onTapDown: (_) => _controller.forward(),
                onTapUp: (_) {
                  _controller.reverse();
                  if (!_approved) _onApprove();
                },
                onTapCancel: () => _controller.reverse(),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 22,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: _approved ? _kGreen.withAlpha(38) : _kGreen,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: _approved
                        ? []
                        : [
                            BoxShadow(
                              color: _kGreen.withAlpha(89),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                  ),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: _approved
                        ? const Row(
                            mainAxisSize: MainAxisSize.min,
                            key: ValueKey('approved'),
                            children: [
                              Icon(Icons.check, color: _kGreen, size: 16),
                              SizedBox(width: 4),
                              Text(
                                'Approved',
                                style: TextStyle(
                                  color: _kGreen,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          )
                        : const Text(
                            'Approve',
                            key: ValueKey('approve'),
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
