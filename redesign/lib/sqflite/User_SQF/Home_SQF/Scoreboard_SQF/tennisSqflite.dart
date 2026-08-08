// ignore_for_file: file_names
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../../../model/User_Models/Home_Models/Scoreboard_Model/Tennis/tennis_model.dart';

class TennisSqflite {
  static final TennisSqflite instance = TennisSqflite._init();
  static Database? _database;

  TennisSqflite._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('tennis_matches.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  Future _createDB(Database db, int version) async {
    const textType = 'TEXT';
    const integerType = 'INTEGER';

    await db.execute('''
CREATE TABLE tennis_matches (
  matchId $textType PRIMARY KEY,
  createdBy $textType,
  sport $textType DEFAULT 'tennis',
  status $textType,
  matchResult $textType DEFAULT '',
  allPlayers $textType DEFAULT '[]',
  homeTeamName $textType,
  awayTeamName $textType,
  homeTeamPlayers $textType DEFAULT '[]',
  awayTeamPlayers $textType DEFAULT '[]',
  engineState $textType,
  config $textType,
  createdAt $textType,
  lastUpdatedAt $textType,
  matchType $textType DEFAULT 'NORMAL',
  bookingId $textType,
  isRecoverable $integerType DEFAULT 1,
  tournamentId $textType,
  bracketMatchId $textType
)
''');
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE tennis_matches ADD COLUMN tournamentId TEXT');
      await db.execute('ALTER TABLE tennis_matches ADD COLUMN bracketMatchId TEXT');
    }
  }

  Future<void> insertOrUpdateMatch(TennisMatchModel match) async {
    final db = await instance.database;
    await db.insert(
      'tennis_matches',
      match.toSqfliteMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<TennisMatchModel?> getMatch(String matchId) async {
    final db = await instance.database;
    final maps = await db.query(
      'tennis_matches',
      where: 'matchId = ?',
      whereArgs: [matchId],
    );

    if (maps.isNotEmpty) {
      return TennisMatchModel.fromSqfliteMap(maps.first);
    }
    return null;
  }

  Future<List<TennisMatchModel>> getAllMatches() async {
    final db = await instance.database;
    final result = await db.query(
      'tennis_matches',
      orderBy: 'lastUpdatedAt DESC',
    );
    return result.map((json) => TennisMatchModel.fromSqfliteMap(json)).toList();
  }

  Future<int> deleteMatch(String matchId) async {
    final db = await instance.database;
    return await db.delete(
      'tennis_matches',
      where: 'matchId = ?',
      whereArgs: [matchId],
    );
  }
}
