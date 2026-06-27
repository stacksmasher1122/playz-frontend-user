import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Groups_Controller/group_chat_controller.dart';
import 'package:redesign/model/User_Models/Home_Models/Groups_Model/group_chat_model.dart';

// Modular Widgets
import 'widgets/groups_chat_app_bar.dart';
import 'widgets/groups_chat_input_bar.dart';
import 'widgets/groups_swipe_to_reply.dart';
import 'widgets/bubbles/message_bubble.dart';

const _kGreen = AppColors.accent;
const _kBg = AppColors.surface;
const _kMuted = Colors.white38;

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
      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0.0,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBg,
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
                      return const Center(
                        child: Text(
                          "Start the group conversation! 🏆",
                          style: TextStyle(color: _kMuted, fontSize: 15),
                        ),
                      );
                    }

                    return ListView.builder(
                      key: const PageStorageKey("group_chat_list"),
                      controller: _scrollController,
                      physics: const BouncingScrollPhysics(),
                      reverse: true,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      itemCount:
                          _ctrl.pendingMessages.length + _ctrl.messages.length,
                      itemBuilder: (context, i) {
                        final isPending = i < _ctrl.pendingMessages.length;
                        final msg = isPending
                            ? _ctrl.pendingMessages[i]
                            : _ctrl.messages[i - _ctrl.pendingMessages.length];
                        final isMe = msg.senderEmail == _ctrl.myEmail;
                        final timeStr = DateFormat(
                          'HH:mm',
                        ).format(msg.timestamp);

                        return GroupsSwipeToReply(
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
                            ),
                          ),
                        );
                      },
                    );
                  }),
                ),

                /// 🔥 RECORDING INDICATOR
                Obx(() {
                  if (!_ctrl.isRecording.value) return const SizedBox.shrink();
                  return Container(
                    padding: const EdgeInsets.all(10),
                    color: Colors.red.withOpacity(0.8),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.mic, color: Colors.white),
                        SizedBox(width: 10),
                        Text(
                          "Recording...",
                          style: TextStyle(color: Colors.white),
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
                    color: const Color(0xFF1A1A1A),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 4,
                          height: 40,
                          decoration: BoxDecoration(
                            color: _kGreen,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 10),
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
                                style: const TextStyle(
                                  color: _kGreen,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                reply.type == 'text'
                                    ? reply.content
                                    : '📎 ${reply.type}',
                                style: const TextStyle(
                                  color: Colors.white60,
                                  fontSize: 13,
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
                            color: Colors.white60,
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
                  color: Colors.black54,
                  child: const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(color: _kGreen),
                        SizedBox(height: 16),
                        Text(
                          "Sending media...",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
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
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        decoration: BoxDecoration(
          color: const Color(0xFF2B2B2B),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Reply
            ListTile(
              leading: const Icon(Icons.reply, color: Colors.white),
              title: const Text("Reply", style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                _ctrl.setReplyTo(msg);
              },
            ),
            // Edit (only for own text messages that are not flagged)
            if (isMe && msg.type == 'text' && msg.status != 'flagged')
              ListTile(
                leading: const Icon(Icons.edit, color: Colors.white),
                title: const Text(
                  "Edit",
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _showEditDialog(context, msg);
                },
              ),
            // Delete (only for own messages)
            if (isMe)
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.redAccent),
                title: const Text(
                  "Delete",
                  style: TextStyle(color: Colors.redAccent),
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
        backgroundColor: const Color(0xFF2B2B2B),
        title: const Text(
          "Edit Message",
          style: TextStyle(color: Colors.white),
        ),
        content: TextField(
          controller: editController,
          style: const TextStyle(color: Colors.white),
          autofocus: true,
          maxLines: 5,
          minLines: 1,
          decoration: InputDecoration(
            hintText: "Edit your message...",
            hintStyle: const TextStyle(color: _kMuted),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: _kGreen.withOpacity(0.5)),
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: _kGreen),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Cancel",
              style: TextStyle(color: Colors.white60),
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
            child: const Text("Save", style: TextStyle(color: _kGreen)),
          ),
        ],
      ),
    );
  }
}
