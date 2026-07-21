import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:convert';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/badminton_model.dart';

class BadmintonSqflite {
  static final BadmintonSqflite instance = BadmintonSqflite._init();
  static Database? _database;

  BadmintonSqflite._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('badminton_matches.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    const idType = 'TEXT PRIMARY KEY';
    const textType = 'TEXT NOT NULL';
    const textNullable = 'TEXT';
    const intType = 'INTEGER NOT NULL';
    const boolType = 'INTEGER NOT NULL'; // SQLite doesn't have a boolean type

    await db.execute('''
CREATE TABLE badminton_matches (
  matchId $idType,
  createdBy $textType,
  sport $textType,
  allPlayers $textType,
  teamAPlayers $textType,
  teamBPlayers $textType,
  maxAllowedPlayers $intType,
  isFriendlyRules $boolType,
  pointsToWin $intType,
  maxPointCap $intType,
  winByTwo $boolType,
  gamesToWin $intType,
  intervalsEnabled $boolType,
  endsChangeEnabled $boolType,
  status $textType,
  createdAt $textType,
  engineState $textNullable,
  lastUpdatedAt $textNullable,
  matchResult $textType,
  pointLog $textType
  )
''');
  }

  Future<void> createMatch(BadmintonMatchModel match) async {
    final db = await instance.database;
    final map = _matchToMap(match);
    await db.insert(
      'badminton_matches',
      map,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateMatch(BadmintonMatchModel match) async {
    final db = await instance.database;
    final map = _matchToMap(match);
    await db.update(
      'badminton_matches',
      map,
      where: 'matchId = ?',
      whereArgs: [match.matchId],
    );
  }

  Future<BadmintonMatchModel?> getMatch(String matchId) async {
    final db = await instance.database;
    final maps = await db.query(
      'badminton_matches',
      where: 'matchId = ?',
      whereArgs: [matchId],
    );

    if (maps.isNotEmpty) {
      return _mapToMatch(maps.first);
    } else {
      return null;
    }
  }

  Future<List<BadmintonMatchModel>> getAllMatches() async {
    final db = await instance.database;
    final maps = await db.query('badminton_matches', orderBy: 'createdAt DESC');
    return maps.map((map) => _mapToMatch(map)).toList();
  }

  Map<String, dynamic> _matchToMap(BadmintonMatchModel match) {
    return {
      'matchId': match.matchId,
      'createdBy': match.createdBy,
      'sport': match.sport,
      'allPlayers': jsonEncode(match.allPlayers),
      'teamAPlayers': jsonEncode(match.teamAPlayers),
      'teamBPlayers': jsonEncode(match.teamBPlayers),
      'maxAllowedPlayers': match.maxAllowedPlayers,
      'isFriendlyRules': match.isFriendlyRules ? 1 : 0,
      'pointsToWin': match.pointsToWin,
      'maxPointCap': match.maxPointCap,
      'winByTwo': match.winByTwo ? 1 : 0,
      'gamesToWin': match.gamesToWin,
      'intervalsEnabled': match.intervalsEnabled ? 1 : 0,
      'endsChangeEnabled': match.endsChangeEnabled ? 1 : 0,
      'status': match.status,
      'createdAt': match.createdAt.toIso8601String(),
      'engineState': match.engineState != null ? jsonEncode(match.engineState) : null,
      'lastUpdatedAt': match.lastUpdatedAt?.toIso8601String(),
      'matchResult': match.matchResult,
      'pointLog': jsonEncode(match.pointLog),
    };
  }

  BadmintonMatchModel _mapToMatch(Map<String, dynamic> map) {
    return BadmintonMatchModel(
      matchId: map['matchId'] as String,
      createdBy: map['createdBy'] as String,
      sport: map['sport'] as String? ?? 'badminton',
      allPlayers: List<String>.from(jsonDecode(map['allPlayers'] as String)),
      teamAPlayers: List<String>.from(jsonDecode(map['teamAPlayers'] as String)),
      teamBPlayers: List<String>.from(jsonDecode(map['teamBPlayers'] as String)),
      maxAllowedPlayers: map['maxAllowedPlayers'] as int,
      isFriendlyRules: (map['isFriendlyRules'] as int) == 1,
      pointsToWin: map['pointsToWin'] as int,
      maxPointCap: map['maxPointCap'] as int,
      winByTwo: (map['winByTwo'] as int) == 1,
      gamesToWin: map['gamesToWin'] as int,
      intervalsEnabled: (map['intervalsEnabled'] as int) == 1,
      endsChangeEnabled: (map['endsChangeEnabled'] as int) == 1,
      status: map['status'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
      engineState: map['engineState'] != null ? jsonDecode(map['engineState'] as String) : null,
      lastUpdatedAt: map['lastUpdatedAt'] != null ? DateTime.parse(map['lastUpdatedAt'] as String) : null,
      matchResult: map['matchResult'] as String? ?? '',
      pointLog: List<Map<String, dynamic>>.from(jsonDecode(map['pointLog'] as String)),
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
