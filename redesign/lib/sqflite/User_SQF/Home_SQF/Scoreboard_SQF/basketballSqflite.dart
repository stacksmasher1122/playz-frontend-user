import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Basketball/basketball_model.dart';

class BasketballSqfliteService {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  static Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'basketball_matches.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE basketball_matches (
            matchId TEXT PRIMARY KEY,
            userId TEXT,
            homeTeam TEXT,
            awayTeam TEXT,
            homeScore INTEGER,
            awayScore INTEGER,
            currentQuarter TEXT,
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

  static Future<void> insertMatch(BasketballMatchModel match) async {
    final db = await database;
    await db.insert(
      'basketball_matches',
      match.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> updateMatch(BasketballMatchModel match) async {
    final db = await database;
    await db.update(
      'basketball_matches',
      match.toMap(),
      where: 'matchId = ?',
      whereArgs: [match.matchId],
    );
  }

  static Future<BasketballMatchModel?> getMatchById(String matchId) async {
    final db = await database;
    final maps = await db.query(
      'basketball_matches',
      where: 'matchId = ?',
      whereArgs: [matchId],
    );
    if (maps.isNotEmpty) {
      return BasketballMatchModel.fromMap(maps.first);
    }
    return null;
  }

  static Future<List<BasketballMatchModel>> getUnfinishedMatches() async {
    final db = await database;
    final maps = await db.query(
      'basketball_matches',
      where: 'isCompleted = ?',
      whereArgs: [0],
      orderBy: 'updatedAt DESC',
    );
    return maps.map((m) => BasketballMatchModel.fromMap(m)).toList();
  }

  static Future<List<BasketballMatchModel>> getAllMatches() async {
    final db = await database;
    final maps = await db.query(
      'basketball_matches',
      orderBy: 'updatedAt DESC',
    );
    return maps.map((m) => BasketballMatchModel.fromMap(m)).toList();
  }

  static Future<void> deleteMatch(String matchId) async {
    final db = await database;
    await db.delete(
      'basketball_matches',
      where: 'matchId = ?',
      whereArgs: [matchId],
    );
  }
}
