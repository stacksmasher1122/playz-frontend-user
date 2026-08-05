import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Taekwondo/taekwondo_model.dart';

class TaekwondoSqfliteService {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  static Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'taekwondo_matches.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE taekwondo_matches (
            matchId TEXT PRIMARY KEY,
            userId TEXT,
            hongFighter TEXT,
            chongFighter TEXT,
            hongScore INTEGER,
            chongScore INTEGER,
            currentRoundDisplay TEXT,
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
    final columns = await db.rawQuery('PRAGMA table_info(taekwondo_matches)');
    final columnNames = columns.map((c) => c['name'] as String).toSet();

    if (!columnNames.contains('engineState')) {
      await db.execute('ALTER TABLE taekwondo_matches ADD COLUMN engineState TEXT');
    }
  }

  static Future<void> insertMatch(TaekwondoMatchModel match) async {
    final db = await database;
    await db.insert(
      'taekwondo_matches',
      match.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> updateMatch(TaekwondoMatchModel match) async {
    final db = await database;
    await db.update(
      'taekwondo_matches',
      match.toMap(),
      where: 'matchId = ?',
      whereArgs: [match.matchId],
    );
  }

  static Future<TaekwondoMatchModel?> getMatchById(String matchId) async {
    final db = await database;
    final maps = await db.query(
      'taekwondo_matches',
      where: 'matchId = ?',
      whereArgs: [matchId],
    );
    if (maps.isNotEmpty) {
      return TaekwondoMatchModel.fromMap(maps.first);
    }
    return null;
  }

  static Future<List<TaekwondoMatchModel>> getUnfinishedMatches() async {
    final db = await database;
    final maps = await db.query(
      'taekwondo_matches',
      where: 'isCompleted = 0',
      orderBy: 'updatedAt DESC',
    );
    return maps.map((m) => TaekwondoMatchModel.fromMap(m)).toList();
  }

  static Future<List<TaekwondoMatchModel>> getAllMatches() async {
    final db = await database;
    final maps = await db.query(
      'taekwondo_matches',
      orderBy: 'updatedAt DESC',
    );
    return maps.map((m) => TaekwondoMatchModel.fromMap(m)).toList();
  }

  static Future<void> deleteMatch(String matchId) async {
    final db = await database;
    await db.delete(
      'taekwondo_matches',
      where: 'matchId = ?',
      whereArgs: [matchId],
    );
  }
}
