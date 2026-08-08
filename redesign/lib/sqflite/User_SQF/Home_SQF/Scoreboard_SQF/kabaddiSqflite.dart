// ignore_for_file: file_names
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Kabaddi/kabaddi_model.dart';

class KabaddiSqfliteService {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  static Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'kabaddi_matches.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE kabaddi_matches (
            matchId TEXT PRIMARY KEY,
            userId TEXT,
            homeTeam TEXT,
            awayTeam TEXT,
            homeScore INTEGER,
            awayScore INTEGER,
            currentHalf TEXT,
            isCompleted INTEGER,
            matchResult TEXT,
            sport TEXT,
            matchType TEXT,
            bookingId TEXT,
            engineState TEXT,
            createdAt TEXT,
            updatedAt TEXT
          )
        ''');
      },
    );
  }

  static Future<void> insertMatch(KabaddiMatchModel match) async {
    final db = await database;
    await db.insert(
      'kabaddi_matches',
      match.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> updateMatch(KabaddiMatchModel match) async {
    final db = await database;
    await db.update(
      'kabaddi_matches',
      match.toMap(),
      where: 'matchId = ?',
      whereArgs: [match.matchId],
    );
  }

  static Future<KabaddiMatchModel?> getMatchById(String matchId) async {
    final db = await database;
    final maps = await db.query(
      'kabaddi_matches',
      where: 'matchId = ?',
      whereArgs: [matchId],
    );
    if (maps.isNotEmpty) {
      return KabaddiMatchModel.fromMap(maps.first);
    }
    return null;
  }

  static Future<List<KabaddiMatchModel>> getUnfinishedMatches() async {
    final db = await database;
    final maps = await db.query(
      'kabaddi_matches',
      where: 'isCompleted = ?',
      whereArgs: [0],
      orderBy: 'updatedAt DESC',
    );
    return maps.map((m) => KabaddiMatchModel.fromMap(m)).toList();
  }

  static Future<List<KabaddiMatchModel>> getAllMatches() async {
    final db = await database;
    final maps = await db.query(
      'kabaddi_matches',
      orderBy: 'updatedAt DESC',
    );
    return maps.map((m) => KabaddiMatchModel.fromMap(m)).toList();
  }

  static Future<void> deleteMatch(String matchId) async {
    final db = await database;
    await db.delete(
      'kabaddi_matches',
      where: 'matchId = ?',
      whereArgs: [matchId],
    );
  }
}
