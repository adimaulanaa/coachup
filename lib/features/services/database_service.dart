
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart';

class DatabaseService {
// Singleton pattern
  static final DatabaseService _dBService = DatabaseService._internal();
  factory DatabaseService() => _dBService;
  DatabaseService._internal();
  final uuid = const Uuid();

  // Membuat ID unik
  String generateUniqueId() {
    return uuid.v4(); // Versi 4 adalah UUID berbasis random
  }

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    // Initialize the DB first time it is accessed
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();

    // Set the path to the database. Note: Using the `join` function from the
    // `path` package is best practice to ensure the path is correctly
    // constructed for each platform.
    final path = join(databasePath, 'coach_database.db');

    // Set the version. This executes the onCreate function and provides a
    // path to perform database upgrades and downgrades.
    return await openDatabase(
      path,
      onCreate: _onCreate,
      version: 1,
      onConfigure: (db) async => await db.execute('PRAGMA foreign_keys = ON'),
    );
  }

  // When the database is first created, create a table to store user
  // and a table to store users.
  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
      'CREATE TABLE students(_id TEXT PRIMARY KEY, name TEXT, class TEXT, gender TEXT, collage TEXT, tlpn TEXT, active TEXT, created_on TEXT, updated_on TEXT)',
    );
    await db.execute(
      'CREATE TABLE members(_id TEXT PRIMARY KEY, coach_id TEXT, student_id TEXT, name TEXT, class TEXT, ttd TEXT, created_on TEXT, updated_on TEXT)',
    );
    await db.execute(
      'CREATE TABLE coaches(_id TEXT PRIMARY KEY, name TEXT, topic TEXT, learning TEXT, date TEXT, time_start TEXT, time_finish TEXT, pic_name TEXT, pic_collage TEXT, members TEXT, activity TEXT, description TEXT, created_on TEXT, updated_on TEXT)',
    );
  }

}
