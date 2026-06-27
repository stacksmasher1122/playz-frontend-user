import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'package:redesign/model/User_Models/Home_Models/Groups_Model/group_info_model.dart';

// ═══════════════════════════════════════════════════════
//  GROUP INFO SQFLITE
// ═══════════════════════════════════════════════════════
class GroupsInfoSqflite {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  static Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'groups_info.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE groups_media (
            id TEXT PRIMARY KEY,
            groupId TEXT,
            url TEXT,
            type TEXT,
            timestamp INTEGER
          )
        ''');
      },
    );
  }

  // ═══════════════════════════════════════════════════════
  //  MEDIA CACHING
  // ═══════════════════════════════════════════════════════

  static Future<void> insertGroupMedia(GroupMediaModel media) async {
    try {
      final db = await database;
      await db.insert(
        'groups_media',
        media.toSqfliteMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      debugPrint('🔴 [GroupsInfoSqflite] insertGroupMedia err: $e');
    }
  }

  static Future<List<GroupMediaModel>> getGroupMedia(String groupId) async {
    try {
      final db = await database;
      final maps = await db.query(
        'groups_media',
        where: 'groupId = ?',
        whereArgs: [groupId],
        orderBy: 'timestamp DESC',
      );
      return maps.map((e) => GroupMediaModel.fromSqfliteMap(e)).toList();
    } catch (e) {
      debugPrint('🔴 [GroupsInfoSqflite] getGroupMedia err: $e');
      return [];
    }
  }

  static Future<void> clearAndInsertGroupMedia(
    String groupId,
    List<GroupMediaModel> mediaList,
  ) async {
    try {
      final db = await database;
      await db.transaction((txn) async {
        await txn.delete(
          'groups_media',
          where: 'groupId = ?',
          whereArgs: [groupId],
        );
        for (var media in mediaList) {
          await txn.insert(
            'groups_media', 
            media.toSqfliteMap(),
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
      });
    } catch (e) {
      debugPrint('🔴 [GroupsInfoSqflite] clearAndInsertGroupMedia err: $e');
    }
  }

  static Future<void> deleteMedia(String mediaId) async {
    try {
      final db = await database;
      await db.delete(
        'groups_media',
        where: 'id = ?',
        whereArgs: [mediaId],
      );
    } catch (e) {
      debugPrint('🔴 [GroupsInfoSqflite] deleteMedia err: $e');
    }
  }
}
