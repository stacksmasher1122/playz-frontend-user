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
import 'package:geolocator/geolocator.dart';
import 'package:dio/dio.dart';
import 'package:gallery_saver_plus/gallery_saver.dart';

import 'package:redesign/model/User_Models/Home_Models/Groups_Model/group_chat_model.dart';
import 'package:redesign/sqflite/User_SQF/Home_SQF/Groups_SQF/groupsSqflite.dart';
import 'package:redesign/sqflite/User_SQF/Home_SQF/Groups_SQF/moderationSqflite.dart';
import 'package:redesign/shared_preferences/userPreferences.dart';
import 'package:redesign/controller/User_Controller/Home_Controller/Groups_Controller/moderation_service.dart';

class GroupChatController extends GetxController {
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;
  final _uuid = const Uuid();
  final _audioRecorder = AudioRecorder();
  final _dio = Dio();
  final _picker = ImagePicker();

  // ── State ──
  final currentGroupId = ''.obs;
  String myEmail = '';
  String myName = '';
  String myPic = '';

  final messages = <GroupChatMessageModel>[].obs;
  final pendingMessages = <GroupChatMessageModel>[].obs;
  final isSendingText = false.obs;
  final isUploadingMedia = false.obs;
  final isRecording = false.obs;

  // ── Moderation State ──
  final _moderateMembers = false.obs;
  final _moderateAdmins = false.obs;
  String _myRole = 'member';

  // ── Reply State ──
  final Rxn<GroupChatMessageModel> replyToMessage =
      Rxn<GroupChatMessageModel>();

  StreamSubscription? _msgSub;
  StreamSubscription? _groupSub;
  StreamSubscription<Position>? _liveLocationStream;
  String? _recordPath;
  DateTime? _recordingStartTime;

  /// Called explicitly when GroupChatScreen is opened
  Future<void> initGroupChat(String groupId) async {
    myEmail = await UserPreferences.getDocId() ?? '';
    myName = await UserPreferences.getUserName() ?? '';
    myPic = await UserPreferences.getProfileImageUrl() ?? '';
    if (myEmail.isEmpty) return;

    currentGroupId.value = groupId;

    // Load fast from SQFlite
    final localMsgs = await GroupsSqflite.getGroupMessages(groupId);
    messages.assignAll(localMsgs);

    // Listen to live stream
    _listenToMessages();
    _listenToGroupDoc();

    // Update lastSeenAt for scalable unread message tracking
    _updateLastSeenAt();

    // Recover any lost media from a crashed activity (Android)
    _checkLostData();
  }

  void _updateLastSeenAt() {
    if (currentGroupId.value.isEmpty || myEmail.isEmpty) return;
    _firestore.collection('Groups').doc(currentGroupId.value).update({
      FieldPath(['members', myEmail, 'lastSeenAt']): FieldValue.serverTimestamp(),
    }).catchError((e) {
      debugPrint('🔴 [GroupChatController] Error updating lastSeenAt: $e');
    });
  }

  Future<void> _checkLostData() async {
    try {
      final LostDataResponse response = await _picker.retrieveLostData();
      if (response.isEmpty) return;

      if (response.file != null) {
        debugPrint(
            '🟢 [GroupChat] Recovered lost media: ${response.file!.path}');
      }
    } catch (e) {
      debugPrint('🔴 [GroupChat] Lost data recovery error: $e');
    }
  }

  @override
  void onClose() {
    _updateLastSeenAt();
    _msgSub?.cancel();
    _groupSub?.cancel();
    stopLiveLocationTracking();
    _audioRecorder.dispose();
    super.onClose();
  }

  void stopLiveLocationTracking() {
    _liveLocationStream?.cancel();
    _liveLocationStream = null;
  }

  // ═══════════════════════════════════
  //  REPLY-TO
  // ═══════════════════════════════════

  void setReplyTo(GroupChatMessageModel msg) {
    replyToMessage.value = msg;
  }

  void clearReplyTo() {
    replyToMessage.value = null;
  }

  // ═══════════════════════════════════
  //  STREAM DATA
  // ═══════════════════════════════════

  void _listenToMessages() {
    if (currentGroupId.value.isEmpty) return;
    _msgSub?.cancel();
    _msgSub = _firestore
        .collection('Groups')
        .doc(currentGroupId.value)
        .collection('chats')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen((snapshot) async {
      final newMsgs = snapshot.docs
          .where((doc) => doc.data()['type'] != 'system') // skip _init doc
          .map((doc) {
        return GroupChatMessageModel.fromMap(
          doc.id,
          currentGroupId.value,
          doc.data(),
        );
      }).toList();

      messages.assignAll(newMsgs);

      // Sync to local DB in background
      await GroupsSqflite.clearAndInsertGroupMessages(
          currentGroupId.value, newMsgs);
    }, onError: (e) {
      debugPrint('🔴 [GroupChatController] Sync error: $e');
    });
  }

  // ═══════════════════════════════════
  //  GROUP DOC STREAM (MODERATION)
  // ═══════════════════════════════════

  void _listenToGroupDoc() {
    if (currentGroupId.value.isEmpty) return;
    _groupSub?.cancel();
    _groupSub = _firestore
        .collection('Groups')
        .doc(currentGroupId.value)
        .snapshots()
        .listen((doc) {
      if (!doc.exists) return;
      final data = doc.data()!;
      _moderateMembers.value = data['profanityModerationMembers'] ?? false;
      _moderateAdmins.value = data['profanityModerationAdmins'] ?? false;

      // Determine current user's role from the members map
      final members = data['members'] as Map<String, dynamic>? ?? {};
      if (members.containsKey(myEmail)) {
        _myRole = members[myEmail]['role'] ?? 'member';
      }
    }, onError: (e) {
      debugPrint('🔴 [GroupChatController] Group doc stream error: $e');
    });
  }

  /// Whether the current user's messages should be moderated.
  bool _shouldModerate() {
    if (!_moderateMembers.value) return false; // moderation is OFF entirely
    if (_myRole == 'admin') return _moderateAdmins.value;
    return true; // member and moderation is ON for members
  }

  // ═══════════════════════════════════
  //  SEND MESSAGES
  // ═══════════════════════════════════

  Future<void> sendText(String content) async {
    if (content.trim().isEmpty) return;
    isSendingText.value = true;

    if (_shouldModerate()) {
      await _sendTextWithModeration(content.trim());
    } else {
      await _sendMessage('text', content.trim());
    }

    isSendingText.value = false;
  }

  /// Moderated text flow:
  /// 1. Show pending in UI
  /// 2. Enqueue in SQFlite
  /// 3. Call Groq
  /// 4. SAFE → send to Firestore | UNSAFE → send policy warning
  /// 5. Remove from pending
  Future<void> _sendTextWithModeration(String content) async {
    final pendingId = _uuid.v4();

    // Capture reply data before clearing
    final reply = replyToMessage.value;
    clearReplyTo();

    // Create a pending message for the UI
    final pendingMsg = GroupChatMessageModel(
      id: pendingId,
      groupId: currentGroupId.value,
      senderEmail: myEmail,
      senderName: myName,
      senderPic: myPic,
      type: 'text',
      content: content,
      status: 'pending',
      replyToId: reply?.id,
      replyToContent: reply != null
          ? (reply.type == 'text' ? reply.content : 'Sent a ${reply.type}')
          : null,
      replyToSender: reply?.senderName.isNotEmpty == true
          ? reply!.senderName
          : reply?.senderEmail,
    );

    // Show in UI immediately
    pendingMessages.insert(0, pendingMsg);

    // Enqueue in SQFlite for crash recovery
    await ModerationSqflite.enqueue(
      id: pendingId,
      groupId: currentGroupId.value,
      senderEmail: myEmail,
      senderName: myName,
      senderPic: myPic,
      content: content,
      replyToId: reply?.id,
      replyToContent: pendingMsg.replyToContent,
      replyToSender: pendingMsg.replyToSender,
    );

    // Call Groq moderation
    final result = await ModerationService.checkContent(content);

    // Determine what to send
    String finalContent;
    String finalStatus;
    if (result.isSafe) {
      finalContent = content;
      finalStatus = 'sent';
    } else {
      finalContent =
          '⚠️ This message was removed for violating community guidelines.';
      finalStatus = 'flagged';
    }

    // Build the actual message and write to Firestore
    final msg = GroupChatMessageModel(
      id: pendingId,
      groupId: currentGroupId.value,
      senderEmail: myEmail,
      senderName: myName,
      senderPic: myPic,
      type: 'text',
      content: finalContent,
      status: finalStatus,
      replyToId: pendingMsg.replyToId,
      replyToContent: pendingMsg.replyToContent,
      replyToSender: pendingMsg.replyToSender,
    );

    // ── Seamless UI Transition ──
    // Remove from pending and optimistically insert into main list to prevent flicker/duplicates
    pendingMessages.removeWhere((m) => m.id == pendingId);
    messages.insert(0, msg);
    await GroupsSqflite.insertGroupMessage(msg);
    await ModerationSqflite.dequeue(pendingId);

    final chatRef = _firestore
        .collection('Groups')
        .doc(currentGroupId.value)
        .collection('chats')
        .doc(pendingId);

    await chatRef.set(msg.toMap());

    // Update parent Group doc with last message info
    await _firestore
        .collection('Groups')
        .doc(currentGroupId.value)
        .update({
      'lastMessage': finalStatus == 'flagged'
          ? '⚠️ Message removed'
          : finalContent,
      'lastMessageAt': FieldValue.serverTimestamp(),
      'lastMessageBy': myName.isNotEmpty ? myName : myEmail,
    });
  }

  Future<void> sendPollMessage(String question, List<String> options, bool allowMultiple) async {
    isSendingText.value = true;
    try {
      final List<Map<String, String>> mappedOptions = [];
      for (int i = 0; i < options.length; i++) {
        mappedOptions.add({
          'id': i.toString(),
          'text': options[i].trim(),
        });
      }

      final payload = jsonEncode({
        'question': question.trim(),
        'options': mappedOptions,
        'allowMultiple': allowMultiple,
        'votes': <String, dynamic>{}, // map of userEmail -> list of option ids
      });

      await _sendMessage('poll', payload);
    } catch (e) {
      Get.snackbar('Poll Error', 'Could not create poll.');
    } finally {
      isSendingText.value = false;
    }
  }

  Future<void> togglePollVote(String messageId, String optionId) async {
    if (myEmail.isEmpty || currentGroupId.value.isEmpty) return;

    try {
      final chatRef = _firestore
          .collection('Groups')
          .doc(currentGroupId.value)
          .collection('chats')
          .doc(messageId);

      await _firestore.runTransaction((transaction) async {
        final snap = await transaction.get(chatRef);
        if (!snap.exists) return;

        final data = snap.data()!;
        if (data['type'] != 'poll') return;

        final rawPayload = jsonDecode(data['content'] as String);
        final bool allowMultiple = rawPayload['allowMultiple'] ?? false;
        final votes = Map<String, dynamic>.from(rawPayload['votes'] ?? {});

        List<String> userVotes = [];
        if (votes.containsKey(myEmail)) {
          userVotes = List<String>.from(votes[myEmail]);
        }

        if (userVotes.contains(optionId)) {
          userVotes.remove(optionId);
        } else {
          if (!allowMultiple) {
            userVotes.clear();
          }
          userVotes.add(optionId);
        }

        if (userVotes.isEmpty) {
           votes.remove(myEmail);
        } else {
           votes[myEmail] = userVotes;
        }

        rawPayload['votes'] = votes;

        transaction.update(chatRef, {
          'content': jsonEncode(rawPayload),
        });
      });
    } catch (e) {
      debugPrint('🔴 [GroupChat] toggle poll vote error: $e');
    }
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
        distanceFilter: 15,
      ),
    ).listen((Position position) async {
      // Check expiration
      if (DateTime.now().isAfter(expiresAt)) {
        stopLiveLocationTracking();
        return;
      }

      final groupId = currentGroupId.value;
      if (groupId.isEmpty) return;

      try {
        final chatRef = _firestore
            .collection('Groups')
            .doc(groupId)
            .collection('chats')
            .doc(messageId);

        final snap = await chatRef.get();
        if (!snap.exists) {
          stopLiveLocationTracking();
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
        debugPrint('🔴 [GroupChat] Failed to stream live location: $e');
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
        debugPrint('🟡 [GroupChat] No file selected.');
        return null;
      }

      final localFile = File(file.path);
      if (!await localFile.exists()) {
        debugPrint(
            '🔴 [GroupChat] Selected file does not exist: ${file.path}');
        return null;
      }

      return file.path;
    } catch (e, stack) {
      debugPrint('🔴 [GroupChat] pickMedia exception: $e');
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
        debugPrint('🔴 [GroupChat] File does not exist: $path');
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
      debugPrint('🔴 [GroupChat] Media upload exception: $e');
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
    Get.snackbar(
        'Coming Soon', 'Audio file picker requires file_picker dependency');
  }

  // ═══════════════════════════════════
  //  EDIT & DELETE MESSAGES
  // ═══════════════════════════════════

  /// Edit text message content (only works for type == 'text')
  Future<void> editMessage(String messageId, String newContent) async {
    final cleanContent = newContent.trim();
    if (cleanContent.isEmpty || currentGroupId.value.isEmpty) return;

    String finalContent = cleanContent;
    String finalStatus = 'sent';

    if (_shouldModerate()) {
      final result = await ModerationService.checkContent(cleanContent);
      if (!result.isSafe) {
        finalContent = '⚠️ This message was removed for violating community guidelines.';
        finalStatus = 'flagged';
      }
    }

    try {
      final chatRef = _firestore
          .collection('Groups')
          .doc(currentGroupId.value)
          .collection('chats')
          .doc(messageId);

      final updates = <String, dynamic>{
        'content': finalContent,
        'isEdited': true,
      };

      if (finalStatus == 'flagged') {
        updates['status'] = 'flagged';
      }

      await chatRef.update(updates);
    } catch (e) {
      debugPrint('🔴 [GroupChat] Edit message error: $e');
      Get.snackbar('Error', 'Failed to edit message');
    }
  }

  /// Delete message for everyone (removes from Firestore)
  Future<void> deleteMessage(String messageId) async {
    if (currentGroupId.value.isEmpty) return;
    try {
      final chatRef = _firestore
          .collection('Groups')
          .doc(currentGroupId.value)
          .collection('chats')
          .doc(messageId);

      await chatRef.delete();

      // Also remove from local SQFLite
      await GroupsSqflite.deleteGroupMessage(messageId);
    } catch (e) {
      debugPrint('🔴 [GroupChat] Delete message error: $e');
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
      debugPrint('🔴 [GroupChat] Video download error: $e');
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
      debugPrint('🔴 [GroupChat] Audio record start error: $e');
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
          debugPrint('🟡 [GroupChat] Recording too short, discarding');
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
      debugPrint('🔴 [GroupChat] Audio record stop error: $e');
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
    if (myEmail.isEmpty || currentGroupId.value.isEmpty) return null;

    // Capture reply data before clearing
    final reply = replyToMessage.value;
    clearReplyTo();

    final id = _uuid.v4();
    final msg = GroupChatMessageModel(
      id: id,
      groupId: currentGroupId.value,
      senderEmail: myEmail,
      senderName: myName,
      senderPic: myPic,
      type: type,
      content: content,
      replyToId: reply?.id,
      replyToContent: reply != null
          ? (reply.type == 'text' ? reply.content : 'Sent a ${reply.type}')
          : null,
      replyToSender: reply?.senderName.isNotEmpty == true
          ? reply!.senderName
          : reply?.senderEmail,
    );

    // Save to Firestore subcollection: Groups/{groupId}/chats/{id}
    final chatRef = _firestore
        .collection('Groups')
        .doc(currentGroupId.value)
        .collection('chats')
        .doc(id);

    await chatRef.set(msg.toMap());

    // Update parent Group doc with last message info
    await _firestore
        .collection('Groups')
        .doc(currentGroupId.value)
        .update({
      'lastMessage': type == 'text' ? content : 'Sent a $type',
      'lastMessageAt': FieldValue.serverTimestamp(),
      'lastMessageBy': myName.isNotEmpty ? myName : myEmail,
    });

    // Optimistically insert locally
    await GroupsSqflite.insertGroupMessage(msg);
    
    return id;
  }

  Future<String> _uploadToStorage(File file, String folder) async {
    final fileName =
        '${DateTime.now().millisecondsSinceEpoch}_${_uuid.v4()}';
    // Path: Groups/{groupId}/media/{folder}/{filename}
    final refPath =
        'Groups/${currentGroupId.value}/media/$folder/$fileName';
    final storageRef = _storage.ref().child(refPath);

    final uploadTask = storageRef.putFile(file);
    final snapshot = await uploadTask.whenComplete(() {});
    return await snapshot.ref.getDownloadURL();
  }
}
