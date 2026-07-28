import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Pickleball/live_pickleball_match_model.dart';
import 'dart:convert';

class PickleballDatabaseHelper {
  static final PickleballDatabaseHelper instance = PickleballDatabaseHelper._init();
  static Database? _database;

  PickleballDatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('pickleball_matches.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'TEXT PRIMARY KEY';
    const textType = 'TEXT NOT NULL';
    const intType = 'INTEGER NOT NULL';

    await db.execute('''
CREATE TABLE pb_matches (
  matchId $idType,
  teamA $textType,
  teamB $textType,
  scoreA $intType,
  scoreB $intType,
  setsA $intType,
  setsB $intType,
  server $textType,
  game $textType,
  "set" $textType,
  court $textType,
  status $textType,
  duration $textType,
  statistics TEXT,
  is_synced INTEGER DEFAULT 0
)
''');
  }

  Future<void> saveMatch(LivePickleballMatchModel match) async {
    final db = await instance.database;
    final map = match.toMap();
    map['statistics'] = jsonEncode(match.statistics);
    map['is_synced'] = 0; // Mark as unsynced
    
    // Use replace to insert or update
    await db.insert('pb_matches', map, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<LivePickleballMatchModel?> getMatch(String id) async {
    final db = await instance.database;
    final maps = await db.query(
      'pb_matches',
      columns: null,
      where: 'matchId = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      var map = Map<String, dynamic>.from(maps.first);
      map['statistics'] = jsonDecode(map['statistics'] as String);
      return LivePickleballMatchModel.fromMap(map);
    } else {
      return null;
    }
  }

  Future<List<LivePickleballMatchModel>> getUnsyncedMatches() async {
    final db = await instance.database;
    final result = await db.query('pb_matches', where: 'is_synced = ?', whereArgs: [0]);
    
    return result.map((json) {
      var map = Map<String, dynamic>.from(json);
      map['statistics'] = jsonDecode(map['statistics'] as String);
      return LivePickleballMatchModel.fromMap(map);
    }).toList();
  }

  Future<void> markMatchAsSynced(String matchId) async {
    final db = await instance.database;
    await db.update(
      'pb_matches',
      {'is_synced': 1},
      where: 'matchId = ?',
      whereArgs: [matchId],
    );
  }

  Future<void> saveMatchesFromCloud(List<LivePickleballMatchModel> matches) async {
    final db = await instance.database;
    Batch batch = db.batch();
    for (var match in matches) {
      final map = match.toMap();
      map['statistics'] = jsonEncode(match.statistics);
      map['is_synced'] = 1; // It's from cloud, so it's synced
      batch.insert('pb_matches', map, conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit(noResult: true);
  }

  Future<List<LivePickleballMatchModel>> getAllMatches() async {
    final db = await instance.database;
    final result = await db.query('pb_matches', orderBy: 'matchId DESC');
    
    return result.map((json) {
      var map = Map<String, dynamic>.from(json);
      map['statistics'] = jsonDecode(map['statistics'] as String);
      return LivePickleballMatchModel.fromMap(map);
    }).toList();
  }
}
