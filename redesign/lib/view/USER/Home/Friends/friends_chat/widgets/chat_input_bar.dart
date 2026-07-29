import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/theme/app_typography.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Friends_Controller/chat_controller.dart';
import 'package:redesign/theme/responsive_helper.dart';

class ChatInputBar extends StatelessWidget {
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
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    final chatCtrl = Get.find<ChatController>();
    final buttonSize = context.minDimensionPct(12).clamp(44.0, 52.0);

    return Container(
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
                  borderRadius: BorderRadius.circular(context.minDimensionPct(6)),
                  border: Border.all(color: AppColors.borderDark),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.emoji_emotions_outlined,
                        color: AppColors.muted,
                      ),
                      onPressed: () {},
                    ),
                    Expanded(
                      child: TextField(
                        controller: controller,
                        style: AppTypography.bodySm.copyWith(
                          color: AppColors.textPrimary,
                          fontSize: context.responsiveFont(15),
                        ),
                        textCapitalization: TextCapitalization.sentences,
                        minLines: 1,
                        maxLines: 5,
                        onChanged: onTypingChanged,
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
                      onPressed: onAttachmentPressed,
                    ),
                    if (!isTyping)
                      IconButton(
                        icon: const Icon(
                          Icons.camera_alt_outlined,
                          color: AppColors.muted,
                        ),
                        onPressed: onCameraPressed,
                      ),
                  ],
                ),
              ),
            ),
            SizedBox(width: context.widthPct(2)),

            // Send/Mic Button
            GestureDetector(
              onTap: onSendPressed,
              onLongPressStart: (_) {
                if (!isTyping) chatCtrl.startRecording();
              },
              onLongPressEnd: (_) {
                if (!isTyping) chatCtrl.stopRecording();
              },
              child: Obx(() {
                final isRec = chatCtrl.isRecording.value;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: isRec ? buttonSize + 8 : buttonSize,
                  width: isRec ? buttonSize + 8 : buttonSize,
                  decoration: BoxDecoration(
                    color: isTyping
                        ? AppColors.accent
                        : (isRec ? AppColors.error : AppColors.accent),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      isTyping ? Icons.send : (isRec ? Icons.stop : Icons.mic),
                      color: isRec ? AppColors.textPrimary : AppColors.background,
                      size: isRec ? 28 : 22,
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
