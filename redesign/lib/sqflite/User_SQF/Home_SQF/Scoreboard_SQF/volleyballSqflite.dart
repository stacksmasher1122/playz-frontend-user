import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Volleyball/volleyball_match_model.dart';

class VolleyballSqflite {
  static final VolleyballSqflite instance = VolleyballSqflite._init();
  static Database? _database;

  VolleyballSqflite._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('volleyball_matches.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path, 
      version: 3, 
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      try {
        await db.execute('ALTER TABLE volleyball_matches ADD COLUMN lineupA TEXT');
        await db.execute('ALTER TABLE volleyball_matches ADD COLUMN lineupB TEXT');
      } catch (e) {
        // Columns might already exist if they manually dropped DB
      }
    }
    if (oldVersion < 3) {
      try {
        await db.execute('ALTER TABLE volleyball_matches ADD COLUMN scoreTeamA INTEGER DEFAULT 0');
        await db.execute('ALTER TABLE volleyball_matches ADD COLUMN scoreTeamB INTEGER DEFAULT 0');
        await db.execute('ALTER TABLE volleyball_matches ADD COLUMN setsTeamA INTEGER DEFAULT 0');
        await db.execute('ALTER TABLE volleyball_matches ADD COLUMN setsTeamB INTEGER DEFAULT 0');
        await db.execute('ALTER TABLE volleyball_matches ADD COLUMN currentSet INTEGER DEFAULT 1');
        await db.execute('ALTER TABLE volleyball_matches ADD COLUMN isTeamAServing INTEGER DEFAULT 1');
        await db.execute('ALTER TABLE volleyball_matches ADD COLUMN matchSeconds INTEGER DEFAULT 0');
        await db.execute('ALTER TABLE volleyball_matches ADD COLUMN isPaused INTEGER DEFAULT 1');
      } catch (e) {
        // Columns might already exist
      }
    }
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE volleyball_matches (
        matchId TEXT PRIMARY KEY,
        createdBy TEXT,
        matchName TEXT,
        tournament TEXT,
        date TEXT,
        time TEXT,
        venue TEXT,
        court TEXT,
        referee TEXT,
        assistantReferee TEXT,
        category TEXT,
        format TEXT,
        pointsPerSet INTEGER,
        finalSetPoints INTEGER,
        timeouts INTEGER,
        substitutions INTEGER,
        technicalTimeout INTEGER,
        liberoEnabled INTEGER,
        challengeEnabled INTEGER,
        videoReview INTEGER,
        winByTwo INTEGER,
        status TEXT,
        createdAt TEXT,
        homeTeamName TEXT,
        awayTeamName TEXT,
        homeCoachName TEXT,
        awayCoachName TEXT,
        homeTeamPlayers TEXT,
        awayTeamPlayers TEXT,
        metadata TEXT,
        lineupA TEXT,
        lineupB TEXT,
        scoreTeamA INTEGER,
        scoreTeamB INTEGER,
        setsTeamA INTEGER,
        setsTeamB INTEGER,
        currentSet INTEGER,
        isTeamAServing INTEGER,
        matchSeconds INTEGER,
        isPaused INTEGER
      )
    ''');
  }

  Future<void> insertMatch(VolleyballMatchModel match) async {
    final db = await instance.database;
    await db.insert(
      'volleyball_matches',
      match.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<VolleyballMatchModel?> getMatch(String id) async {
    final db = await instance.database;
    final maps = await db.query(
      'volleyball_matches',
      where: 'matchId = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return VolleyballMatchModel.fromMap(maps.first);
    }
    return null;
  }

  Future<List<VolleyballMatchModel>> getAllMatches() async {
    final db = await instance.database;
    final result = await db.query(
      'volleyball_matches',
      orderBy: 'createdAt DESC',
    );
    return result.map((json) => VolleyballMatchModel.fromMap(json)).toList();
  }

  Future<int> updateMatch(VolleyballMatchModel match) async {
    final db = await instance.database;
    return db.update(
      'volleyball_matches',
      match.toMap(),
      where: 'matchId = ?',
      whereArgs: [match.matchId],
    );
  }

  Future<int> deleteMatch(String id) async {
    final db = await instance.database;
    return db.delete(
      'volleyball_matches',
      where: 'matchId = ?',
      whereArgs: [id],
    );
  }
}
