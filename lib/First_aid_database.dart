import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:path/path.dart';

class FirstAidDatabase {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  static Future<Database> initDatabase() async {
    return openDatabase(
      'first_aid.db',
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE first_aid(id INTEGER PRIMARY KEY AUTOINCREMENT, info TEXT, name TEXT, url TEXT, steps TEXT)',
        );
      },
      version: 1,
    );
  }

  static Future<void> insertFirstAid(Map<String, dynamic> firstAid) async {
    final Database db = await database;
    await db.insert(
      'first_aid',
      firstAid,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> retrieveAllFirstAid() async {
    final Database db = await database;
    return db.query('first_aid');
  }

  static Future<void> deleteTable() async {
    final Database db = await database;
    await db.execute('DROP TABLE IF EXISTS first_aid');
    print("deleted successfully");
  }

  static Future<void> deleteDB() async {
    // Get the path to the database file
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'first_aid.db');

    // Delete the database file
    await deleteDatabase(path);
  }
}