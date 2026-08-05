import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Boxing/boxing_model.dart';

class BoxingSqfliteService {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'boxing_matches.db');

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
      CREATE TABLE IF NOT EXISTS boxing_matches (
        matchId TEXT PRIMARY KEY,
        userId TEXT,
        fighterA TEXT,
        fighterB TEXT,
        fighterAScore INTEGER,
        fighterBScore INTEGER,
        currentRoundDisplay TEXT,
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
      final pragmaInfo = await db.rawQuery('PRAGMA table_info(boxing_matches);');
      final existingColumns = pragmaInfo.map((c) => c['name'] as String).toSet();

      final requiredColumns = {
        'userId': 'TEXT',
        'fighterA': 'TEXT',
        'fighterB': 'TEXT',
        'fighterAScore': 'INTEGER',
        'fighterBScore': 'INTEGER',
        'currentRoundDisplay': 'TEXT',
        'isCompleted': 'INTEGER',
        'matchResult': 'TEXT',
        'engineState': 'TEXT',
        'createdAt': 'TEXT',
        'updatedAt': 'TEXT',
      };

      for (final entry in requiredColumns.entries) {
        if (!existingColumns.contains(entry.key)) {
          try {
            await db.execute('ALTER TABLE boxing_matches ADD COLUMN ${entry.key} ${entry.value};');
          } catch (_) {}
        }
      }
    } catch (_) {}
  }

  static Future<int> insertMatch(BoxingMatchModel match) async {
    final db = await database;
    try {
      return await db.insert(
        'boxing_matches',
        match.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (_) {
      await _ensureColumnsExist(db);
      return await db.insert(
        'boxing_matches',
        match.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  static Future<int> updateMatch(BoxingMatchModel match) async {
    final db = await database;
    try {
      return await db.update(
        'boxing_matches',
        match.toMap(),
        where: 'matchId = ?',
        whereArgs: [match.matchId],
      );
    } catch (_) {
      await _ensureColumnsExist(db);
      return await db.update(
        'boxing_matches',
        match.toMap(),
        where: 'matchId = ?',
        whereArgs: [match.matchId],
      );
    }
  }

  static Future<BoxingMatchModel?> getMatchById(String matchId) async {
    final db = await database;
    try {
      final List<Map<String, dynamic>> maps = await db.query(
        'boxing_matches',
        where: 'matchId = ?',
        whereArgs: [matchId],
      );

      if (maps.isNotEmpty) {
        return BoxingMatchModel.fromMap(maps.first);
      }
    } catch (_) {}
    return null;
  }

  static Future<List<BoxingMatchModel>> getUnfinishedMatches() async {
    final db = await database;
    try {
      final List<Map<String, dynamic>> maps = await db.query(
        'boxing_matches',
        where: 'isCompleted = ?',
        whereArgs: [0],
        orderBy: 'updatedAt DESC',
      );

      return List.generate(maps.length, (i) => BoxingMatchModel.fromMap(maps[i]));
    } catch (_) {
      return [];
    }
  }

  static Future<List<BoxingMatchModel>> getAllMatches() async {
    final db = await database;
    try {
      final List<Map<String, dynamic>> maps = await db.query(
        'boxing_matches',
        orderBy: 'updatedAt DESC',
      );

      return List.generate(maps.length, (i) => BoxingMatchModel.fromMap(maps[i]));
    } catch (_) {
      return [];
    }
  }

  static Future<int> deleteMatch(String matchId) async {
    final db = await database;
    try {
      return await db.delete(
        'boxing_matches',
        where: 'matchId = ?',
        whereArgs: [matchId],
      );
    } catch (_) {
      return 0;
    }
  }
}
