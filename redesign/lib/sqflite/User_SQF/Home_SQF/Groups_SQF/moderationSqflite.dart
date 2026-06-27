import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

/// Local SQFlite queue for messages awaiting Groq moderation.
/// Messages are enqueued before the API call and dequeued after processing.
class ModerationSqflite {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    final dbPath = await getDatabasesPath();
    _db = await openDatabase(
      p.join(dbPath, 'moderation_queue.db'),
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE message_queue (
            id TEXT PRIMARY KEY,
            groupId TEXT,
            senderEmail TEXT,
            senderName TEXT,
            senderPic TEXT,
            type TEXT,
            content TEXT,
            status TEXT DEFAULT 'pending',
            replyToId TEXT,
            replyToContent TEXT,
            replyToSender TEXT,
            createdAt TEXT
          )
        ''');
        await db.execute(
            'CREATE INDEX idx_queue_group ON message_queue(groupId, status)');
      },
    );
    return _db!;
  }

  /// Insert a message into the moderation queue.
  static Future<void> enqueue({
    required String id,
    required String groupId,
    required String senderEmail,
    required String senderName,
    required String senderPic,
    required String content,
    String? replyToId,
    String? replyToContent,
    String? replyToSender,
  }) async {
    final db = await database;
    await db.insert(
      'message_queue',
      {
        'id': id,
        'groupId': groupId,
        'senderEmail': senderEmail,
        'senderName': senderName,
        'senderPic': senderPic,
        'type': 'text',
        'content': content,
        'status': 'pending',
        'replyToId': replyToId,
        'replyToContent': replyToContent,
        'replyToSender': replyToSender,
        'createdAt': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Remove a processed message from the queue.
  static Future<void> dequeue(String id) async {
    final db = await database;
    await db.delete('message_queue', where: 'id = ?', whereArgs: [id]);
  }

  /// Get all pending messages for a group.
  static Future<List<Map<String, dynamic>>> getPending(String groupId) async {
    final db = await database;
    return db.query(
      'message_queue',
      where: 'groupId = ? AND status = ?',
      whereArgs: [groupId, 'pending'],
      orderBy: 'createdAt ASC',
    );
  }

  /// Flush the entire queue (e.g. on logout).
  static Future<void> clearAll() async {
    final db = await database;
    await db.delete('message_queue');
  }
}
