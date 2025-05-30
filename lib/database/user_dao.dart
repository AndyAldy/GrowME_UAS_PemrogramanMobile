import 'package:growme/database/app_database.dart';
import 'package:growme/models/model_user.dart';

class UserDao {
  final dbProvider = AppDatabase.instance;

Future<User?> loginUser(String email, String password) async {
  final db = await dbProvider.database;
  if (db == null) {
    print('DB belum tersedia saat login.');
    return null;
  }

  final maps = await db.query(
    'users',
    where: 'email = ? AND password = ?',
    whereArgs: [email, password],
    limit: 1,
  );

  print('Login result: $maps');

  if (maps.isNotEmpty) {
    return User.fromMap(maps.first);
  }
  return null;
}


  Future<int> insertUser(User user) async {
    final db = await dbProvider.database;
    return await db!.insert('users', user.toMap());
  }

  Future<int> updateUserSaldo(int userId, double newSaldo) async {
    final db = await dbProvider.database;
    return await db!.update(
      'users',
      {'saldo': newSaldo},
      where: 'id = ?',
      whereArgs: [userId],
    );
  }

  Future<int> deleteUser(int userId) async {
    final db = await dbProvider.database;
    return await db!.delete('users', where: 'id = ?', whereArgs: [userId]);
  }
}
