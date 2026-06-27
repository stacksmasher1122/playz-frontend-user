import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'package:redesign/model/User_Models/Home_Models/Groups_Model/groups_model.dart';
import 'package:redesign/model/User_Models/Home_Models/Groups_Model/group_chat_model.dart';

class GroupsSqflite {
  static Database? _db;

  // ── Open / Create ──
  static Future<Database> get database async {
    if (_db != null) return _db!;
    final dbPath = await getDatabasesPath();
    _db = await openDatabase(
      p.join(dbPath, 'groups.db'),
      version: 3,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE groups (
            groupId TEXT PRIMARY KEY,
            name TEXT,
            description TEXT,
            sport TEXT,
            isPublic INTEGER DEFAULT 1,
            maxMembers INTEGER DEFAULT 25,
            imageUrl TEXT,
            creator TEXT,
            members TEXT,
            createdAt INTEGER,
            profanityModerationMembers INTEGER DEFAULT 0,
            profanityModerationAdmins INTEGER DEFAULT 0
          )
        ''');
        await db.execute('''
          CREATE TABLE group_chat_messages (
            id TEXT PRIMARY KEY,
            groupId TEXT,
            senderEmail TEXT,
            senderName TEXT,
            senderPic TEXT,
            type TEXT,
            content TEXT,
            timestamp TEXT,
            isRead INTEGER DEFAULT 0,
            replyToId TEXT,
            replyToContent TEXT,
            replyToSender TEXT,
            isEdited INTEGER DEFAULT 0,
            status TEXT DEFAULT 'sent'
          )
        ''');
        await db.execute(
            'CREATE INDEX idx_group_chat ON group_chat_messages(groupId, timestamp)');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('''
            CREATE TABLE IF NOT EXISTS group_chat_messages (
              id TEXT PRIMARY KEY,
              groupId TEXT,
              senderEmail TEXT,
              senderName TEXT,
              senderPic TEXT,
              type TEXT,
              content TEXT,
              timestamp TEXT,
              isRead INTEGER DEFAULT 0,
              replyToId TEXT,
              replyToContent TEXT,
              replyToSender TEXT,
              isEdited INTEGER DEFAULT 0
            )
          ''');
          await db.execute(
              'CREATE INDEX IF NOT EXISTS idx_group_chat ON group_chat_messages(groupId, timestamp)');
        }
        if (oldVersion < 3) {
          try {
            await db.execute('ALTER TABLE groups ADD COLUMN profanityModerationMembers INTEGER DEFAULT 0;');
            await db.execute('ALTER TABLE groups ADD COLUMN profanityModerationAdmins INTEGER DEFAULT 0;');
            await db.execute('ALTER TABLE group_chat_messages ADD COLUMN status TEXT DEFAULT \'sent\';');
          } catch (e) {
            // In case columns already exist or altering fails, ignore to prevent bricking
          }
        }
      },
    );
    return _db!;
  }

  // ═══════════════════════════════════
  //  GROUPS TABLE
  // ═══════════════════════════════════

  static Future<void> insertGroup(GroupModel group) async {
    final db = await database;
    await db.insert(
      'groups',
      group.toSqfliteMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<GroupModel>> getAllGroups() async {
    final db = await database;
    final maps = await db.query('groups', orderBy: 'createdAt DESC');
    return maps.map((m) => GroupModel.fromSqfliteMap(m)).toList();
  }

  static Future<GroupModel?> getGroupById(String groupId) async {
    final db = await database;
    final maps = await db.query(
      'groups',
      where: 'groupId = ?',
      whereArgs: [groupId],
    );
    if (maps.isEmpty) return null;
    return GroupModel.fromSqfliteMap(maps.first);
  }

  static Future<void> deleteGroup(String groupId) async {
    final db = await database;
    await db.delete('groups', where: 'groupId = ?', whereArgs: [groupId]);
  }

  static Future<void> clearAndInsertGroups(List<GroupModel> groups) async {
    final db = await database;
    final batch = db.batch();
    batch.delete('groups');
    for (final g in groups) {
      batch.insert('groups', g.toSqfliteMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit(noResult: true);
  }

  // ═══════════════════════════════════
  //  GROUP CHAT MESSAGES TABLE
  // ═══════════════════════════════════

  static Future<void> insertGroupMessage(GroupChatMessageModel msg) async {
    final db = await database;
    await db.insert(
      'group_chat_messages',
      msg.toSqfliteMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<GroupChatMessageModel>> getGroupMessages(
      String groupId) async {
    final db = await database;
    final maps = await db.query(
      'group_chat_messages',
      where: 'groupId = ?',
      whereArgs: [groupId],
      orderBy: 'timestamp ASC',
    );
    return maps.map((m) => GroupChatMessageModel.fromSqfliteMap(m)).toList();
  }

  static Future<void> clearAndInsertGroupMessages(
      String groupId, List<GroupChatMessageModel> messages) async {
    final db = await database;
    final batch = db.batch();
    batch.delete('group_chat_messages',
        where: 'groupId = ?', whereArgs: [groupId]);
    for (final m in messages) {
      batch.insert('group_chat_messages', m.toSqfliteMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit(noResult: true);
  }

  static Future<void> deleteGroupMessage(String messageId) async {
    final db = await database;
    await db.delete('group_chat_messages',
        where: 'id = ?', whereArgs: [messageId]);
  }

  static Future<void> deleteGroupMessagesByGroupId(String groupId) async {
    final db = await database;
    await db.delete('group_chat_messages',
        where: 'groupId = ?', whereArgs: [groupId]);
  }

  // ═══════════════════════════════════
  //  FLUSH ALL DATA (LOGOUT)
  // ═══════════════════════════════════

  static Future<void> clearAll() async {
    final db = await database;
    final batch = db.batch();
    batch.delete('groups');
    batch.delete('group_chat_messages');
    await batch.commit(noResult: true);
  }
}
