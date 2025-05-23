import 'package:flutter/material.dart';
import '../database/app_database.dart';  // Panggil AppDatabase langsung

class RegisterPage extends StatefulWidget {
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final appDatabase = AppDatabase.instance; // Instance DB

  bool _loading = false;

  Future<void> _register() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (!email.contains('@') || password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Email tidak valid atau password kurang dari 6 karakter')),
      );
      return;
    }

    setState(() => _loading = true);

    try {
      print('Mulai cek email...');
      // Cek apakah email sudah ada dengan query users berdasar email
      final existingUsers = await appDatabase.database.then((db) async {
        if (db == null) return [];
        return await db.query(
          'users',
          where: 'email = ?',
          whereArgs: [email],
          limit: 1,
        );
      });

      print('Cek email selesai');

      if (existingUsers.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Email sudah terdaftar')),
        );
        setState(() => _loading = false);
        return;
      }

      // Insert user baru dengan saldo 500000 (sesuai permintaan)
      final insertedId = await appDatabase.registerUser(email, password);
      print('User baru dibuat dengan id: $insertedId');

      if (insertedId != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registrasi berhasil, silakan login')),
        );
        Navigator.pop(context);
      } else {
        throw Exception('Gagal membuat user baru');
      }
    } catch (e) {
      print('Error saat registrasi: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan saat registrasi')),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Daftar Akun')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            _loading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _register,
                    child: Text('Daftar'),
                  ),
          ],
        ),
      ),
    );
  }
}
