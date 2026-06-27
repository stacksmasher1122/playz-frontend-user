import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redesign/model/User_Models/Home_Models/Friends_Model/player_info_model.dart';
import 'package:redesign/shared_preferences/userPreferences.dart';

class PlayerInfoController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final isLoading = true.obs;
  final playerInfo = Rxn<PlayerInfoModel>();

  Future<void> loadPlayerInfo({
    required String email,
    required String name,
    required String pic,
    required bool isOnline,
  }) async {
    isLoading.value = true;
    try {
      String bio = '';
      DateTime? joinedAt;
      DateTime? friendsSince;

      // 1. Fetch User Profile
      final userDoc = await _firestore.collection('User').doc(email).get();
      if (userDoc.exists) {
        final data = userDoc.data()!;
        bio = data['bio'] ?? '';
        final ca = data['createdAt'];
        if (ca is Timestamp) {
          joinedAt = ca.toDate();
        }
      }

      // 2. Fetch friends logic to check when they became friends
      final myEmail = await UserPreferences.getDocId() ?? '';
      if (myEmail.isNotEmpty) {
        final friendDoc = await _firestore
            .collection('User')
            .doc(myEmail)
            .collection('friends')
            .doc(email)
            .get();

        if (friendDoc.exists) {
          final fd = friendDoc.data()!;
          final ts = fd['timestamp'];
          if (ts is Timestamp) {
            friendsSince = ts.toDate();
          } else {
            friendsSince = DateTime.now();
          }
        }
      }

      // 3. Mock logic for Stats
      final matchesPlayed = 124;
      final winRate = 72;

      // Generate @username from email
      final username = '@${email.split('@').first.toLowerCase()}';

      // Fallback quote if bio empty
      final displayBio = bio.trim().isNotEmpty 
          ? '"$bio"' 
          : '"Loves high-intensity badminton and football matches. Available most weekends."';

      playerInfo.value = PlayerInfoModel(
        email: email,
        fullName: name,
        profileImageUrl: pic,
        isOnline: isOnline,
        bio: displayBio,
        matchesPlayed: matchesPlayed,
        winRate: winRate,
        username: username,
        joinedAt: joinedAt ?? DateTime(2024, 1, 15),
        friendsSince: friendsSince ?? DateTime(2024, 2, 20),
      );
    } catch (e) {
      debugPrint('🔴 [PlayerInfoController] Failed to load info: $e');
    } finally {
      isLoading.value = false;
    }
  }
}

