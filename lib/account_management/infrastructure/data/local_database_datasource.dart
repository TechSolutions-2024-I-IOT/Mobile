import 'package:chapa_tu_bus_app/account_management/infrastructure/models/firebase/user_model_firebase.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:chapa_tu_bus_app/account_management/infrastructure/models/backend/user_model_backend.dart';

class LocalDatabaseDatasource {
  static const _databaseName = 'account_management.db';
  static const _databaseVersion = 1;
  static const _tableName = 'users';
  static const _tokenTableName = 'tokens';

  LocalDatabaseDatasource._privateConstructor();
  static final LocalDatabaseDatasource instance =
      LocalDatabaseDatasource._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $_tableName (
            id TEXT PRIMARY KEY,
            firstName TEXT,
            lastName TEXT,
            name TEXT,
            email TEXT NOT NULL,
            photoURL TEXT,
            role TEXT,
            password TEXT
          )
        ''');
    await db.execute('''
          CREATE TABLE $_tokenTableName (
            token TEXT PRIMARY KEY
          )
        ''');
  }

  // CRUD operations for User
  Future<int> insertUser(UserModelBackend user) async {
    final db = await database;
    return await db.insert(_tableName, user.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> insertUserFirebase(UserModelFirebase user) async {
    final db = await database;
    return await db.insert(_tableName, user.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<UserModelBackend?> getUserById(String id) async {
    final db = await database;
    final maps = await db.query(_tableName, where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return UserModelBackend.fromJson(maps.first);
    } else {
      return null;
    }
  }

  Future<UserModelFirebase?> getUserByIdFirebase(String id) async {
    final db = await database;
    final maps = await db.query(_tableName, where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return UserModelFirebase.fromJson(maps.first);
    } else {
      return null;
    }
  }

  Future<String?> getUserId() async {
    final db = await database;
    final maps = await db.query(_tableName);
    if (maps.isNotEmpty) {
      return maps.first['id'] as String?;
    } else {
      return null;
    }
  }

  Future<int> deleteUser(String id) async {
    final db = await database;
    return await db.delete(_tableName);
  }

  // CRUD operations for Token
  Future<void> saveToken(String token) async {
    final db = await database;
    await db.delete(_tokenTableName); // Delete existing token if any
    await db.insert(_tokenTableName, {'token': token});
  }

  Future<String?> getToken() async {
    final db = await database;
    final maps = await db.query(_tokenTableName);
    if (maps.isNotEmpty) {
      return maps.first['token'] as String?;
    } else {
      return null;
    }
  }

  Future<void> deleteToken() async {
    final db = await database;
    await db.delete(_tokenTableName);
  }

  Future<void> dropDatabase() async {
    final db = await database;
    await db.delete(_tableName);
    await db.delete(_tokenTableName);
  }

  // Optional: Update User
  Future<int> updateUser(UserModelBackend user) async {
    final db = await database;
    return await db.update(_tableName, user.toJson(),
        where: 'id = ?', whereArgs: [user.id]);
  }

  Future<int> updateUserFirebase(UserModelFirebase user) async {
    final db = await database;
    return await db.update(_tableName, user.toJson(),
        where: 'id = ?', whereArgs: [user.id]);
  }

  // Optional: Get All Users
  Future<List<UserModelBackend>> getAllUsers() async {
    final db = await database;
    final maps = await db.query(_tableName);
    return List.generate(maps.length, (i) {
      return UserModelBackend.fromJson(maps[i]);
    });
  }
}
