import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:redesign/theme/app_colors.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Groups_Controller/group_chat_controller.dart';
import 'package:redesign/controller/maps_controller.dart';
import 'package:redesign/model/maps_model.dart';
import 'package:redesign/view/USER/Home/Friends/camera/camera_screen.dart';
import 'package:redesign/view/USER/Maps/maps_picker/maps_picker_screen.dart';

// Widgets
import 'attachment_icon.dart';
import 'media_preview_screen.dart';
import 'create_poll_sheet.dart';
import 'package:redesign/theme/responsive_helper.dart';

const _kGreen = AppColors.accent;
const _kMuted = Colors.white38;

class GroupsChatInputBar extends StatefulWidget {
  final GroupChatController ctrl;
  final VoidCallback onScrollToBottom;

  GroupsChatInputBar({
    super.key,
    required this.ctrl,
    required this.onScrollToBottom,
  });

  @override
  State<GroupsChatInputBar> createState() => _GroupsChatInputBarState();
}

class _GroupsChatInputBarState extends State<GroupsChatInputBar> {
  final TextEditingController _msgController = TextEditingController();
  bool _isTyping = false;

  @override
  void dispose() {
    _msgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveHelper.init(context);
    return Container(
      color: Colors.black.withValues(alpha: 0.6),
      padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: SafeArea(
        top: false,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(ResponsiveHelper.w(24)),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.emoji_emotions_outlined,
                        color: Colors.white60,
                      ),
                      onPressed: () {},
                    ),
                    Expanded(
                      child: TextField(
                        controller: _msgController,
                        style: TextStyle(color: Colors.white),
                        textCapitalization: TextCapitalization.sentences,
                        minLines: 1,
                        maxLines: 5,
                        onChanged: (val) {
                          setState(() => _isTyping = val.trim().isNotEmpty);
                        },
                        decoration: InputDecoration(
                          hintText: "Type a message...",
                          hintStyle: TextStyle(color: _kMuted, fontSize: 16),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(12)),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.attach_file,
                        color: Colors.white60,
                      ),
                      onPressed: () => _showAttachmentSheet(context),
                    ),
                    if (!_isTyping)
                      IconButton(
                        icon: Icon(
                          Icons.camera_alt_outlined,
                          color: Colors.white60,
                        ),
                        onPressed: _openCamera,
                      ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 8),

            // Send/Mic Button
            GestureDetector(
              onTap: () {
                if (_isTyping) {
                  widget.ctrl.sendText(_msgController.text);
                  _msgController.clear();
                  setState(() => _isTyping = false);
                  widget.onScrollToBottom();
                }
              },
              onLongPressStart: (_) {
                if (!_isTyping) widget.ctrl.startRecording();
              },
              onLongPressEnd: (_) {
                if (!_isTyping) widget.ctrl.stopRecording();
              },
              child: Obx(() {
                final isRec = widget.ctrl.isRecording.value;
                return AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  height: isRec ? 56 : 48,
                  width: isRec ? 56 : 48,
                  decoration: BoxDecoration(
                    color: _isTyping
                        ? _kGreen
                        : (isRec ? Colors.redAccent : _kGreen),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      _isTyping ? Icons.send : (isRec ? Icons.stop : Icons.mic),
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

  Future<void> _openCamera() async {
    final capturedPath = await Navigator.push<String?>(
      context,
      MaterialPageRoute(builder: (_) => CameraScreen()),
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
            await widget.ctrl.sendMediaFromPath(
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

  /// Pick media → show preview → send on confirm
  Future<void> _pickAndPreviewMedia(
    ImageSource source, {
    bool isVideo = false,
  }) async {
    try {
      final path = await widget.ctrl.pickMedia(source, isVideo: isVideo);
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
          await widget.ctrl.sendMediaFromPath(
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
        margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
        decoration: BoxDecoration(
          color: Color(0xFF2B2B2B),
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
        ),
        padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(24), horizontal: ResponsiveHelper.w(24)),
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
                  color: _kGreen,
                  label: "Location",
                  onTap: () {
                    Navigator.pop(context);
                    _showLocationOptionsSheet(context);
                  },
                ),
                AttachmentIcon(
                  icon: Icons.poll,
                  color: Colors.teal,
                  label: "Poll",
                  onTap: () {
                    Navigator.pop(context);
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) => CreatePollSheet(),
                    );
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
        margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
        decoration: BoxDecoration(
          color: Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
        ),
        padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(16)),
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
            Divider(color: Colors.white10, height: 1),
            _buildLocationOptionTile(
              icon: Icons.my_location,
              title: "Send Current Location",
              subtitle: "Precise to 5 meters",
              onTap: () => _handleCurrentLocationOption(context),
            ),
            Divider(color: Colors.white10, height: 1),
            _buildLocationOptionTile(
              icon: Icons.map,
              title: "Select from Map",
              subtitle: "Pick a specific venue or spot",
              onTap: () async {
                Navigator.pop(context);
                final selectedLoc = await Navigator.push<LocationData>(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MapPickerScreen(isSelectOnly: true),
                  ),
                );

                if (selectedLoc != null && mounted) {
                  String venueName = selectedLoc.landmark.isNotEmpty
                      ? selectedLoc.landmark
                      : (selectedLoc.subLocality.isNotEmpty
                            ? selectedLoc.subLocality
                            : selectedLoc.city);
                  String addr = selectedLoc.fullAddress;

                  widget.ctrl.sendLocationMessage(
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
        padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(24), vertical: ResponsiveHelper.h(16)),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(ResponsiveHelper.w(10)),
              decoration: BoxDecoration(
                color: _kGreen.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: _kGreen, size: 24),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: ResponsiveHelper.sp(16),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(color: _kMuted, fontSize: 13),
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
      {'label': '15 minutes', 'duration': Duration(minutes: 15)},
      {'label': '30 minutes', 'duration': Duration(minutes: 30)},
      {'label': '45 minutes', 'duration': Duration(minutes: 45)},
      {'label': '1 hour', 'duration': Duration(hours: 1)},
      {'label': '2 hours', 'duration': Duration(hours: 2)},
      {'label': '4 hours', 'duration': Duration(hours: 4)},
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
        decoration: BoxDecoration(
          color: Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(ResponsiveHelper.w(16)),
        ),
        padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.h(16)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.w(24), vertical: ResponsiveHelper.h(8)),
              child: Text(
                "Select Duration",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: ResponsiveHelper.sp(18),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Divider(color: Colors.white10, height: 16),
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
                      padding: EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 14,
                      ),
                      child: Text(
                        d['label'] as String,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: ResponsiveHelper.sp(16),
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
          Center(child: CircularProgressIndicator(color: _kGreen)),
    );

    await mapsCtrl.detectCurrentLocation();

    if (context.mounted) Navigator.pop(context);

    if (mapsCtrl.currentLocation.value != null) {
      final loc = mapsCtrl.currentLocation.value!;
      String venueName = loc.landmark.isNotEmpty
          ? loc.landmark
          : (loc.subLocality.isNotEmpty ? loc.subLocality : loc.city);

      widget.ctrl.sendLiveLocationMessage(
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
          Center(child: CircularProgressIndicator(color: _kGreen)),
    );

    await mapsCtrl.detectCurrentLocation();

    if (context.mounted) {
      Navigator.pop(context);
    }

    if (mapsCtrl.currentLocation.value != null) {
      final loc = mapsCtrl.currentLocation.value!;
      String venueName = loc.landmark.isNotEmpty
          ? loc.landmark
          : (loc.subLocality.isNotEmpty ? loc.subLocality : loc.city);

      widget.ctrl.sendLocationMessage(
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
