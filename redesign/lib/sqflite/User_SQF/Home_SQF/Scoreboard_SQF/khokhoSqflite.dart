// ignore_for_file: file_names
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Kho_Kho/khokho_model.dart';

class KhoKhoSqfliteService {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'khokho_matches.db');

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
      CREATE TABLE IF NOT EXISTS khokho_matches (
        matchId TEXT PRIMARY KEY,
        userId TEXT,
        homeTeam TEXT,
        awayTeam TEXT,
        homePoints INTEGER,
        awayPoints INTEGER,
        currentTurnDisplay TEXT,
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
      final pragmaInfo = await db.rawQuery('PRAGMA table_info(khokho_matches);');
      final existingColumns = pragmaInfo.map((c) => c['name'] as String).toSet();

      final requiredColumns = {
        'userId': 'TEXT',
        'homeTeam': 'TEXT',
        'awayTeam': 'TEXT',
        'homePoints': 'INTEGER',
        'awayPoints': 'INTEGER',
        'currentTurnDisplay': 'TEXT',
        'isCompleted': 'INTEGER',
        'matchResult': 'TEXT',
        'engineState': 'TEXT',
        'createdAt': 'TEXT',
        'updatedAt': 'TEXT',
      };

      for (final entry in requiredColumns.entries) {
        if (!existingColumns.contains(entry.key)) {
          try {
            await db.execute('ALTER TABLE khokho_matches ADD COLUMN ${entry.key} ${entry.value};');
          } catch (_) {}
        }
      }
    } catch (_) {}
  }

  static Future<int> insertMatch(KhoKhoMatchModel match) async {
    final db = await database;
    try {
      return await db.insert(
        'khokho_matches',
        match.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (_) {
      await _ensureColumnsExist(db);
      return await db.insert(
        'khokho_matches',
        match.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  static Future<int> updateMatch(KhoKhoMatchModel match) async {
    final db = await database;
    try {
      return await db.update(
        'khokho_matches',
        match.toMap(),
        where: 'matchId = ?',
        whereArgs: [match.matchId],
      );
    } catch (_) {
      await _ensureColumnsExist(db);
      return await db.update(
        'khokho_matches',
        match.toMap(),
        where: 'matchId = ?',
        whereArgs: [match.matchId],
      );
    }
  }

  static Future<KhoKhoMatchModel?> getMatchById(String matchId) async {
    final db = await database;
    try {
      final List<Map<String, dynamic>> maps = await db.query(
        'khokho_matches',
        where: 'matchId = ?',
        whereArgs: [matchId],
      );

      if (maps.isNotEmpty) {
        return KhoKhoMatchModel.fromMap(maps.first);
      }
    } catch (_) {}
    return null;
  }

  static Future<List<KhoKhoMatchModel>> getUnfinishedMatches() async {
    final db = await database;
    try {
      final List<Map<String, dynamic>> maps = await db.query(
        'khokho_matches',
        where: 'isCompleted = ?',
        whereArgs: [0],
        orderBy: 'updatedAt DESC',
      );

      return List.generate(maps.length, (i) => KhoKhoMatchModel.fromMap(maps[i]));
    } catch (_) {
      return [];
    }
  }

  static Future<List<KhoKhoMatchModel>> getAllMatches() async {
    final db = await database;
    try {
      final List<Map<String, dynamic>> maps = await db.query(
        'khokho_matches',
        orderBy: 'updatedAt DESC',
      );

      return List.generate(maps.length, (i) => KhoKhoMatchModel.fromMap(maps[i]));
    } catch (_) {
      return [];
    }
  }

  static Future<int> deleteMatch(String matchId) async {
    final db = await database;
    try {
      return await db.delete(
        'khokho_matches',
        where: 'matchId = ?',
        whereArgs: [matchId],
      );
    } catch (_) {
      return 0;
    }
  }
}
