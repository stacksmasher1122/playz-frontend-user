import 'package:cloud_firestore/cloud_firestore.dart';

class UserSearchService {
  /// Searches the 'User' collection case-insensitively across fullName, primaryEmail, and docId.
  /// Results are capped at [limit] docs and sorted with the current user first, then alphabetically.
  static Future<List<Map<String, dynamic>>> searchUsers(
    String query, {
    required String currentUserId,
    int limit = 50,
  }) async {
    final queryTrimmed = query.trim();
    if (queryTrimmed.isEmpty) return [];

    final queryLower = queryTrimmed.toLowerCase();
    final snapshot = await FirebaseFirestore.instance
        .collection('User')
        .limit(limit)
        .get();

    List<Map<String, dynamic>> results = [];

    for (var doc in snapshot.docs) {
      final data = doc.data();
      final id = doc.id;

      final fullName = (data['fullName'] ?? '').toString().toLowerCase();
      final primaryEmail = (data['primaryEmail'] ?? '').toString().toLowerCase();
      final docId = id.toLowerCase();

      if (fullName.contains(queryLower) ||
          primaryEmail.contains(queryLower) ||
          docId.contains(queryLower)) {
        final isCurrentUser = id == currentUserId || primaryEmail == currentUserId.toLowerCase();
        final rawName = data['fullName'] ?? data['primaryEmail'] ?? 'User';
        final displayName = isCurrentUser ? '$rawName (you)' : rawName;

        bool isFriend = false;
        if (data['friends'] != null && data['friends'] is List) {
          isFriend = (data['friends'] as List).contains(currentUserId);
        }

        results.add({
          'userId': id,
          'id': id,
          'name': displayName,
          'rawName': rawName,
          'fullName': data['fullName'] ?? '',
          'primaryEmail': data['primaryEmail'] ?? '',
          'profileImageUrl': data['profileImageUrl'] ?? '',
          'isCurrentUser': isCurrentUser,
          'isFriend': isFriend,
          'favoriteSports': data['favoriteSports'] ?? [],
        });
      }
    }

    // Sort: current user first, then friends, then alphabetically
    results.sort((a, b) {
      if (a['isCurrentUser'] == true) return -1;
      if (b['isCurrentUser'] == true) return 1;
      if (a['isFriend'] != b['isFriend']) {
        return a['isFriend'] == true ? -1 : 1;
      }
      return (a['name'] as String).compareTo(b['name'] as String);
    });

    return results;
  }
}
