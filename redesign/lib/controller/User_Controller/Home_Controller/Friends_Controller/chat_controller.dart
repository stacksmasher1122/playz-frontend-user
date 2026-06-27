import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:record/record.dart';
import 'package:uuid/uuid.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:gallery_saver_plus/gallery_saver.dart';
import 'package:geolocator/geolocator.dart';

import 'package:redesign/model/User_Models/Home_Models/Friends_Model/friends_model.dart';
import 'package:redesign/sqflite/User_SQF/Home_SQF/Friends_SQF/friendsSqflite.dart';
import 'package:redesign/shared_preferences/userPreferences.dart';

class ChatController extends GetxController {
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;
  final _uuid = const Uuid();
  final _audioRecorder = AudioRecorder();
  final _dio = Dio();
  final _picker = ImagePicker();

  // ── State ──
  final dmDocId = "".obs;
  final friendEmail = "".obs;
  String myEmail = '';

  final messages = <ChatMessageModel>[].obs;
  final isSendingText = false.obs;
  final isUploadingMedia = false.obs;
  final isRecording = false.obs;

  // ── Reply State ──
  final Rxn<ChatMessageModel> replyToMessage = Rxn<ChatMessageModel>();

  StreamSubscription? _msgSub;
  StreamSubscription<Position>? _liveLocationStream;
  String? _recordPath;
  DateTime? _recordingStartTime;

  // Init is called explicitly when ChatScreen is opened
  Future<void> initChat(String friendEmailParam) async {
    myEmail = await UserPreferences.getDocId() ?? '';
    if (myEmail.isEmpty) return;

    friendEmail.value = friendEmailParam;
    final sorted = [myEmail, friendEmail.value]..sort();
    dmDocId.value = sorted.join('_');

    // Load fast from SQFlite
    final localMsgs = await FriendsSqflite.getMessagesByDmId(dmDocId.value);
    messages.assignAll(localMsgs);

    // Listen to live stream
    _listenToMessages();

    // Recover any lost media from a crashed activity (Android)
    _checkLostData();
  }

  Future<void> _checkLostData() async {
    try {
      final LostDataResponse response = await _picker.retrieveLostData();
      if (response.isEmpty) return;

      if (response.file != null) {
        debugPrint('🟢 [Chat] Recovered lost media: ${response.file!.path}');
        // We can't automatically send it because we don't know if the user
        // was in the middle of a preview. However, we can at least log it
        // or notify the UI. For now, let's just log.
      }
    } catch (e) {
      debugPrint('🔴 [Chat] Lost data recovery error: $e');
    }
  }

  @override
  void onClose() {
    _msgSub?.cancel();
    _audioRecorder.dispose();
    super.onClose();
  }

  // ═══════════════════════════════════
  //  REPLY-TO
  // ═══════════════════════════════════

  void setReplyTo(ChatMessageModel msg) {
    replyToMessage.value = msg;
  }

  void clearReplyTo() {
    replyToMessage.value = null;
  }

  // ═══════════════════════════════════
  //  STREAM DATA
  // ═══════════════════════════════════

  void _listenToMessages() {
    if (dmDocId.isEmpty) return;
    _msgSub?.cancel();
    _msgSub = _firestore
        .collection('Direct_Message')
        .doc(dmDocId.value)
        .collection('Chats')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen((snapshot) async {
      final newMsgs = snapshot.docs.map((doc) {
        return ChatMessageModel.fromMap(doc.id, doc.data());
      }).toList();

      messages.assignAll(newMsgs);

      // Identify unread messages from the friend to mark as read
      final unreadFriendMsgs = newMsgs.where((m) =>
          m.senderEmail != myEmail && !m.isRead).toList();

      if (unreadFriendMsgs.isNotEmpty) {
        final batch = _firestore.batch();
        for (final m in unreadFriendMsgs) {
          final docRef = _firestore
              .collection('Direct_Message')
              .doc(dmDocId.value)
              .collection('Chats')
              .doc(m.id);
          batch.update(docRef, {'isRead': true});
        }
        // Fire and forget batch update
        batch.commit().catchError((e) {
          debugPrint('🔴 [ChatController] Error marking messages as read: $e');
        });
      }

      // Sync to local DB in background
      await FriendsSqflite.clearAndInsertMessages(dmDocId.value, newMsgs);
    }, onError: (e) {
      debugPrint('🔴 [ChatController] Sync error: $e');
    });
  }

  // ═══════════════════════════════════
  //  SEND MESSAGES
  // ═══════════════════════════════════

  void stopLiveLocationTracking() {
    _liveLocationStream?.cancel();
    _liveLocationStream = null;
  }

  Future<void> sendText(String content) async {
    if (content.trim().isEmpty) return;
    isSendingText.value = true;
    await _sendMessage('text', content.trim());
    isSendingText.value = false;
  }

  Future<void> sendLocationMessage({
    required double lat,
    required double lng,
    required String address,
    required String name,
    bool isLive = false,
  }) async {
    isUploadingMedia.value = true;
    try {
      final payload = jsonEncode({
        'lat': lat,
        'lng': lng,
        'address': address,
        'name': name,
        'isLive': isLive,
      });
      await _sendMessage(isLive ? 'live_location' : 'location', payload);
    } catch (e) {
      Get.snackbar('Location Error', 'Could not send location.');
    } finally {
      isUploadingMedia.value = false;
    }
  }

  Future<void> sendLiveLocationMessage({
    required double lat,
    required double lng,
    required String address,
    required String name,
    required DateTime expiresAt,
  }) async {
    isUploadingMedia.value = true;
    try {
      final payload = jsonEncode({
        'lat': lat,
        'lng': lng,
        'address': address,
        'name': name,
        'isLive': true,
        'expiresAt': expiresAt.toIso8601String(),
      });
      
      final msgId = await _sendMessage('live_location', payload);
      
      if (msgId != null) {
        startLiveLocationTracking(msgId, expiresAt);
      }
    } catch (e) {
      Get.snackbar('Location Error', 'Could not start live location.');
    } finally {
      isUploadingMedia.value = false;
    }
  }

  void startLiveLocationTracking(String messageId, DateTime expiresAt) {
    stopLiveLocationTracking(); // Stop any existing

    _liveLocationStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 15, // Update only if moved 15+ meters
      ),
    ).listen((Position position) async {
      // Check expiration
      if (DateTime.now().isAfter(expiresAt)) {
        stopLiveLocationTracking();
        return;
      }

      final dmId = dmDocId.value;
      if (dmId.isEmpty) return;

      try {
        final chatRef = _firestore
            .collection('Direct_Message')
            .doc(dmId)
            .collection('Chats')
            .doc(messageId);

        final snap = await chatRef.get();
        if (!snap.exists) {
          stopLiveLocationTracking(); // Message was deleted
          return;
        }

        final data = snap.data()!;
        final contentStr = data['content'] as String;

        // Parse existing content
        final payload = jsonDecode(contentStr);
        
        // Update lat/lng
        payload['lat'] = position.latitude;
        payload['lng'] = position.longitude;

        // Save back
        await chatRef.update({
          'content': jsonEncode(payload),
        });
      } catch (e) {
        debugPrint('🔴 [Chat] Failed to stream live location: $e');
      }
    });
  }

  /// Pick media from gallery or camera.
  /// Returns the local file path if picked, or null.
  Future<String?> pickMedia(ImageSource source, {bool isVideo = false}) async {
    try {
      // Allow window manager to settle before launching intent
      await Future.delayed(const Duration(milliseconds: 400));

      XFile? file;

      if (isVideo) {
        file = await _picker.pickVideo(source: source);
      } else {
        file = await _picker.pickImage(
          source: source,
          imageQuality: 85,
          preferredCameraDevice: CameraDevice.rear,
        );
      }

      // ── Camera crash recovery ──
      if (file == null && source == ImageSource.camera) {
        final LostDataResponse response = await _picker.retrieveLostData();
        if (!response.isEmpty) {
          file = response.file;
        }
      }

      if (file == null) {
        debugPrint('🟡 [Chat] No file selected.');
        return null;
      }

      final localFile = File(file.path);
      if (!await localFile.exists()) {
        debugPrint('🔴 [Chat] Selected file does not exist: ${file.path}');
        return null;
      }

      return file.path;
    } catch (e, stack) {
      debugPrint('🔴 [Chat] pickMedia exception: $e');
      debugPrint(stack.toString());
      return null;
    }
  }

  /// Upload a local file and send as a message.
  /// Called after user confirms in the media preview screen.
  Future<void> sendMediaFromPath(String path, {bool isVideo = false, String caption = ''}) async {
    isUploadingMedia.value = true;
    try {
      final localFile = File(path);
      if (!await localFile.exists()) {
        debugPrint('🔴 [Chat] File does not exist: $path');
        return;
      }

      final downloadUrl =
          await _uploadToStorage(localFile, isVideo ? 'videos' : 'images');

      if (downloadUrl.isNotEmpty) {
        String content = downloadUrl;
        if (caption.trim().isNotEmpty) {
          content = jsonEncode({'url': downloadUrl, 'caption': caption.trim()});
        }
        await _sendMessage(isVideo ? 'video' : 'image', content);
      }
    } catch (e, stack) {
      debugPrint('🔴 [Chat] Media upload exception: $e');
      debugPrint(stack.toString());
      Get.snackbar('Error', 'Failed to send media: $e');
    } finally {
      isUploadingMedia.value = false;
    }
  }

  /// Legacy method — kept for backward compat but now the view
  /// should use pickMedia + preview + sendMediaFromPath instead.
  Future<void> sendMedia(ImageSource source, {bool isVideo = false}) async {
    isUploadingMedia.value = true;
    try {
      final path = await pickMedia(source, isVideo: isVideo);
      if (path == null) return;
      await sendMediaFromPath(path, isVideo: isVideo);
    } finally {
      isUploadingMedia.value = false;
    }
  }

  Future<void> sendAudioFile() async {
    Get.snackbar('Coming Soon', 'Audio file picker requires file_picker dependency');
  }

  // ═══════════════════════════════════
  //  EDIT & DELETE MESSAGES
  // ═══════════════════════════════════

  /// Edit text message content (only works for type == 'text')
  Future<void> editMessage(String messageId, String newContent) async {
    if (newContent.trim().isEmpty || dmDocId.isEmpty) return;
    try {
      final chatRef = _firestore
          .collection('Direct_Message')
          .doc(dmDocId.value)
          .collection('Chats')
          .doc(messageId);

      await chatRef.update({
        'content': newContent.trim(),
        'isEdited': true,
      });
    } catch (e) {
      debugPrint('🔴 [Chat] Edit message error: $e');
      Get.snackbar('Error', 'Failed to edit message');
    }
  }

  /// Delete message for everyone (removes from Firestore)
  Future<void> deleteMessage(String messageId) async {
    if (dmDocId.isEmpty) return;
    try {
      final chatRef = _firestore
          .collection('Direct_Message')
          .doc(dmDocId.value)
          .collection('Chats')
          .doc(messageId);

      await chatRef.delete();

      // Also remove from local SQFLite
      final db = await FriendsSqflite.database;
      await db.delete('chat_messages', where: 'id = ?', whereArgs: [messageId]);
    } catch (e) {
      debugPrint('🔴 [Chat] Delete message error: $e');
      Get.snackbar('Error', 'Failed to delete message');
    }
  }

  // ═══════════════════════════════════
  //  VIDEO DOWNLOAD
  // ═══════════════════════════════════

  Future<void> downloadVideo(String url) async {
    try {
      final dir = await getTemporaryDirectory();
      final path =
          "${dir.path}/video_${DateTime.now().millisecondsSinceEpoch}.mp4";

      await _dio.download(url, path);
      await GallerySaver.saveVideo(path);

      Get.snackbar(
        "Saved",
        "Video saved to gallery",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      debugPrint('🔴 [Chat] Video download error: $e');
      Get.snackbar('Error', 'Failed to download video');
    }
  }

  // ═══════════════════════════════════
  //  AUDIO RECORDING (MIC)
  // ═══════════════════════════════════

  Future<void> startRecording() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        final tempDir = await getTemporaryDirectory();
        _recordPath = '${tempDir.path}/audio_${_uuid.v4()}.m4a';
        await _audioRecorder.start(
          const RecordConfig(
            encoder: AudioEncoder.aacLc,
            bitRate: 128000,
            sampleRate: 44100,
          ),
          path: _recordPath!,
        );
        _recordingStartTime = DateTime.now();
        isRecording.value = true;
      }
    } catch (e) {
      debugPrint('🔴 [Chat] Audio record start error: $e');
    }
  }

  Future<void> stopRecording() async {
    try {
      final path = await _audioRecorder.stop();
      isRecording.value = false;

      // Check for zero-second or accidental taps
      if (_recordingStartTime != null) {
        final duration = DateTime.now().difference(_recordingStartTime!);
        if (duration.inMilliseconds < 1000) {
          debugPrint('🟡 [Chat] Recording too short, discarding');
          if (path != null && File(path).existsSync()) {
            File(path).deleteSync();
          }
          return;
        }
      }

      if (path != null && File(path).existsSync()) {
        isUploadingMedia.value = true;
        final downloadUrl = await _uploadToStorage(File(path), 'audio');
        await _sendMessage('audio', downloadUrl);
        isUploadingMedia.value = false;
      }
    } catch (e) {
      debugPrint('🔴 [Chat] Audio record stop error: $e');
      isRecording.value = false;
      isUploadingMedia.value = false;
    }
  }

  Future<void> cancelRecording() async {
    await _audioRecorder.stop();
    isRecording.value = false;
    if (_recordPath != null && File(_recordPath!).existsSync()) {
      File(_recordPath!).deleteSync();
    }
  }

  // ═══════════════════════════════════
  //  CORE HELPERS
  // ═══════════════════════════════════

  Future<String?> _sendMessage(String type, String content) async {
    if (myEmail.isEmpty) return null;

    // Capture reply data before clearing
    final reply = replyToMessage.value;
    clearReplyTo();

    final id = _uuid.v4();
    final msg = ChatMessageModel(
      id: id,
      senderEmail: myEmail,
      type: type,
      content: content,
      replyToId: reply?.id,
      replyToContent: reply != null
          ? (reply.type == 'text'
              ? reply.content
              : 'Sent a ${reply.type}')
          : null,
      replyToSender: reply?.senderEmail,
    );

    // Save to Firestore subcollection
    final chatRef = _firestore
        .collection('Direct_Message')
        .doc(dmDocId.value)
        .collection('Chats')
        .doc(id);

    await chatRef.set(msg.toMap());

    // Update parent DM doc with last message
    await _firestore.collection('Direct_Message').doc(dmDocId.value).update({
      'lastMessage': type == 'text' ? content : 'Sent a $type',
      'lastMessageAt': FieldValue.serverTimestamp(),
    });

    // Optimistically insert locally so UI bounces fast
    await FriendsSqflite.insertMessage(msg, dmDocId.value);
    
    return id;
  }

  Future<String> _uploadToStorage(File file, String folder) async {
    final fileName = '${DateTime.now().millisecondsSinceEpoch}_${_uuid.v4()}';
    // Path matches standard format: Direct_Message/alice_bob/images/123_xyz.png
    final refPath = 'Direct_Message/${dmDocId.value}/$folder/$fileName';
    final storageRef = _storage.ref().child(refPath);

    final uploadTask = storageRef.putFile(file);
    final snapshot = await uploadTask.whenComplete(() {});
    return await snapshot.ref.getDownloadURL();
  }
}
