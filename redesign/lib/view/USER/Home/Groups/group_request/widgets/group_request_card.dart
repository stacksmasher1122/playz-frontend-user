import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/model/User_Models/Home_Models/Groups_Model/group_request_model.dart';
import 'package:redesign/theme/responsive_helper.dart';

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
    ResponsiveHelper.init(context);
    final req = widget.request;
    final avatarSize = context.minDimensionPct(14).clamp(44.0, 56.0);

    return Padding(
      padding: EdgeInsets.only(bottom: context.heightPct(1.5)),
      child: ScaleTransition(
        scale: _scaleAnim,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: context.widthPct(4),
            vertical: context.heightPct(1.5),
          ),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(context.minDimensionPct(4)),
            border: Border.all(color: AppColors.borderDark),
          ),
          child: Row(
            children: [
              // ── Avatar ──
              ClipOval(
                child: req.senderPic.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: req.senderPic,
                        width: avatarSize,
                        height: avatarSize,
                        fit: BoxFit.cover,
                        placeholder: (_, __) => CircleAvatar(
                          radius: avatarSize / 2,
                          backgroundColor: AppColors.surface,
                        ),
                        errorWidget: (_, __, ___) => CircleAvatar(
                          radius: avatarSize / 2,
                          backgroundColor: AppColors.surface,
                          child: const Icon(Icons.person, color: AppColors.muted),
                        ),
                      )
                    : CircleAvatar(
                        radius: avatarSize / 2,
                        backgroundColor: AppColors.surface,
                        child: const Icon(Icons.person, color: AppColors.muted),
                      ),
              ),

              SizedBox(width: context.widthPct(4)),

              // ── Name ──
              Expanded(
                child: Text(
                  req.senderName.isNotEmpty ? req.senderName : req.senderEmail,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.headlineSm.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: context.responsiveFont(16),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

              SizedBox(width: context.widthPct(2)),

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
                  padding: EdgeInsets.symmetric(
                    horizontal: context.widthPct(5),
                    vertical: context.heightPct(1.2),
                  ),
                  decoration: BoxDecoration(
                    color: _approved ? AppColors.accent.withValues(alpha: 0.15) : AppColors.accent,
                    borderRadius: BorderRadius.circular(context.minDimensionPct(5)),
                    boxShadow: _approved
                        ? []
                        : [
                            BoxShadow(
                              color: AppColors.accent.withValues(alpha: 0.35),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                  ),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: _approved
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            key: const ValueKey('approved'),
                            children: [
                              const Icon(Icons.check, color: AppColors.accent, size: 16),
                              SizedBox(width: context.widthPct(1)),
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  'Approved',
                                  style: AppTypography.bodySm.copyWith(
                                    color: AppColors.accent,
                                    fontWeight: FontWeight.w700,
                                    fontSize: context.responsiveFont(14),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : FittedBox(
                            key: const ValueKey('approve'),
                            fit: BoxFit.scaleDown,
                            child: Text(
                              'Approve',
                              style: AppTypography.bodySm.copyWith(
                                color: AppColors.background,
                                fontWeight: FontWeight.w700,
                                fontSize: context.responsiveFont(14),
                              ),
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
