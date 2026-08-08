// ignore_for_file: file_names
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Judo/judo_model.dart';

class JudoSqfliteService {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  static Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'judo_matches.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE judo_matches (
            matchId TEXT PRIMARY KEY,
            userId TEXT,
            whiteFighter TEXT,
            blueFighter TEXT,
            whiteWazaAri INTEGER,
            blueWazaAri INTEGER,
            currentContestDisplay TEXT,
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
    final columns = await db.rawQuery('PRAGMA table_info(judo_matches)');
    final columnNames = columns.map((c) => c['name'] as String).toSet();

    if (!columnNames.contains('engineState')) {
      await db.execute('ALTER TABLE judo_matches ADD COLUMN engineState TEXT');
    }
  }

  static Future<void> insertMatch(JudoMatchModel match) async {
    final db = await database;
    await db.insert(
      'judo_matches',
      match.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> updateMatch(JudoMatchModel match) async {
    final db = await database;
    await db.update(
      'judo_matches',
      match.toMap(),
      where: 'matchId = ?',
      whereArgs: [match.matchId],
    );
  }

  static Future<JudoMatchModel?> getMatchById(String matchId) async {
    final db = await database;
    final maps = await db.query(
      'judo_matches',
      where: 'matchId = ?',
      whereArgs: [matchId],
    );
    if (maps.isNotEmpty) {
      return JudoMatchModel.fromMap(maps.first);
    }
    return null;
  }

  static Future<List<JudoMatchModel>> getUnfinishedMatches() async {
    final db = await database;
    final maps = await db.query(
      'judo_matches',
      where: 'isCompleted = 0',
      orderBy: 'updatedAt DESC',
    );
    return maps.map((m) => JudoMatchModel.fromMap(m)).toList();
  }

  static Future<List<JudoMatchModel>> getAllMatches() async {
    final db = await database;
    final maps = await db.query(
      'judo_matches',
      orderBy: 'updatedAt DESC',
    );
    return maps.map((m) => JudoMatchModel.fromMap(m)).toList();
  }

  static Future<void> deleteMatch(String matchId) async {
    final db = await database;
    await db.delete(
      'judo_matches',
      where: 'matchId = ?',
      whereArgs: [matchId],
    );
  }
}
