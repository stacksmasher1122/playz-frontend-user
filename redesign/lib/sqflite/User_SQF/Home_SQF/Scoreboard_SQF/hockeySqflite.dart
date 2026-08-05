import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Hockey/hockey_model.dart';

class HockeySqfliteService {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'hockey_matches.db');

    return await openDatabase(
      path,
      version: 1,
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
      CREATE TABLE IF NOT EXISTS hockey_matches (
        matchId TEXT PRIMARY KEY,
        userId TEXT,
        homeTeam TEXT,
        awayTeam TEXT,
        homeGoals INTEGER,
        awayGoals INTEGER,
        currentPeriodDisplay TEXT,
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
      final pragmaInfo = await db.rawQuery('PRAGMA table_info(hockey_matches);');
      final existingColumns = pragmaInfo.map((c) => c['name'] as String).toSet();

      final requiredColumns = {
        'userId': 'TEXT',
        'homeTeam': 'TEXT',
        'awayTeam': 'TEXT',
        'homeGoals': 'INTEGER',
        'awayGoals': 'INTEGER',
        'currentPeriodDisplay': 'TEXT',
        'isCompleted': 'INTEGER',
        'matchResult': 'TEXT',
        'engineState': 'TEXT',
        'createdAt': 'TEXT',
        'updatedAt': 'TEXT',
      };

      for (final entry in requiredColumns.entries) {
        if (!existingColumns.contains(entry.key)) {
          try {
            await db.execute('ALTER TABLE hockey_matches ADD COLUMN ${entry.key} ${entry.value};');
          } catch (_) {}
        }
      }
    } catch (_) {}
  }

  static Future<int> insertMatch(HockeyMatchModel match) async {
    final db = await database;
    try {
      return await db.insert(
        'hockey_matches',
        match.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (_) {
      await _ensureColumnsExist(db);
      return await db.insert(
        'hockey_matches',
        match.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  static Future<int> updateMatch(HockeyMatchModel match) async {
    final db = await database;
    try {
      return await db.update(
        'hockey_matches',
        match.toMap(),
        where: 'matchId = ?',
        whereArgs: [match.matchId],
      );
    } catch (_) {
      await _ensureColumnsExist(db);
      return await db.update(
        'hockey_matches',
        match.toMap(),
        where: 'matchId = ?',
        whereArgs: [match.matchId],
      );
    }
  }

  static Future<HockeyMatchModel?> getMatchById(String matchId) async {
    final db = await database;
    try {
      final List<Map<String, dynamic>> maps = await db.query(
        'hockey_matches',
        where: 'matchId = ?',
        whereArgs: [matchId],
      );

      if (maps.isNotEmpty) {
        return HockeyMatchModel.fromMap(maps.first);
      }
    } catch (_) {}
    return null;
  }

  static Future<List<HockeyMatchModel>> getUnfinishedMatches() async {
    final db = await database;
    try {
      final List<Map<String, dynamic>> maps = await db.query(
        'hockey_matches',
        where: 'isCompleted = ?',
        whereArgs: [0],
        orderBy: 'updatedAt DESC',
      );

      return List.generate(maps.length, (i) => HockeyMatchModel.fromMap(maps[i]));
    } catch (_) {
      return [];
    }
  }

  static Future<List<HockeyMatchModel>> getAllMatches() async {
    final db = await database;
    try {
      final List<Map<String, dynamic>> maps = await db.query(
        'hockey_matches',
        orderBy: 'updatedAt DESC',
      );

      return List.generate(maps.length, (i) => HockeyMatchModel.fromMap(maps[i]));
    } catch (_) {
      return [];
    }
  }

  static Future<int> deleteMatch(String matchId) async {
    final db = await database;
    try {
      return await db.delete(
        'hockey_matches',
        where: 'matchId = ?',
        whereArgs: [matchId],
      );
    } catch (_) {
      return 0;
    }
  }
}
