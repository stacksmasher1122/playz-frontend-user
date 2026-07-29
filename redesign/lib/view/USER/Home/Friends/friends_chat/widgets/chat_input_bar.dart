import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Friends_Controller/chat_controller.dart';
import 'package:redesign/theme/responsive_helper.dart';
import 'package:redesign/view/USER/Home/widgets/chat_emoji_sheet.dart';

class ChatInputBar extends StatefulWidget {
  final TextEditingController controller;
  final bool isTyping;
  final Function(String) onTypingChanged;
  final VoidCallback onAttachmentPressed;
  final VoidCallback onCameraPressed;
  final VoidCallback onSendPressed;

  const ChatInputBar({
    super.key,
    required this.controller,
    required this.isTyping,
    required this.onTypingChanged,
    required this.onAttachmentPressed,
    required this.onCameraPressed,
    required this.onSendPressed,
  });

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  final FocusNode _focusNode = FocusNode();
  bool _showEmojiPicker = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus && _showEmojiPicker) {
        setState(() => _showEmojiPicker = false);
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final chatCtrl = Get.find<ChatController>();
    final buttonSize = context.minDimensionPct(12).clamp(44.0, 52.0);

    return PopScope(
      canPop: !_showEmojiPicker,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (_showEmojiPicker) {
          setState(() => _showEmojiPicker = false);
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            color: AppColors.background.withValues(alpha: 0.8),
            padding: EdgeInsets.fromLTRB(
              context.widthPct(4),
              context.heightPct(1),
              context.widthPct(4),
              context.heightPct(1),
            ),
            child: SafeArea(
              top: false,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius:
                            BorderRadius.circular(context.minDimensionPct(6)),
                        border: Border.all(color: AppColors.borderDark),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              _showEmojiPicker
                                  ? Icons.keyboard
                                  : Icons.emoji_emotions_outlined,
                              color: _showEmojiPicker
                                  ? AppColors.accent
                                  : AppColors.muted,
                            ),
                            onPressed: () {
                              if (_showEmojiPicker) {
                                setState(() => _showEmojiPicker = false);
                                FocusScope.of(context).requestFocus(_focusNode);
                              } else {
                                FocusScope.of(context).unfocus();
                                setState(() => _showEmojiPicker = true);
                              }
                            },
                          ),
                          Expanded(
                            child: TextField(
                              focusNode: _focusNode,
                              controller: widget.controller,
                              style: AppTypography.bodySm.copyWith(
                                color: AppColors.textPrimary,
                                fontSize: context.responsiveFont(15),
                              ),
                              textCapitalization: TextCapitalization.sentences,
                              minLines: 1,
                              maxLines: 5,
                              onTap: () {
                                if (_showEmojiPicker) {
                                  setState(() => _showEmojiPicker = false);
                                }
                              },
                              onChanged: widget.onTypingChanged,
                              decoration: InputDecoration(
                                hintText: "Type a message...",
                                hintStyle: AppTypography.bodySm.copyWith(
                                  color: AppColors.muted,
                                  fontSize: context.responsiveFont(14),
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: context.heightPct(1.2),
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.attach_file,
                              color: AppColors.muted,
                            ),
                            onPressed: widget.onAttachmentPressed,
                          ),
                          if (!widget.isTyping)
                            IconButton(
                              icon: const Icon(
                                Icons.camera_alt_outlined,
                                color: AppColors.muted,
                              ),
                              onPressed: widget.onCameraPressed,
                            ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: context.widthPct(2)),

                  // Send/Mic Button
                  GestureDetector(
                    onTap: widget.onSendPressed,
                    onLongPressStart: (_) {
                      if (!widget.isTyping) chatCtrl.startRecording();
                    },
                    onLongPressEnd: (_) {
                      if (!widget.isTyping) chatCtrl.stopRecording();
                    },
                    child: Obx(() {
                      final isRec = chatCtrl.isRecording.value;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        height: isRec ? buttonSize + 8 : buttonSize,
                        width: isRec ? buttonSize + 8 : buttonSize,
                        decoration: BoxDecoration(
                          color: widget.isTyping
                              ? AppColors.accent
                              : (isRec ? AppColors.error : AppColors.accent),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Icon(
                            widget.isTyping
                                ? Icons.send
                                : (isRec ? Icons.stop : Icons.mic),
                            color: isRec
                                ? AppColors.textPrimary
                                : AppColors.background,
                            size: isRec ? 28 : 22,
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),

          if (_showEmojiPicker)
            ChatEmojiPickerPanel(
              controller: widget.controller,
              onChanged: () => widget.onTypingChanged(widget.controller.text),
              onClose: () => setState(() => _showEmojiPicker = false),
            ),
        ],
      ),
    );
  }
}
