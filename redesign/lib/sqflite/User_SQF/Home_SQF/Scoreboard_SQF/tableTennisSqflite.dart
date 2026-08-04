import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../../../model/User_Models/Home_Models/Scoreboard_Model/Table_Tennis/table_tennis_model.dart';

class TableTennisSqflite {
  static final TableTennisSqflite instance = TableTennisSqflite._init();
  static Database? _database;

  TableTennisSqflite._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('table_tennis_matches.db');
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
CREATE TABLE table_tennis_matches (
  matchId $textType PRIMARY KEY,
  createdBy $textType,
  sport $textType DEFAULT 'table_tennis',
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
      await db.execute('ALTER TABLE table_tennis_matches ADD COLUMN tournamentId TEXT');
      await db.execute('ALTER TABLE table_tennis_matches ADD COLUMN bracketMatchId TEXT');
    }
  }

  Future<void> insertOrUpdateMatch(TableTennisMatchModel match) async {
    final db = await instance.database;
    await db.insert(
      'table_tennis_matches',
      match.toSqfliteMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<TableTennisMatchModel?> getMatch(String matchId) async {
    final db = await instance.database;
    final maps = await db.query(
      'table_tennis_matches',
      where: 'matchId = ?',
      whereArgs: [matchId],
    );

    if (maps.isNotEmpty) {
      return TableTennisMatchModel.fromSqfliteMap(maps.first);
    }
    return null;
  }

  Future<List<TableTennisMatchModel>> getAllMatches() async {
    final db = await instance.database;
    final result = await db.query(
      'table_tennis_matches',
      orderBy: 'lastUpdatedAt DESC',
    );
    return result.map((json) => TableTennisMatchModel.fromSqfliteMap(json)).toList();
  }

  Future<int> deleteMatch(String matchId) async {
    final db = await instance.database;
    return await db.delete(
      'table_tennis_matches',
      where: 'matchId = ?',
      whereArgs: [matchId],
    );
  }
}
