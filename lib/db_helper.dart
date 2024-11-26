import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'game_levels.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE levels(
            id INTEGER PRIMARY KEY,
            mode TEXT,
            level INTEGER,
            status TEXT
          )
        ''');
      },
    );
  }

  Future<void> insertLevelStatus(String mode, int level, String status) async {
    final db = await database;
    await db.insert(
      'levels',
      {'mode': mode, 'level': level, 'status': status},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getLevelStatus(String mode) async {
    final db = await database;
    return await db.query(
      'levels',
      where: 'mode = ?',
      whereArgs: [mode],
    );
  }

  Future<void> clearData() async {
    final db = await database;
    await db.delete('levels');
  }
}
