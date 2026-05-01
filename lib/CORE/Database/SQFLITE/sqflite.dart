// ignore_for_file: non_constant_identifier_names, constant_identifier_names

import 'package:fatej/MODEL/song_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHome {
  final String DATABASE_NAME = 'song.db';
  final String TABLE = 'songlist';

  DatabaseHome._init(); //Private named Constructor
  static final DatabaseHome instance =
      DatabaseHome._init(); //Access via the Constructor

  Database? _database;

  //Initialize Database
  Future<Database> _init(String databaseName) async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, databaseName);
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  //Create Database Query
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''CREATE TABLE $TABLE (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT,
    songSource TEXT,
    image TEXT
    )''');
  }

  //Get actual Database
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _init(DATABASE_NAME);
    return _database!;
  }

  //Get all Data/Info through Query
  Future<List<SongModel>> obtainSong() async {
    final db = await database;
    final getQuery = await db.query(TABLE);
    return getQuery.map((state) => SongModel.toDart(state)).toList();
  }

  //Update Image
  Future<int> updateImage(int id, String image) async {
    final db = await database;
    return await db.update(
      TABLE,
      {'image': image},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  //Insert
  Future<int> insert(SongModel song) async {
    final db = await database;
    return await db.insert(TABLE, song.toMap());
  }

  //Delete
  Future<int> delete(int id) async {
    final db = await database;
    return await db.delete(TABLE, where: 'id = ?', whereArgs: [id]);
  }

  //Close
  Future<void> close() async {
    final db = await database;
    await db.close();
  }

  //Reset
  Future<void> reset() async {
    final existingDatabase = await getDatabasesPath();
    final path = join(existingDatabase, DATABASE_NAME);
    if (_database != null) {
      await close();
      _database = null;
    }

    await deleteDatabase(path);
    _database = await _init(DATABASE_NAME);
  }
}
