import 'package:hive/hive.dart';
import 'package:growme/models/model_user.dart';

class UserDao {
  final Box<User> userBox = Hive.box<User>('users');

  // Login user berdasarkan email dan password
  Future<User?> loginUser(String email, String password) async {
    try {
      return userBox.values.firstWhere(
        (user) => user.email == email && user.password == password,
        orElse: () => throw Exception('User tidak ditemukan'),
      );
    } catch (e) {
      print('Error saat login: $e');
      return null;
    }
  }

  // Insert user baru
  Future<void> insertUser(User user) async {
    await userBox.put(user.id, user);
  }

  // Update saldo user
  Future<void> updateUserSaldo(int userId, double newSaldo) async {
    final user = userBox.get(userId);
    if (user != null) {
      user.saldo = newSaldo;
      await user.save(); // simpan perubahan
    }
  }

  // Hapus user
  Future<void> deleteUser(int userId) async {
    await userBox.delete(userId);
  }
}
