import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:chapa_tu_bus_app/subscriptions/infrastructure/models/subscription_model.dart';

class SubscriptionDataSourceDatabase {
  static final SubscriptionDataSourceDatabase _instance =
      SubscriptionDataSourceDatabase._internal();

  factory SubscriptionDataSourceDatabase() => _instance;

  static Database? _database;

  SubscriptionDataSourceDatabase._internal();

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final documentsDirectory =
        await getApplicationDocumentsDirectory(); // Ahora debería funcionar
    final path = join(documentsDirectory.path, 'app_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDb,
    );
  }

  FutureOr<void> _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE subscriptions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId TEXT NOT NULL,
        plan TEXT NOT NULL,
        startDate TEXT NOT NULL,
        endDate TEXT NOT NULL,
        isActive INTEGER NOT NULL
      )
    ''');
  }

  // CRUD Operations for Subscriptions
  Future<void> insertSubscription(Subscription subscription) async {
    final db = await database;
    await db.insert('subscriptions', subscription.toMap());
  }

  Future<List<Subscription>> getSubscriptions() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('subscriptions');
    return List.generate(maps.length, (i) {
      return Subscription.fromMap(maps[i]);
    });
  }

  Future<Subscription?> getSubscriptionByUserId(String userId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'subscriptions',
      where: 'userId = ?',
      whereArgs: [userId],
    );
    if (maps.isNotEmpty) {
      return Subscription.fromMap(maps.first);
    } else {
      return null;
    }
  }

}

