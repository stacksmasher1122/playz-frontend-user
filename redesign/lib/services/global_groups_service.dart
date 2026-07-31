import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:redesign/shared_preferences/userPreferences.dart';

class GlobalGroupsService {
  static final _firestore = FirebaseFirestore.instance;

  /// Ensures user is automatically joined to the mandatory PLAYZ-GLOBAL group
  static Future<void> ensureJoinedGlobalGroup({
    required String userDocId,
    required String userName,
    required String userPic,
  }) async {
    if (userDocId.trim().isEmpty) return;

    try {
      const groupId = 'PLAYZ-GLOBAL';
      final groupDocRef = _firestore.collection('Groups').doc(groupId);
      final groupSnap = await groupDocRef.get();

      final now = DateTime.now();
      final effectiveName = userName.trim().isNotEmpty ? userName : 'PlayZ Member';

      final userMemberEntry = {
        'name': effectiveName,
        'imageUrl': userPic,
        'joinedAt': Timestamp.fromDate(now),
        'role': 'member',
        'lastSeenAt': Timestamp.fromDate(now),
      };

      if (!groupSnap.exists) {
        await groupDocRef.set({
          'groupId': groupId,
          'name': 'PLAYZ-GLOBAL',
          'description':
              'Global community for all PlayZ athletes and fans. Slow mode & message moderation active.',
          'sport': 'Global',
          'isPublic': true,
          'maxMembers': 100000,
          'imageUrl': 'https://illustrations.popsy.co/gray/community.svg',
          'creator': 'system',
          'slowMode': true,
          'messageModeration': true,
          'createdAt': Timestamp.fromDate(now),
          'members': {
            userDocId: userMemberEntry,
          },
        });
      } else {
        await groupDocRef.set({
          'members': {
            userDocId: userMemberEntry,
          },
        }, SetOptions(merge: true));
      }

      // Add group reference into User/{docId}
      await _firestore.collection('User').doc(userDocId).set({
        'groups': {
          groupId: {
            'groupId': groupId,
            'name': 'PLAYZ-GLOBAL',
            'description':
                'Global community for all PlayZ athletes and fans. Slow mode & message moderation active.',
            'imageUrl': 'https://illustrations.popsy.co/gray/community.svg',
          },
        },
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint('🔴 [GlobalGroupsService] ensureJoinedGlobalGroup error: $e');
    }
  }

  /// Sync user membership to PLAYZ-{sport_name} groups based on favoriteSports
  static Future<void> syncUserSportGroups({
    required String userDocId,
    required String userName,
    required String userPic,
    required List<String> favoriteSports,
  }) async {
    if (userDocId.trim().isEmpty) return;

    try {
      final now = DateTime.now();
      final effectiveName = userName.trim().isNotEmpty ? userName : 'PlayZ Member';

      for (final sport in favoriteSports) {
        if (sport.trim().isEmpty) continue;
        final cleanSport = sport.trim();
        final groupId = 'PLAYZ-$cleanSport';

        final groupDocRef = _firestore.collection('Groups').doc(groupId);
        final groupSnap = await groupDocRef.get();

        final userMemberEntry = {
          'name': effectiveName,
          'imageUrl': userPic,
          'joinedAt': Timestamp.fromDate(now),
          'role': 'member',
          'lastSeenAt': Timestamp.fromDate(now),
        };

        final groupRef = {
          'groupId': groupId,
          'name': groupId,
          'description': 'Official PlayZ global community for $cleanSport players.',
          'imageUrl': 'https://illustrations.popsy.co/gray/community.svg',
        };

        if (!groupSnap.exists) {
          await groupDocRef.set({
            'groupId': groupId,
            'name': groupId,
            'description':
                'Official PlayZ global community for $cleanSport players.',
            'sport': cleanSport,
            'isPublic': true,
            'maxMembers': 100000,
            'imageUrl': 'https://illustrations.popsy.co/gray/community.svg',
            'creator': 'system',
            'createdAt': Timestamp.fromDate(now),
            'members': {
              userDocId: userMemberEntry,
            },
          });
        } else {
          await groupDocRef.set({
            'members': {
              userDocId: userMemberEntry,
            },
          }, SetOptions(merge: true));
        }

        // Add group reference into User/{docId}
        await _firestore.collection('User').doc(userDocId).set({
          'groups': {
            groupId: groupRef,
          },
        }, SetOptions(merge: true));
      }
    } catch (e) {
      debugPrint('🔴 [GlobalGroupsService] syncUserSportGroups error: $e');
    }
  }

  /// Conveniece helper to fetch user data & run both PLAY-GLOBAL & PLAYZ-{sport} checks
  static Future<void> checkAndJoinAllUserGroups({String? targetDocId}) async {
    try {
      final docId = targetDocId ?? await UserPreferences.getDocId() ?? '';
      if (docId.trim().isEmpty) return;

      final userSnap = await _firestore.collection('User').doc(docId).get();
      String userName = await UserPreferences.getUserName() ?? '';
      String userPic = await UserPreferences.getProfileImageUrl() ?? '';
      List<String> favoriteSports = ['Cricket', 'Football', 'Badminton'];

      List<String> leftGroups = [];

      if (userSnap.exists && userSnap.data() != null) {
        final data = userSnap.data()!;
        if (data['name'] != null && (data['name'] as String).isNotEmpty) {
          userName = data['name'];
        }
        if (data['profileImageUrl'] != null && (data['profileImageUrl'] as String).isNotEmpty) {
          userPic = data['profileImageUrl'];
        }
        if (data['favoriteSports'] != null) {
          favoriteSports = List<String>.from(data['favoriteSports']);
        }
        if (data['leftGroups'] != null) {
          leftGroups = List<String>.from(data['leftGroups']);
        }
      }

      // 1) Ensure PLAYZ-GLOBAL (unless explicitly left)
      if (!leftGroups.contains('PLAYZ-GLOBAL')) {
        await ensureJoinedGlobalGroup(
          userDocId: docId,
          userName: userName,
          userPic: userPic,
        );
      }

      // 2) Sync PLAYZ-{sport_name} groups (skipping any in leftGroups)
      final sportsToSync = favoriteSports
          .where((s) => !leftGroups.contains('PLAYZ-${s.trim()}'))
          .toList();
      if (sportsToSync.isNotEmpty) {
        await syncUserSportGroups(
          userDocId: docId,
          userName: userName,
          userPic: userPic,
          favoriteSports: sportsToSync,
        );
      }
    } catch (e) {
      debugPrint('🔴 [GlobalGroupsService] checkAndJoinAllUserGroups error: $e');
    }
  }
}
