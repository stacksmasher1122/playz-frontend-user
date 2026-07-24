import 'package:redesign/score_engine/footballMatchEngine/football_match_engine.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:convert';
import 'package:redesign/model/football/football_model.dart';

class FootballSqflite {
  static final FootballSqflite instance = FootballSqflite._init();
  static Database? _database;

  FootballSqflite._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('football_matches.db');
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
    const boolType = 'INTEGER NOT NULL';

    await db.execute('''
CREATE TABLE football_matches (
  id $idType,
  createdBy $textType,
  sport $textType,
  allPlayers $textType,
  homeTeamPlayers $textType,
  awayTeamPlayers $textType,
  config $textType,
  isFriendlyRules $boolType,
  status $textType,
  engineState $textType,
  matchResult $textNullable,
  lastUpdatedAt $textType,
  createdAt $textType,
  tournamentId $textNullable,
  bracketMatchId $textNullable
  )
''');
  }

  Future<void> createMatch(FootballMatchModel match) async {
    final db = await instance.database;
    final map = _matchToMap(match);
    await db.insert(
      'football_matches',
      map,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateMatch(FootballMatchModel match) async {
    final db = await instance.database;
    final map = _matchToMap(match);
    await db.update(
      'football_matches',
      map,
      where: 'id = ?',
      whereArgs: [match.id],
    );
  }

  Future<FootballMatchModel?> getMatch(String matchId) async {
    final db = await instance.database;
    final maps = await db.query(
      'football_matches',
      where: 'id = ?',
      whereArgs: [matchId],
    );

    if (maps.isNotEmpty) {
      return _mapToMatch(maps.first);
    } else {
      return null;
    }
  }

  Future<List<FootballMatchModel>> getAllMatches() async {
    final db = await instance.database;
    final maps = await db.query('football_matches', orderBy: 'createdAt DESC');
    return maps.map((map) => _mapToMatch(map)).toList();
  }

  Map<String, dynamic> _matchToMap(FootballMatchModel match) {
    return {
      'id': match.id,
      'createdBy': match.createdBy,
      'sport': match.sport,
      'allPlayers': jsonEncode(match.allPlayers),
      'homeTeamPlayers': jsonEncode(match.homeTeamPlayers),
      'awayTeamPlayers': jsonEncode(match.awayTeamPlayers),
      'config': jsonEncode(match.config),
      'isFriendlyRules': match.isFriendlyRules ? 1 : 0,
      'status': match.status,
      'engineState': jsonEncode(match.engineState.toJson()),
      'matchResult': match.matchResult,
      'lastUpdatedAt': match.lastUpdatedAt.toIso8601String(),
      'createdAt': match.createdAt.toIso8601String(),
      'tournamentId': match.tournamentId,
      'bracketMatchId': match.bracketMatchId,
    };
  }

  FootballMatchModel _mapToMatch(Map<String, dynamic> map) {


    return FootballMatchModel(
      id: map['id'] as String,
      createdBy: map['createdBy'] as String,
      sport: map['sport'] as String? ?? 'football',
      allPlayers: List<String>.from(jsonDecode(map['allPlayers'] as String)),
      homeTeamPlayers: List<String>.from(jsonDecode(map['homeTeamPlayers'] as String)),
      awayTeamPlayers: List<String>.from(jsonDecode(map['awayTeamPlayers'] as String)),
      config: jsonDecode(map['config'] as String),
      isFriendlyRules: (map['isFriendlyRules'] as int) == 1,
      status: map['status'] as String,
      engineState: FootballMatchState.fromJson(jsonDecode(map['engineState'] as String)),
      matchResult: map['matchResult'] as String? ?? '',
      lastUpdatedAt: DateTime.parse(map['lastUpdatedAt'] as String),
      createdAt: DateTime.parse(map['createdAt'] as String),
      tournamentId: map['tournamentId'] as String?,
      bracketMatchId: map['bracketMatchId'] as String?,
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
