import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:convert';
import 'package:redesign/model/User_Models/Home_Models/Scoreboard_Model/Squash/squash_model.dart';

class SquashSqflite {
  static final SquashSqflite instance = SquashSqflite._init();
  static Database? _database;

  SquashSqflite._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('squash_matches.db');
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
    const boolType = 'INTEGER NOT NULL';

    await db.execute('''
CREATE TABLE squash_matches (
  matchId $idType,
  createdBy $textType,
  sport $textType,
  allPlayers $textType,
  teamAPlayers $textType,
  teamBPlayers $textType,
  maxAllowedPlayers $intType,
  isFriendlyRules $boolType,
  scoringSystem $textType,
  pointsToWin $intType,
  gamesToWin $intType,
  winByTwo $boolType,
  status $textType,
  createdAt $textType,
  engineState $textNullable,
  lastUpdatedAt $textNullable,
  matchResult $textType,
  pointLog $textType,
  tournamentId $textNullable,
  bracketMatchId $textNullable,
  bookingId $textNullable,
  matchType TEXT DEFAULT "NORMAL",
  isRecoverable INTEGER DEFAULT 1
  )
''');
  }

  Future<void> createMatch(SquashMatchModel match) async {
    final db = await instance.database;
    final map = _matchToMap(match);
    await db.insert(
      'squash_matches',
      map,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateMatch(SquashMatchModel match) async {
    final db = await instance.database;
    final map = _matchToMap(match);
    await db.update(
      'squash_matches',
      map,
      where: 'matchId = ?',
      whereArgs: [match.matchId],
    );
  }

  Future<SquashMatchModel?> getMatch(String matchId) async {
    final db = await instance.database;
    final maps = await db.query(
      'squash_matches',
      where: 'matchId = ?',
      whereArgs: [matchId],
    );

    if (maps.isNotEmpty) {
      return _mapToMatch(maps.first);
    } else {
      return null;
    }
  }

  Future<List<SquashMatchModel>> getAllMatches() async {
    final db = await instance.database;
    final maps = await db.query('squash_matches', orderBy: 'createdAt DESC');
    return maps.map((map) => _mapToMatch(map)).toList();
  }

  Map<String, dynamic> _matchToMap(SquashMatchModel match) {
    return {
      'matchId': match.matchId,
      'createdBy': match.createdBy,
      'sport': match.sport,
      'allPlayers': jsonEncode(match.allPlayers),
      'teamAPlayers': jsonEncode(match.teamAPlayers),
      'teamBPlayers': jsonEncode(match.teamBPlayers),
      'maxAllowedPlayers': match.maxAllowedPlayers,
      'isFriendlyRules': match.isFriendlyRules ? 1 : 0,
      'scoringSystem': match.scoringSystem,
      'pointsToWin': match.pointsToWin,
      'gamesToWin': match.gamesToWin,
      'winByTwo': match.winByTwo ? 1 : 0,
      'status': match.status,
      'createdAt': match.createdAt.toIso8601String(),
      'engineState': match.engineState != null ? jsonEncode(match.engineState) : null,
      'lastUpdatedAt': match.lastUpdatedAt?.toIso8601String(),
      'matchResult': match.matchResult,
      'pointLog': jsonEncode(match.pointLog),
      'tournamentId': match.tournamentId,
      'bracketMatchId': match.bracketMatchId,
      'bookingId': match.bookingId,
      'matchType': match.matchType,
      'isRecoverable': match.isRecoverable ? 1 : 0,
    };
  }

  SquashMatchModel _mapToMatch(Map<String, dynamic> map) {
    return SquashMatchModel(
      matchId: map['matchId'] as String,
      createdBy: map['createdBy'] as String,
      sport: map['sport'] as String? ?? 'squash',
      allPlayers: List<String>.from(jsonDecode(map['allPlayers'] as String)),
      teamAPlayers: List<String>.from(jsonDecode(map['teamAPlayers'] as String)),
      teamBPlayers: List<String>.from(jsonDecode(map['teamBPlayers'] as String)),
      maxAllowedPlayers: map['maxAllowedPlayers'] as int,
      isFriendlyRules: (map['isFriendlyRules'] as int) == 1,
      scoringSystem: map['scoringSystem'] as String? ?? 'pars',
      pointsToWin: map['pointsToWin'] as int,
      gamesToWin: map['gamesToWin'] as int,
      winByTwo: (map['winByTwo'] as int) == 1,
      status: map['status'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
      engineState: map['engineState'] != null ? jsonDecode(map['engineState'] as String) : null,
      lastUpdatedAt: map['lastUpdatedAt'] != null ? DateTime.parse(map['lastUpdatedAt'] as String) : null,
      matchResult: map['matchResult'] as String? ?? '',
      pointLog: List<Map<String, dynamic>>.from(jsonDecode(map['pointLog'] as String)),
      tournamentId: map['tournamentId'] as String?,
      bracketMatchId: map['bracketMatchId'] as String?,
      bookingId: map['bookingId'] as String?,
      matchType: map['matchType'] as String? ?? 'NORMAL',
      isRecoverable: (map['isRecoverable'] as int? ?? 1) == 1,
    );
  }

  Future<int> deleteMatch(String id) async {
    final db = await instance.database;
    return await db.delete(
      'squash_matches',
      where: 'matchId = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
