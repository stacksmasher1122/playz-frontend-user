import 'package:get/get.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Pickleball/live_pickleball_match_model.dart';
import 'pickleball_local_db_service.dart';
import 'pickleball_firebase_service.dart';
import 'dart:async';

class PickleballSyncService extends GetxService {
  final PickleballDatabaseHelper _localDb = PickleballDatabaseHelper.instance;
  final PickleballFirebaseService _firebaseDb = PickleballFirebaseService();
  
  RxBool isSyncing = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Fetch from Firebase and load to Sqflite when service starts
    _initialSync();
  }

  Future<void> _initialSync() async {
    isSyncing.value = true;
    try {
      // 1. Fetch from Firebase
      List<LivePickleballMatchModel> cloudMatches = await _firebaseDb.fetchRecentMatches();
      
      // 2. Save to Sqflite
      if (cloudMatches.isNotEmpty) {
        await _localDb.saveMatchesFromCloud(cloudMatches);
        // ignore: avoid_print
        print("Synced ${cloudMatches.length} matches from Firebase to Sqflite.");
      }
      
      // 3. Push any unsynced local data to Firebase
      await _pushPendingSyncs();
      
    } catch (e) {
      // ignore: avoid_print
      print("Initial sync failed: $e");
    } finally {
      isSyncing.value = false;
    }
  }

  Future<void> _pushPendingSyncs() async {
    try {
      List<LivePickleballMatchModel> unsynced = await _localDb.getUnsyncedMatches();
      for (var match in unsynced) {
        await _firebaseDb.saveMatchToCloud(match);
        await _localDb.markMatchAsSynced(match.matchId);
        // ignore: avoid_print
        print("Successfully synced local match ${match.matchId} to Firebase.");
      }
    } catch (e) {
      // ignore: avoid_print
      print("Error pushing pending syncs to Firebase: $e");
    }
  }

  /// This should be called by the UI / Match Controller when the score changes
  Future<void> saveMatch(LivePickleballMatchModel match) async {
    // 1. Instantly save to local database
    await _localDb.saveMatch(match);
    
    // 2. Fire-and-forget sync to Firebase
    _syncMatchInBackground(match);
  }

  Future<void> _syncMatchInBackground(LivePickleballMatchModel match) async {
    try {
      await _firebaseDb.saveMatchToCloud(match);
      await _localDb.markMatchAsSynced(match.matchId);
    } catch (e) {
      // ignore: avoid_print
      print("Background sync failed for ${match.matchId}, will retry on next sync pass. Error: $e");
    }
  }

  // Get all matches for offline-first display (e.g. Match History screen)
  Future<List<LivePickleballMatchModel>> getOfflineMatches() async {
    return await _localDb.getAllMatches();
  }
}
