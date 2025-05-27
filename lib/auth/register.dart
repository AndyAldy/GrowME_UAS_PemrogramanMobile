import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:growme/database/user_dao.dart';
import 'package:growme/models/model_user.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final userDao = UserDao();

  bool _loading = false;

Future<void> _register() async {
  final email = emailController.text.trim();
  final password = passwordController.text.trim();

  if (!email.contains('@') || password.length < 6) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Email tidak valid atau password kurang dari 6 karakter')),
    );
    return;
  }

  setState(() => _loading = true);

  try {
    final userBox = Hive.box<User>('users');
    final emailExists = userBox.values.any((user) => user.email == email);

    if (emailExists) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email sudah terdaftar')),
      );
      setState(() => _loading = false);
      return;
    }

    final newUser = User(
      id: DateTime.now().millisecondsSinceEpoch,
      email: email,
      password: password,
      saldo: 0.0,
    );

    await userDao.insertUser(newUser);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Registrasi berhasil, silakan login')),
    );

    // Pindah ke halaman login setelah registrasi sukses
    Navigator.pushReplacementNamed(context, '/login');
  } catch (e) {
    print('Error saat registrasi: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Terjadi kesalahan saat registrasi')),
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
      appBar: AppBar(title: const Text('Daftar Akun')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            _loading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _register,
                    child: const Text('Daftar'),
                  ),
          ],
        ),
      ),
    );
  }
}
