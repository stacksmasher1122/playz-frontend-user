import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/model/User_Models/Home_Models/Groups_Model/group_chat_model.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Groups_Controller/group_chat_controller.dart';

// Type-specific bubbles
import 'dynamic_image_bubble.dart';
import 'video_bubble.dart';
import 'audio_bubble.dart';
import 'location_bubble.dart';
import 'poll_bubble.dart';
import 'package:redesign/theme/responsive_helper.dart';

const _kGreen = AppColors.accent;
const _kMuted = Colors.white38;
const _kSurface = Color(0xFF222222);

class GroupMessageBubble extends StatelessWidget {
  final GroupChatMessageModel msg;
  final bool isMe;
  final String timeStr;
  final GroupChatController ctrl;

  GroupMessageBubble({
    super.key,
    required this.msg,
    required this.isMe,
    required this.timeStr,
    required this.ctrl,
  });

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Column(
          crossAxisAlignment: isMe
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            // ── Sender name (only for other people's messages) ──
            if (!isMe)
              Padding(
                padding: EdgeInsets.only(left: ResponsiveHelper.w(4), bottom: 2),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (msg.senderPic.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.only(right: 6),
                        child: CircleAvatar(
                          radius: 10,
                          backgroundColor: _kSurface,
                          backgroundImage: CachedNetworkImageProvider(
                            msg.senderPic,
                          ),
                        ),
                      ),
                    Text(
                      msg.senderName.isNotEmpty
                          ? msg.senderName
                          : msg.senderEmail,
                      style: TextStyle(
                        color: _kGreen.withValues(alpha: 0.9),
                        fontWeight: FontWeight.w600,
                        fontSize: ResponsiveHelper.sp(12),
                      ),
                    ),
                  ],
                ),
              ),

            // ── Reply quote ──
            if (msg.replyToId != null && msg.replyToContent != null)
              Container(
                margin: EdgeInsets.only(bottom: 4),
                padding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isMe
                      ? _kGreen.withValues(alpha: 0.15)
                      : _kSurface.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(ResponsiveHelper.w(12)),
                  border: Border(left: BorderSide(color: _kGreen, width: 3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      msg.replyToSender ?? "",
                      style: TextStyle(
                        color: _kGreen,
                        fontWeight: FontWeight.bold,
                        fontSize: ResponsiveHelper.sp(11),
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      msg.replyToContent!,
                      style: TextStyle(
                        color: Colors.white60,
                        fontSize: ResponsiveHelper.sp(12),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

            // ── Main content ──
            _buildContent(context),
            SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  timeStr,
                  style: TextStyle(color: _kMuted, fontSize: 11),
                ),
                if (msg.isEdited && msg.status != 'flagged') ...[
                  SizedBox(width: 4),
                  Text(
                    "edited",
                    style: TextStyle(
                      color: Colors.white38,
                      fontSize: ResponsiveHelper.sp(10),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
                if (msg.status == 'pending') ...[
                  SizedBox(width: 4),
                  Icon(Icons.access_time, size: 10, color: _kMuted),
                ],
                if (msg.status == 'flagged') ...[
                  SizedBox(width: 4),
                  Icon(Icons.warning, size: 10, color: Colors.redAccent),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    switch (msg.type) {
      case 'text':
        final isFlagged = msg.status == 'flagged';
        return Container(
          padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(16), vertical: ResponsiveHelper.h(12)),
          decoration: BoxDecoration(
            color: isFlagged
                ? Colors.redAccent.withValues(alpha: 0.2)
                : (isMe ? _kGreen : _kSurface),
            borderRadius: BorderRadius.circular(ResponsiveHelper.w(20)).copyWith(
              bottomRight: isMe
                  ? Radius.circular(ResponsiveHelper.w(4))
                  : Radius.circular(ResponsiveHelper.w(20)),
              bottomLeft: !isMe
                  ? Radius.circular(ResponsiveHelper.w(4))
                  : Radius.circular(ResponsiveHelper.w(20)),
            ),
          ),
          child: Text(
            msg.content,
            style: TextStyle(
              color: isFlagged
                  ? Colors.redAccent
                  : (isMe ? Colors.black : Colors.white),
              fontSize: ResponsiveHelper.sp(16),
              fontWeight: isMe && !isFlagged
                  ? FontWeight.w500
                  : FontWeight.w400,
              fontStyle: isFlagged ? FontStyle.italic : FontStyle.normal,
            ),
          ),
        );
      case 'image':
        String url = msg.content;
        String caption = '';
        if (msg.content.startsWith('{')) {
          try {
            final data = jsonDecode(msg.content);
            url = data['url'] ?? '';
            caption = data['caption'] ?? '';
          } catch (_) {}
        }

        final imageWidget = DynamicImageBubble(
          imageUrl: url,
          maxWidth: MediaQuery.of(context).size.width * 0.7,
          maxHeight: 300,
        );

        if (caption.isEmpty) return imageWidget;

        return Container(
          padding: EdgeInsets.all(ResponsiveHelper.w(4)),
          decoration: BoxDecoration(
            color: isMe ? _kGreen : _kSurface,
            borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)).copyWith(
              bottomRight: isMe
                  ? Radius.circular(ResponsiveHelper.w(4))
                  : Radius.circular(ResponsiveHelper.w(16)),
              bottomLeft: !isMe
                  ? Radius.circular(ResponsiveHelper.w(4))
                  : Radius.circular(ResponsiveHelper.w(16)),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              imageWidget,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(8), vertical: ResponsiveHelper.h(6)),
                child: Text(
                  caption,
                  style: TextStyle(
                    color: isMe ? Colors.black : Colors.white,
                    fontSize: ResponsiveHelper.sp(16),
                  ),
                ),
              ),
            ],
          ),
        );
      case 'audio':
        return AudioBubble(url: msg.content, isMe: isMe);
      case 'video':
        String url = msg.content;
        String caption = '';
        if (msg.content.startsWith('{')) {
          try {
            final data = jsonDecode(msg.content);
            url = data['url'] ?? '';
            caption = data['caption'] ?? '';
          } catch (_) {}
        }

        final videoWidget = VideoBubble(url: url, ctrl: ctrl);

        if (caption.isEmpty) return videoWidget;

        return Container(
          padding: EdgeInsets.all(ResponsiveHelper.w(4)),
          decoration: BoxDecoration(
            color: isMe ? _kGreen : _kSurface,
            borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)).copyWith(
              bottomRight: isMe
                  ? Radius.circular(ResponsiveHelper.w(4))
                  : Radius.circular(ResponsiveHelper.w(16)),
              bottomLeft: !isMe
                  ? Radius.circular(ResponsiveHelper.w(4))
                  : Radius.circular(ResponsiveHelper.w(16)),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              videoWidget,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(8), vertical: ResponsiveHelper.h(6)),
                child: Text(
                  caption,
                  style: TextStyle(
                    color: isMe ? Colors.black : Colors.white,
                    fontSize: ResponsiveHelper.sp(16),
                  ),
                ),
              ),
            ],
          ),
        );
      case 'location':
      case 'live_location':
        return LocationBubble(
          content: msg.content,
          isMe: isMe,
          isLive: msg.type == 'live_location',
        );
      case 'poll':
        return PollBubble(msg: msg);
      default:
        return Container();
    }
  }
}
