import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Groups_Controller/group_chat_controller.dart';
import 'package:redesign/model/User_Models/Home_Models/Groups_Model/group_chat_model.dart';

// Modular Widgets
import 'widgets/groups_chat_app_bar.dart';
import 'widgets/groups_chat_input_bar.dart';
import 'widgets/groups_swipe_to_reply.dart';
import 'widgets/bubbles/message_bubble.dart';
import 'package:redesign/theme/responsive_helper.dart';

class GroupChatScreen extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String groupPic;
  final int memberCount;

  const GroupChatScreen({
    super.key,
    required this.groupId,
    required this.groupName,
    required this.groupPic,
    required this.memberCount,
  });

  @override
  State<GroupChatScreen> createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  final ScrollController _scrollController = ScrollController();
  late final GroupChatController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = Get.find<GroupChatController>();
    _ctrl.initGroupChat(widget.groupId);

    ever(_ctrl.messages, (_) {
      _handleMessageListChange();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _handleMessageListChange() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      // In reverse ListView, 0.0 is the bottom (latest messages)
      final isNearBottom = _scrollController.offset <= 150;
      if (isNearBottom) {
        _scrollController.animateTo(
          0.0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0.0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            // 🔥 BACKGROUND DOODLE
            Positioned.fill(
              child: Opacity(
                opacity: 0.15,
                child: CachedNetworkImage(
                  imageUrl:
                      "https://camo.githubusercontent.com/c42c83df2fd1e442ef1e0ed69cc20d21f65308fc2f0dca2a8035360738d49c8c/68747470733a2f2f7765622e77686174736170702e636f6d2f696d672f62672d636861742d74696c652d6461726b5f61346265353132653731393562366237333364393131306234303866303735642e706e67",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Column(
              children: [
                /// 🔥 APP BAR
                GroupsChatAppBar(
                  groupId: widget.groupId,
                  name: widget.groupName,
                  pic: widget.groupPic,
                  memberCount: widget.memberCount,
                ),

                /// 🔥 CHAT LIST
                Expanded(
                  child: Obx(() {
                    if (_ctrl.messages.isEmpty &&
                        _ctrl.pendingMessages.isEmpty) {
                      return Center(
                        child: Text(
                          "Start the group conversation! 🏆",
                          style: AppTypography.bodySm.copyWith(
                            color: AppColors.muted,
                            fontSize: context.responsiveFont(15),
                          ),
                        ),
                      );
                    }

                    final pendingCount = _ctrl.pendingMessages.length;

                    // 1. Build chronological list of all messages (0 = oldest, N-1 = newest)
                    final List<GroupChatMessageModel> chronologicalList = [
                      ..._ctrl.pendingMessages,
                      ..._ctrl.messages,
                    ];
                    chronologicalList.sort((a, b) => a.timestamp.compareTo(b.timestamp));

                    // 2. Pre-calculate WhatsApp grouping rules and date tags for every message
                    final Map<String, bool> headerMap = {};
                    final Map<String, bool> consecutiveNextMap = {};
                    final Map<String, String?> dateTagMap = {};

                    for (int k = 0; k < chronologicalList.length; k++) {
                      final current = chronologicalList[k];

                      bool showHeader = true;
                      bool consecutiveNext = false;
                      String? dateTag;

                      if (k == 0) {
                        showHeader = true;
                        dateTag = _formatDateTag(current.timestamp);
                      } else {
                        final prev = chronologicalList[k - 1];
                        final dayChanged = _isDifferentDay(current.timestamp, prev.timestamp);

                        if (dayChanged) {
                          showHeader = true;
                          dateTag = _formatDateTag(current.timestamp);
                        } else if (prev.senderEmail == current.senderEmail) {
                          final timeGap = current.timestamp.difference(prev.timestamp).abs();
                          if (timeGap.inMinutes < 5) {
                            showHeader = false;
                          }
                        }
                      }

                      if (k + 1 < chronologicalList.length) {
                        final next = chronologicalList[k + 1];
                        if (next.senderEmail == current.senderEmail) {
                          final dayChangedWithNext = _isDifferentDay(next.timestamp, current.timestamp);
                          if (!dayChangedWithNext) {
                            final timeGap = next.timestamp.difference(current.timestamp).abs();
                            if (timeGap.inMinutes < 5) {
                              consecutiveNext = true;
                            }
                          }
                        }
                      }

                      headerMap[current.id] = showHeader;
                      consecutiveNextMap[current.id] = consecutiveNext;
                      dateTagMap[current.id] = dateTag;
                    }

                    return ListView.builder(
                      key: const PageStorageKey("group_chat_list"),
                      controller: _scrollController,
                      physics: const BouncingScrollPhysics(),
                      reverse: true,
                      padding: EdgeInsets.symmetric(
                        horizontal: context.widthPct(3),
                        vertical: context.heightPct(1),
                      ),
                      itemCount: pendingCount + _ctrl.messages.length,
                      findChildIndexCallback: (Key key) {
                        if (key is ValueKey<String>) {
                          final String id = key.value;
                          final pIndex =
                              _ctrl.pendingMessages.indexWhere((m) => m.id == id);
                          if (pIndex != -1) return pIndex;

                          final mIndex =
                              _ctrl.messages.indexWhere((m) => m.id == id);
                          if (mIndex != -1) return pendingCount + mIndex;
                        }
                        return null;
                      },
                      itemBuilder: (context, i) {
                        final isPending = i < pendingCount;
                        final msg = isPending
                            ? _ctrl.pendingMessages[i]
                            : _ctrl.messages[i - pendingCount];
                        final isMe = msg.senderEmail == _ctrl.myEmail;
                        final timeStr = DateFormat(
                          'HH:mm',
                        ).format(msg.timestamp);

                        final showSenderHeader = headerMap[msg.id] ?? true;
                        final isConsecutiveWithNext = consecutiveNextMap[msg.id] ?? false;
                        final dateTag = dateTagMap[msg.id];

                        final bubbleWidget = GroupsSwipeToReply(
                          key: ValueKey(msg.id),
                          isMe: isMe,
                          onSwiped: () => _ctrl.setReplyTo(msg),
                          child: GestureDetector(
                            onLongPress: () =>
                                _showMessageOptions(context, msg, isMe),
                            child: GroupMessageBubble(
                              key: ValueKey(msg.id),
                              msg: msg,
                              isMe: isMe,
                              timeStr: timeStr,
                              ctrl: _ctrl,
                              showSenderHeader: showSenderHeader,
                              isConsecutive: isConsecutiveWithNext,
                            ),
                          ),
                        );

                        if (dateTag != null) {
                          return Column(
                            key: ValueKey("date_wrapper_${msg.id}"),
                            children: [
                              _buildDateTagWidget(context, dateTag),
                              bubbleWidget,
                            ],
                          );
                        }

                        return bubbleWidget;
                      },
                    );
                  }),
                ),

                /// 🔥 RECORDING INDICATOR
                Obx(() {
                  if (!_ctrl.isRecording.value) return const SizedBox.shrink();
                  return Container(
                    padding: EdgeInsets.all(context.widthPct(2.5)),
                    color: AppColors.error.withValues(alpha: 0.8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.mic, color: AppColors.textPrimary),
                        SizedBox(width: context.widthPct(2.5)),
                        Text(
                          "Recording...",
                          style: AppTypography.bodySm.copyWith(
                            color: AppColors.textPrimary,
                            fontSize: context.responsiveFont(14),
                          ),
                        ),
                      ],
                    ),
                  );
                }),

                /// 🔥 REPLY PREVIEW BAR
                Obx(() {
                  final reply = _ctrl.replyToMessage.value;
                  if (reply == null) return const SizedBox.shrink();
                  return Container(
                    color: AppColors.card,
                    padding: EdgeInsets.symmetric(
                      horizontal: context.widthPct(4),
                      vertical: context.heightPct(1),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: context.widthPct(1),
                          height: context.heightPct(5),
                          decoration: BoxDecoration(
                            color: AppColors.accent,
                            borderRadius: BorderRadius.circular(context.minDimensionPct(0.5)),
                          ),
                        ),
                        SizedBox(width: context.widthPct(2.5)),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                reply.senderEmail == _ctrl.myEmail
                                    ? "You"
                                    : (reply.senderName.isNotEmpty
                                          ? reply.senderName
                                          : reply.senderEmail),
                                style: AppTypography.headlineSm.copyWith(
                                  color: AppColors.accent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: context.responsiveFont(12),
                                ),
                              ),
                              SizedBox(height: context.heightPct(0.3)),
                              Text(
                                reply.type == 'text'
                                    ? reply.content
                                    : '📎 ${reply.type}',
                                style: AppTypography.bodySm.copyWith(
                                  color: AppColors.textSecondary,
                                  fontSize: context.responsiveFont(13),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.close,
                            color: AppColors.muted,
                            size: 18,
                          ),
                          onPressed: _ctrl.clearReplyTo,
                        ),
                      ],
                    ),
                  );
                }),

                /// 🔥 INPUT BAR
                GroupsChatInputBar(
                  ctrl: _ctrl,
                  onScrollToBottom: _scrollToBottom,
                ),
              ],
            ),

            // 🔥 UPLOAD OVERLAY
            Obx(() {
              if (!_ctrl.isUploadingMedia.value) {
                return const SizedBox.shrink();
              }
              return Positioned.fill(
                child: Container(
                  color: AppColors.background.withValues(alpha: 0.7),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircularProgressIndicator(color: AppColors.accent),
                        SizedBox(height: context.heightPct(2)),
                        Text(
                          "Sending media...",
                          style: AppTypography.headlineSm.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: context.responsiveFont(15),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  // ── Long-press message options ──
  void _showMessageOptions(
    BuildContext context,
    GroupChatMessageModel msg,
    bool isMe,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        margin: EdgeInsets.fromLTRB(
          context.widthPct(4),
          0,
          context.widthPct(4),
          context.heightPct(2),
        ),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(context.minDimensionPct(4)),
          border: Border.all(color: AppColors.borderDark),
        ),
        padding: EdgeInsets.symmetric(
          vertical: context.heightPct(2),
          horizontal: context.widthPct(2),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Reply
            ListTile(
              leading: const Icon(Icons.reply, color: AppColors.textPrimary),
              title: Text(
                "Reply",
                style: AppTypography.bodySm.copyWith(
                  color: AppColors.textPrimary,
                  fontSize: context.responsiveFont(14),
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                _ctrl.setReplyTo(msg);
              },
            ),
            // Edit (only for own text messages that are not flagged)
            if (isMe && msg.type == 'text' && msg.status != 'flagged')
              ListTile(
                leading: const Icon(Icons.edit, color: AppColors.textPrimary),
                title: Text(
                  "Edit",
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: context.responsiveFont(14),
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _showEditDialog(context, msg);
                },
              ),
            // Delete (only for own messages)
            if (isMe)
              ListTile(
                leading: const Icon(Icons.delete, color: AppColors.error),
                title: Text(
                  "Delete",
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.error,
                    fontSize: context.responsiveFont(14),
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _ctrl.deleteMessage(msg.id);
                },
              ),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context, GroupChatMessageModel msg) {
    final editController = TextEditingController(text: msg.content);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(
          "Edit Message",
          style: AppTypography.headlineSm.copyWith(
            color: AppColors.textPrimary,
            fontSize: context.responsiveFont(16),
          ),
        ),
        content: TextField(
          controller: editController,
          style: AppTypography.bodySm.copyWith(
            color: AppColors.textPrimary,
            fontSize: context.responsiveFont(14),
          ),
          autofocus: true,
          maxLines: 5,
          minLines: 1,
          decoration: InputDecoration(
            hintText: "Edit your message...",
            hintStyle: AppTypography.bodySm.copyWith(
              color: AppColors.muted,
              fontSize: context.responsiveFont(14),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.accent.withValues(alpha: 0.5)),
              borderRadius: BorderRadius.circular(context.minDimensionPct(3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: AppColors.accent),
              borderRadius: BorderRadius.circular(context.minDimensionPct(3)),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Cancel",
              style: AppTypography.bodySm.copyWith(
                color: AppColors.muted,
                fontSize: context.responsiveFont(14),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              final newText = editController.text.trim();
              if (newText.isNotEmpty && newText != msg.content) {
                _ctrl.editMessage(msg.id, newText);
              }
              Navigator.pop(context);
            },
            child: Text(
              "Save",
              style: AppTypography.bodySm.copyWith(
                color: AppColors.accent,
                fontWeight: FontWeight.bold,
                fontSize: context.responsiveFont(14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Date Tag Helpers ──

  bool _isDifferentDay(DateTime date1, DateTime date2) {
    return date1.year != date2.year ||
        date1.month != date2.month ||
        date1.day != date2.day;
  }

  String _formatDateTag(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final msgDate = DateTime(date.year, date.month, date.day);

    final dateStr = DateFormat('d MMMM yyyy').format(date);

    if (msgDate == today) {
      return 'Today, $dateStr';
    } else if (msgDate == yesterday) {
      return 'Yesterday, $dateStr';
    } else {
      final dayName = DateFormat('EEEE').format(date);
      return '$dayName, $dateStr';
    }
  }

  Widget _buildDateTagWidget(BuildContext context, String label) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: context.heightPct(1.5)),
        padding: EdgeInsets.symmetric(
          horizontal: context.widthPct(4),
          vertical: context.heightPct(0.6),
        ),
        decoration: BoxDecoration(
          color: AppColors.card.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(context.minDimensionPct(4)),
          border: Border.all(color: AppColors.borderDark.withValues(alpha: 0.8)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          label,
          style: AppTypography.bodySm.copyWith(
            color: AppColors.textSecondary,
            fontSize: context.responsiveFont(12),
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
          ),
        ),
      ),
    );
  }
}
