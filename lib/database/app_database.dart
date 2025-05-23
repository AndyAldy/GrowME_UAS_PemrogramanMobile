import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class AppDatabase {
  static final AppDatabase instance = AppDatabase._init();

  static Database? _database;

  AppDatabase._init();

  Future<Database?> get database async {
    if (kIsWeb) {
      // Web: return null atau kamu bisa implement DB alternatif untuk web
      return null;
    }

    if (_database != null) return _database!;
    _database = await _initDB('GrowME.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final dbPath = join(documentsDirectory.path, filePath);
    return await openDatabase(dbPath, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const doubleType = 'REAL NOT NULL';

    await db.execute('''
    CREATE TABLE users (
      id $idType,
      email $textType,
      password $textType,
      saldo $doubleType
    )
    ''');

    await db.execute('''
    CREATE TABLE investments (
      id $idType,
      userId INTEGER NOT NULL,
      fundName $textType,
      fundType $textType,
      returnPercent $doubleType,
      amount $doubleType,
      FOREIGN KEY(userId) REFERENCES users(id)
    )
    ''');

    await db.execute('''
    CREATE TABLE transactions (
      id $idType,
      userId INTEGER NOT NULL,
      type $textType,
      amount $doubleType,
      timestamp $textType,
      FOREIGN KEY(userId) REFERENCES users(id)
    )
    ''');
  }

  Future close() async {
    if (kIsWeb) return;
    final db = await instance.database;
    db?.close();
  }

  // REGISTER USER
  Future<int?> registerUser(String email, String password) async {
    if (kIsWeb) return null; // fallback web

    final db = await instance.database;
    return await db!.insert('users', {
      'email': email,
      'password': password,
      'saldo': 0.0,
    });
  }

  // LOGIN USER
  Future<int?> loginUser(String email, String password) async {
    if (kIsWeb) return null;

    final db = await instance.database;
    final res = await db!.query('users',
        where: 'email = ? AND password = ?', whereArgs: [email, password]);
    if (res.isNotEmpty) {
      return res.first['id'] as int;
    }
    return null;
  }

  // GET SALDO USER BY userId
  Future<double> getSaldo(int userId) async {
    if (kIsWeb) return 0.0;

    final db = await instance.database;
    final res = await db!.query('users', columns: ['saldo'], where: 'id = ?', whereArgs: [userId]);
    if (res.isNotEmpty) {
      return res.first['saldo'] as double;
    }
    return 0.0;
  }

  // UPDATE SALDO USER BY userId
  Future<int?> updateSaldo(int userId, double newSaldo) async {
    if (kIsWeb) return null;

    final db = await instance.database;
    return await db!.update('users', {'saldo': newSaldo},
        where: 'id = ?', whereArgs: [userId]);
  }

  // TAMBAH INVESTASI
  Future<int?> addInvestment(int userId, String fundName, String fundType,
      double returnPercent, double amount) async {
    if (kIsWeb) return null;

    final db = await instance.database;
    return await db!.insert('investments', {
      'userId': userId,
      'fundName': fundName,
      'fundType': fundType,
      'returnPercent': returnPercent,
      'amount': amount,
    });
  }

  // AMBIL INVESTASI USER
  Future<List<Map<String, dynamic>>> getInvestments(int userId) async {
    if (kIsWeb) return [];

    final db = await instance.database;
    return await db!.query('investments', where: 'userId = ?', whereArgs: [userId]);
  }

  // TAMBAH TRANSAKSI
  Future<int?> addTransaction(
      int userId, String type, double amount, String timestamp) async {
    if (kIsWeb) return null;

    final db = await instance.database;
    return await db!.insert('transactions', {
      'userId': userId,
      'type': type,
      'amount': amount,
      'timestamp': timestamp,
    });
  }

  // AMBIL TRANSAKSI USER
  Future<List<Map<String, dynamic>>> getTransactions(int userId) async {
    if (kIsWeb) return [];

    final db = await instance.database;
    return await db!.query('transactions',
        where: 'userId = ?', whereArgs: [userId], orderBy: 'id DESC');
  }
}
