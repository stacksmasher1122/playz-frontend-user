import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Friends_Controller/chat_controller.dart';

const kGreen = AppColors.accent;
const kMuted = Colors.white38;

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
    final chatCtrl = Get.find<ChatController>();

    return Container(
      color: Colors.black.withOpacity(0.6),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: SafeArea(
        top: false,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.emoji_emotions_outlined,
                        color: Colors.white60,
                      ),
                      onPressed: () {},
                    ),
                    Expanded(
                      child: TextField(
                        controller: controller,
                        style: const TextStyle(color: Colors.white),
                        textCapitalization: TextCapitalization.sentences,
                        minLines: 1,
                        maxLines: 5,
                        onChanged: onTypingChanged,
                        decoration: const InputDecoration(
                          hintText: "Type a message...",
                          hintStyle: TextStyle(color: kMuted, fontSize: 16),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.attach_file,
                        color: Colors.white60,
                      ),
                      onPressed: onAttachmentPressed,
                    ),
                    if (!isTyping)
                      IconButton(
                        icon: const Icon(
                          Icons.camera_alt_outlined,
                          color: Colors.white60,
                        ),
                        onPressed: onCameraPressed,
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),

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
                  height: isRec ? 56 : 48,
                  width: isRec ? 56 : 48,
                  decoration: BoxDecoration(
                    color: isTyping
                        ? kGreen
                        : (isRec ? Colors.redAccent : kGreen),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      isTyping ? Icons.send : (isRec ? Icons.stop : Icons.mic),
                      color: isRec ? Colors.white : Colors.black,
                      size: isRec ? 30 : 22,
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
