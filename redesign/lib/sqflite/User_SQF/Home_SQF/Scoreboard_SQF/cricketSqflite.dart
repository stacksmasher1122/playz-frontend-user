import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/cricket_model.dart';

class CricketSqflite {
  static final CricketSqflite instance = CricketSqflite._init();
  static Database? _database;

  CricketSqflite._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('cricket_matches.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 5,
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE matches ADD COLUMN tossWinner TEXT');
      await db.execute('ALTER TABLE matches ADD COLUMN tossDecision TEXT');
      await db.execute('ALTER TABLE matches ADD COLUMN battingFirstTeam TEXT');
      await db.execute('ALTER TABLE matches ADD COLUMN bowlingFirstTeam TEXT');
    }
    if (oldVersion < 3) {
      await db.execute('ALTER TABLE matches ADD COLUMN currentInnings INTEGER DEFAULT 1');
      await db.execute('ALTER TABLE matches ADD COLUMN innings1Score INTEGER DEFAULT 0');
      await db.execute('ALTER TABLE matches ADD COLUMN innings1Wickets INTEGER DEFAULT 0');
      await db.execute('ALTER TABLE matches ADD COLUMN innings1Overs INTEGER DEFAULT 0');
      await db.execute('ALTER TABLE matches ADD COLUMN innings1Balls INTEGER DEFAULT 0');
      await db.execute('ALTER TABLE matches ADD COLUMN currentBattingTeam TEXT DEFAULT ""');
      await db.execute('ALTER TABLE matches ADD COLUMN currentBowlingTeam TEXT DEFAULT ""');
      await db.execute('ALTER TABLE matches ADD COLUMN matchResult TEXT DEFAULT ""');
      await db.execute('ALTER TABLE matches ADD COLUMN ballEvents TEXT DEFAULT "[]"');
    }
    if (oldVersion < 4) {
      await db.execute('ALTER TABLE matches ADD COLUMN innings2Score INTEGER DEFAULT 0');
      await db.execute('ALTER TABLE matches ADD COLUMN innings2Wickets INTEGER DEFAULT 0');
      await db.execute('ALTER TABLE matches ADD COLUMN innings2Overs INTEGER DEFAULT 0');
      await db.execute('ALTER TABLE matches ADD COLUMN innings2Balls INTEGER DEFAULT 0');
      await db.execute('ALTER TABLE matches ADD COLUMN engineState TEXT');
      await db.execute('ALTER TABLE matches ADD COLUMN lastUpdatedAt TEXT');
    }
    if (oldVersion < 5) {
      await db.execute('ALTER TABLE matches ADD COLUMN inningsArray TEXT DEFAULT "[]"');
    }
  }

  Future _createDB(Database db, int version) async {
    const textType = 'TEXT';
    const integerType = 'INTEGER';

    await db.execute('''
CREATE TABLE matches (
  matchId $textType PRIMARY KEY,
  createdBy $textType,
  allPlayers $textType,
  homeTeamName $textType,
  awayTeamName $textType,
  homeTeamPlayers $textType,
  awayTeamPlayers $textType,
  squadLimit $integerType,
  subsEnabled $integerType,
  maxSubstitutes $integerType,
  overs $integerType,
  status $textType,
  scorecard $textType,
  createdAt $textType,
  tossWinner $textType,
  tossDecision $textType,
  battingFirstTeam $textType,
  bowlingFirstTeam $textType,
  currentInnings $integerType DEFAULT 1,
  innings1Score $integerType DEFAULT 0,
  innings1Wickets $integerType DEFAULT 0,
  innings1Overs $integerType DEFAULT 0,
  innings1Balls $integerType DEFAULT 0,
  innings2Score $integerType DEFAULT 0,
  innings2Wickets $integerType DEFAULT 0,
  innings2Overs $integerType DEFAULT 0,
  innings2Balls $integerType DEFAULT 0,
  inningsArray $textType DEFAULT "[]",
  engineState $textType,
  lastUpdatedAt $textType,
  currentBattingTeam $textType,
  currentBowlingTeam $textType,
  matchResult $textType,
  ballEvents $textType
)
''');
  }

  Future<void> insertMatch(CricketMatchModel match) async {
    final db = await instance.database;
    await db.insert('matches', match.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<CricketMatchModel?> getMatch(String id) async {
    final db = await instance.database;
    final maps = await db.query(
      'matches',
      columns: null,
      where: 'matchId = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return CricketMatchModel.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<List<CricketMatchModel>> getAllMatches() async {
    final db = await instance.database;
    const orderBy = 'createdAt DESC';
    final result = await db.query('matches', orderBy: orderBy);

    return result.map((json) => CricketMatchModel.fromMap(json)).toList();
  }

  Future<int> updateMatch(CricketMatchModel match) async {
    final db = await instance.database;

    return db.update(
      'matches',
      match.toMap(),
      where: 'matchId = ?',
      whereArgs: [match.matchId],
    );
  }

  /// Quick scorecard update without rebuilding the full model
  Future<int> updateMatchScorecard(String matchId, Map<String, dynamic> updates) async {
    final db = await instance.database;
    return db.update(
      'matches',
      updates,
      where: 'matchId = ?',
      whereArgs: [matchId],
    );
  }

  Future<int> deleteMatch(String id) async {
    final db = await instance.database;

    return await db.delete(
      'matches',
      where: 'matchId = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
