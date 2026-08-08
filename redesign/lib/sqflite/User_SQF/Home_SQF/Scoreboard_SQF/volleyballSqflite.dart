// ignore_for_file: file_names
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Volleyball/volleyball_model.dart';

class VolleyballSqfliteService {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'volleyball_matches.db');

    return await openDatabase(
      path,
      version: 3,
      onCreate: (db, version) async {
        await _createTable(db);
      },
      onOpen: (db) async {
        await _ensureColumnsExist(db);
      },
    );
  }

  static Future<void> _createTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS volleyball_matches (
        matchId TEXT PRIMARY KEY,
        userId TEXT,
        homeTeam TEXT,
        awayTeam TEXT,
        homeSetsWon INTEGER,
        awaySetsWon INTEGER,
        currentSetDisplay TEXT,
        isCompleted INTEGER,
        matchResult TEXT,
        engineState TEXT,
        createdAt TEXT,
        updatedAt TEXT
      )
    ''');
  }

  static Future<void> _ensureColumnsExist(Database db) async {
    await _createTable(db);
    try {
      final pragmaInfo = await db.rawQuery('PRAGMA table_info(volleyball_matches);');
      final existingColumns = pragmaInfo.map((c) => c['name'] as String).toSet();

      final requiredColumns = {
        'userId': 'TEXT',
        'homeTeam': 'TEXT',
        'awayTeam': 'TEXT',
        'homeSetsWon': 'INTEGER',
        'awaySetsWon': 'INTEGER',
        'currentSetDisplay': 'TEXT',
        'isCompleted': 'INTEGER',
        'matchResult': 'TEXT',
        'engineState': 'TEXT',
        'createdAt': 'TEXT',
        'updatedAt': 'TEXT',
      };

      for (final entry in requiredColumns.entries) {
        if (!existingColumns.contains(entry.key)) {
          try {
            await db.execute('ALTER TABLE volleyball_matches ADD COLUMN ${entry.key} ${entry.value};');
          } catch (_) {}
        }
      }
    } catch (_) {}
  }

  static Future<int> insertMatch(VolleyballMatchModel match) async {
    final db = await database;
    try {
      return await db.insert(
        'volleyball_matches',
        match.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (_) {
      await _ensureColumnsExist(db);
      return await db.insert(
        'volleyball_matches',
        match.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  static Future<int> updateMatch(VolleyballMatchModel match) async {
    final db = await database;
    try {
      return await db.update(
        'volleyball_matches',
        match.toMap(),
        where: 'matchId = ?',
        whereArgs: [match.matchId],
      );
    } catch (_) {
      await _ensureColumnsExist(db);
      return await db.update(
        'volleyball_matches',
        match.toMap(),
        where: 'matchId = ?',
        whereArgs: [match.matchId],
      );
    }
  }

  static Future<VolleyballMatchModel?> getMatchById(String matchId) async {
    final db = await database;
    try {
      final List<Map<String, dynamic>> maps = await db.query(
        'volleyball_matches',
        where: 'matchId = ?',
        whereArgs: [matchId],
      );

      if (maps.isNotEmpty) {
        return VolleyballMatchModel.fromMap(maps.first);
      }
    } catch (_) {}
    return null;
  }

  static Future<List<VolleyballMatchModel>> getUnfinishedMatches() async {
    final db = await database;
    try {
      final List<Map<String, dynamic>> maps = await db.query(
        'volleyball_matches',
        where: 'isCompleted = ?',
        whereArgs: [0],
        orderBy: 'updatedAt DESC',
      );

      return List.generate(maps.length, (i) => VolleyballMatchModel.fromMap(maps[i]));
    } catch (_) {
      return [];
    }
  }

  static Future<List<VolleyballMatchModel>> getAllMatches() async {
    final db = await database;
    try {
      final List<Map<String, dynamic>> maps = await db.query(
        'volleyball_matches',
        orderBy: 'updatedAt DESC',
      );

      return List.generate(maps.length, (i) => VolleyballMatchModel.fromMap(maps[i]));
    } catch (_) {
      return [];
    }
  }

  static Future<int> deleteMatch(String matchId) async {
    final db = await database;
    try {
      return await db.delete(
        'volleyball_matches',
        where: 'matchId = ?',
        whereArgs: [matchId],
      );
    } catch (_) {
      return 0;
    }
  }
}
