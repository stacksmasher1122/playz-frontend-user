import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Wrestling/wrestling_model.dart';

class WrestlingSqfliteService {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  static Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'wrestling_matches.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE wrestling_matches (
            matchId TEXT PRIMARY KEY,
            userId TEXT,
            wrestlerA TEXT,
            wrestlerB TEXT,
            wrestlerAScore INTEGER,
            wrestlerBScore INTEGER,
            currentPeriodDisplay TEXT,
            isCompleted INTEGER,
            matchResult TEXT,
            engineState TEXT,
            createdAt TEXT,
            updatedAt TEXT
          )
        ''');
      },
      onOpen: (db) async {
        await _ensureColumnsExist(db);
      },
    );
  }

  static Future<void> _ensureColumnsExist(Database db) async {
    final columns = await db.rawQuery('PRAGMA table_info(wrestling_matches)');
    final columnNames = columns.map((c) => c['name'] as String).toSet();

    if (!columnNames.contains('engineState')) {
      await db.execute('ALTER TABLE wrestling_matches ADD COLUMN engineState TEXT');
    }
  }

  static Future<void> insertMatch(WrestlingMatchModel match) async {
    final db = await database;
    await db.insert(
      'wrestling_matches',
      match.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> updateMatch(WrestlingMatchModel match) async {
    final db = await database;
    await db.update(
      'wrestling_matches',
      match.toMap(),
      where: 'matchId = ?',
      whereArgs: [match.matchId],
    );
  }

  static Future<WrestlingMatchModel?> getMatchById(String matchId) async {
    final db = await database;
    final maps = await db.query(
      'wrestling_matches',
      where: 'matchId = ?',
      whereArgs: [matchId],
    );
    if (maps.isNotEmpty) {
      return WrestlingMatchModel.fromMap(maps.first);
    }
    return null;
  }

  static Future<List<WrestlingMatchModel>> getUnfinishedMatches() async {
    final db = await database;
    final maps = await db.query(
      'wrestling_matches',
      where: 'isCompleted = 0',
      orderBy: 'updatedAt DESC',
    );
    return maps.map((m) => WrestlingMatchModel.fromMap(m)).toList();
  }

  static Future<List<WrestlingMatchModel>> getAllMatches() async {
    final db = await database;
    final maps = await db.query(
      'wrestling_matches',
      orderBy: 'updatedAt DESC',
    );
    return maps.map((m) => WrestlingMatchModel.fromMap(m)).toList();
  }

  static Future<void> deleteMatch(String matchId) async {
    final db = await database;
    await db.delete(
      'wrestling_matches',
      where: 'matchId = ?',
      whereArgs: [matchId],
    );
  }
}
