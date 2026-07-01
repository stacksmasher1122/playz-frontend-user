import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:redesign/theme/app_colors.dart';

import 'package:redesign/controller/User_Controller/Home_Controller/Friends_Controller/chat_controller.dart';
import 'package:redesign/model/User_Models/Home_Models/Friends_Model/friends_model.dart';
import 'package:redesign/view/USER/Home/Friends/camera/camera_screen.dart';
import 'package:redesign/controller/maps_controller.dart';
import 'package:redesign/model/maps_model.dart';
import 'package:redesign/view/USER/Maps/maps_picker/maps_picker_screen.dart';

// Internal Widgets
import 'widgets/chat_app_bar.dart';
import 'widgets/chat_input_bar.dart';
import 'widgets/message_bubble.dart';
import 'widgets/swipe_to_reply.dart';
import 'widgets/attachment_icon.dart';
import 'widgets/media_preview_screen.dart';

const kGreen = AppColors.accent;
const kBg = AppColors.surface;
const kMuted = Colors.white38;

class ChatScreen extends StatefulWidget {
  final String friendEmail;
  final String friendName;
  final String friendPic;
  final bool isOnline;

  const ChatScreen({
    super.key,
    required this.friendEmail,
    required this.friendName,
    required this.friendPic,
    required this.isOnline,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _msgController = TextEditingController();
  late final ChatController _ctrl;
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _ctrl = Get.find<ChatController>();
    _ctrl.initChat(widget.friendEmail);

    ever(_ctrl.messages, (_) {
      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _msgController.dispose();
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
      backgroundColor: kBg,
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
                ChatAppBar(
                  email: widget.friendEmail,
                  name: widget.friendName.isNotEmpty
                      ? widget.friendName
                      : widget.friendEmail,
                  pic: widget.friendPic,
                  isOnline: widget.isOnline,
                ),

                /// 🔥 CHAT LIST
                Expanded(
                  child: Obx(() {
                    if (_ctrl.messages.isEmpty) {
                      return const Center(
                        child: Text(
                          "Say hi to start the conversation! 👋",
                          style: TextStyle(color: kMuted, fontSize: 15),
                        ),
                      );
                    }

                    return ListView.builder(
                      key: const PageStorageKey("chat_list"),
                      controller: _scrollController,
                      physics: const BouncingScrollPhysics(),
                      reverse: true,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      itemCount: _ctrl.messages.length,
                      itemBuilder: (context, i) {
                        final msg = _ctrl.messages[i];
                        final isMe = msg.senderEmail == _ctrl.myEmail;
                        final timeStr = DateFormat(
                          'HH:mm',
                        ).format(msg.timestamp);

                        return SwipeToReply(
                          isMe: isMe,
                          onSwiped: () => _ctrl.setReplyTo(msg),
                          child: GestureDetector(
                            onLongPress: () =>
                                _showMessageOptions(context, msg, isMe),
                            child: MessageBubble(
                              key: ValueKey(msg.id),
                              msg: msg,
                              isMe: isMe,
                              timeStr: timeStr,
                              ctrl: _ctrl,
                              friendName: widget.friendName,
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
                    color: Colors.red.withValues(alpha: 0.8),
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
                            color: kGreen,
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
                                    : (widget.friendName.isNotEmpty
                                          ? widget.friendName
                                          : reply.senderEmail),
                                style: const TextStyle(
                                  color: kGreen,
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
                ChatInputBar(
                  controller: _msgController,
                  isTyping: _isTyping,
                  onTypingChanged: (val) {
                    setState(() => _isTyping = val.trim().isNotEmpty);
                  },
                  onAttachmentPressed: () => _showAttachmentSheet(context),
                  onCameraPressed: _openCamera,
                  onSendPressed: () {
                    if (_isTyping) {
                      _ctrl.sendText(_msgController.text);
                      _msgController.clear();
                      setState(() => _isTyping = false);
                      _scrollToBottom();
                    }
                  },
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
                        CircularProgressIndicator(color: kGreen),
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

  void _showMessageOptions(
    BuildContext context,
    ChatMessageModel msg,
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
            ListTile(
              leading: const Icon(Icons.reply, color: Colors.white),
              title: const Text("Reply", style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                _ctrl.setReplyTo(msg);
              },
            ),
            if (isMe && msg.type == 'text')
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

  void _showEditDialog(BuildContext context, ChatMessageModel msg) {
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
            hintStyle: const TextStyle(color: kMuted),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: kGreen.withValues(alpha: 0.5)),
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: kGreen),
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
            child: const Text("Save", style: TextStyle(color: kGreen)),
          ),
        ],
      ),
    );
  }

  Future<void> _openCamera() async {
    final capturedPath = await Navigator.push<String?>(
      context,
      MaterialPageRoute(builder: (_) => const CameraScreen()),
    );

    if (capturedPath != null && mounted) {
      final confirmed = await Navigator.push<dynamic>(
        context,
        MaterialPageRoute(
          builder: (_) =>
              MediaPreviewScreen(filePath: capturedPath, isVideo: false),
        ),
      );

      if (confirmed != null && confirmed != false && mounted) {
        String caption = confirmed is String ? confirmed : '';
        final localFile = File(capturedPath);
        if (await localFile.exists()) {
          try {
            await _ctrl.sendMediaFromPath(
              capturedPath,
              isVideo: false,
              caption: caption,
            );
          } catch (e) {
            debugPrint("Camera send error: $e");
          }
        } else {
          Get.snackbar("Error", "Captured file missing.");
        }
      }
    }
  }

  Future<void> _pickAndPreviewMedia(
    ImageSource source, {
    bool isVideo = false,
  }) async {
    try {
      final path = await _ctrl.pickMedia(source, isVideo: isVideo);
      if (path == null) return;
      if (!mounted) return;

      final confirmed = await Navigator.push<dynamic>(
        context,
        MaterialPageRoute(
          builder: (_) => MediaPreviewScreen(filePath: path, isVideo: isVideo),
        ),
      );

      if (confirmed != null && confirmed != false) {
        String caption = confirmed is String ? confirmed : '';
        final localFile = File(path);
        if (!await localFile.exists()) {
          debugPrint("Media File does not exist at return point: $path");
          if (mounted) {
            Get.snackbar("Error", "Media file is missing or invalid.");
          }
          return;
        }

        try {
          await _ctrl.sendMediaFromPath(
            path,
            isVideo: isVideo,
            caption: caption,
          );
        } catch (e) {
          debugPrint("Media send error: $e");
        }
      }
    } catch (e) {
      debugPrint("Camera capture error: $e");
    }
  }

  void _showAttachmentSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        decoration: BoxDecoration(
          color: const Color(0xFF2B2B2B),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                AttachmentIcon(
                  icon: Icons.image,
                  color: Colors.purpleAccent,
                  label: "Gallery",
                  onTap: () {
                    Navigator.pop(context);
                    _pickAndPreviewMedia(ImageSource.gallery);
                  },
                ),
                AttachmentIcon(
                  icon: Icons.videocam,
                  color: Colors.pinkAccent,
                  label: "Video",
                  onTap: () {
                    Navigator.pop(context);
                    _pickAndPreviewMedia(ImageSource.gallery, isVideo: true);
                  },
                ),
                AttachmentIcon(
                  icon: Icons.location_on,
                  color: kGreen,
                  label: "Location",
                  onTap: () {
                    Navigator.pop(context);
                    _showLocationOptionsSheet(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showLocationOptionsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildLocationOptionTile(
              icon: Icons.share_location,
              title: "Share Live Location",
              subtitle: "Real-time tracking up to 4 hours",
              onTap: () {
                Navigator.pop(context);
                _showLiveLocationDurationSheet(context);
              },
            ),
            const Divider(color: Colors.white10, height: 1),
            _buildLocationOptionTile(
              icon: Icons.my_location,
              title: "Send Current Location",
              subtitle: "Precise to 5 meters",
              onTap: () => _handleCurrentLocationOption(context),
            ),
            const Divider(color: Colors.white10, height: 1),
            _buildLocationOptionTile(
              icon: Icons.map,
              title: "Select from Map",
              subtitle: "Pick a specific venue or spot",
              onTap: () async {
                Navigator.pop(context);
                final selectedLoc = await Navigator.push<LocationData>(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const MapPickerScreen(isSelectOnly: true),
                  ),
                );

                if (selectedLoc != null && mounted) {
                  String venueName = selectedLoc.landmark.isNotEmpty
                      ? selectedLoc.landmark
                      : (selectedLoc.subLocality.isNotEmpty
                            ? selectedLoc.subLocality
                            : selectedLoc.city);
                  String addr = selectedLoc.fullAddress;

                  _ctrl.sendLocationMessage(
                    lat: selectedLoc.lat,
                    lng: selectedLoc.lng,
                    name: venueName.isEmpty ? 'Location Pin' : venueName,
                    address: addr,
                    isLive: false,
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationOptionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: kGreen.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: kGreen, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(color: kMuted, fontSize: 13),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLiveLocationDurationSheet(BuildContext context) {
    final durations = [
      {'label': '15 minutes', 'duration': const Duration(minutes: 15)},
      {'label': '30 minutes', 'duration': const Duration(minutes: 30)},
      {'label': '45 minutes', 'duration': const Duration(minutes: 45)},
      {'label': '1 hour', 'duration': const Duration(hours: 1)},
      {'label': '2 hours', 'duration': const Duration(hours: 2)},
      {'label': '4 hours', 'duration': const Duration(hours: 4)},
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Text(
                "Select Duration",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Divider(color: Colors.white10, height: 16),
            ...durations
                .map(
                  (d) => InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      _handleLiveLocationStart(
                        context,
                        d['duration'] as Duration,
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 14,
                      ),
                      child: Text(
                        d['label'] as String,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                )
                ,
          ],
        ),
      ),
    );
  }

  Future<void> _handleLiveLocationStart(
    BuildContext context,
    Duration duration,
  ) async {
    final mapsCtrl = Get.find<MapsController>();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) =>
          const Center(child: CircularProgressIndicator(color: kGreen)),
    );

    await mapsCtrl.detectCurrentLocation();

    if (context.mounted) Navigator.pop(context); // close loading dialog

    if (mapsCtrl.currentLocation.value != null) {
      final loc = mapsCtrl.currentLocation.value!;
      String venueName = loc.landmark.isNotEmpty
          ? loc.landmark
          : (loc.subLocality.isNotEmpty ? loc.subLocality : loc.city);

      _ctrl.sendLiveLocationMessage(
        lat: loc.lat,
        lng: loc.lng,
        name: venueName.isEmpty ? 'Location Pin' : venueName,
        address: loc.fullAddress,
        expiresAt: DateTime.now().add(duration),
      );
    } else {
      Get.snackbar('Location Error', 'Could not detect your current location.');
    }
  }

  Future<void> _handleCurrentLocationOption(BuildContext context) async {
    Navigator.pop(context);
    final mapsCtrl = Get.find<MapsController>();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) =>
          const Center(child: CircularProgressIndicator(color: kGreen)),
    );

    await mapsCtrl.detectCurrentLocation();

    if (context.mounted) {
      Navigator.pop(context); // close loading dialog
    }

    if (mapsCtrl.currentLocation.value != null) {
      final loc = mapsCtrl.currentLocation.value!;
      String venueName = loc.landmark.isNotEmpty
          ? loc.landmark
          : (loc.subLocality.isNotEmpty ? loc.subLocality : loc.city);

      _ctrl.sendLocationMessage(
        lat: loc.lat,
        lng: loc.lng,
        name: venueName.isEmpty ? 'Location Pin' : venueName,
        address: loc.fullAddress,
        isLive: false,
      );
    } else {
      Get.snackbar('Location Error', 'Could not detect your current location.');
    }
  }
}
