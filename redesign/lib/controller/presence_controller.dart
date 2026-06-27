import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:redesign/shared_preferences/userPreferences.dart';

class PresenceController extends GetxController with WidgetsBindingObserver {
  final _firestore = FirebaseFirestore.instance;
  String _myEmail = '';

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    _initPresence();
  }

  Future<void> _initPresence() async {
    _myEmail = await UserPreferences.getDocId() ?? '';
    if (_myEmail.isNotEmpty) {
      _setOnlineStatus(true);
    }
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    _setOnlineStatus(false);
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_myEmail.isEmpty) return;

    switch (state) {
      case AppLifecycleState.resumed:
        _setOnlineStatus(true);
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
        // Delay slightly in case we're just opening a camera/picker
        // to avoid heavy work during critical transitions
        Future.delayed(const Duration(seconds: 2), () {
          if (WidgetsBinding.instance.lifecycleState != AppLifecycleState.resumed) {
            _setOnlineStatus(false);
          }
        });
        break;
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        _setOnlineStatus(false);
        break;
    }
  }

  Future<void> _setOnlineStatus(bool isOnline) async {
    if (_myEmail.isEmpty) return;
    try {
      await _firestore.collection('User').doc(_myEmail).update({
        'isOnline': isOnline,
        'lastSeen': FieldValue.serverTimestamp(),
      });
      debugPrint('🟢 [PresenceController] Online status updated: $isOnline');
    } catch (e) {
      debugPrint('🔴 [PresenceController] Failed to update online status: $e');
    }
  }
}
