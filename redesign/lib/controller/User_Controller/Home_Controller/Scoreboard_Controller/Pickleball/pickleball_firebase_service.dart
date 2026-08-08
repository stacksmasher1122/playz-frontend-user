import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Pickleball/live_pickleball_match_model.dart';

class PickleballFirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collectionPath = 'pickleball_matches';

  Future<void> saveMatchToCloud(LivePickleballMatchModel match) async {
    try {
      await _firestore
          .collection(collectionPath)
          .doc(match.matchId)
          .set(match.toMap(), SetOptions(merge: true));
    } catch (e) {
      // ignore: avoid_print
      print("Error saving match to Firebase: $e");
      rethrow; // Rethrow to let the SyncService know it failed
    }
  }

  Future<List<LivePickleballMatchModel>> fetchRecentMatches() async {
    try {
      // Fetching all matches, could limit or order by date later
      QuerySnapshot snapshot = await _firestore.collection(collectionPath).get();
      
      return snapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        // Ensure matchId is present inside the map in case it's only the doc ID
        data['matchId'] = doc.id;
        return LivePickleballMatchModel.fromMap(data);
      }).toList();
    } catch (e) {
      // ignore: avoid_print
      print("Error fetching matches from Firebase: $e");
      return [];
    }
  }
}
