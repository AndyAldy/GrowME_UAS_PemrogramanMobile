import 'package:flutter/material.dart';
import 'package:growme/auth/login.dart';
import 'package:growme/auth/register.dart';
import 'Pages/menu_utama.dart';
import 'models/model_user.dart';

void main() {
  runApp(const GrowMeApp());
}

class GrowMeApp extends StatelessWidget {
  const GrowMeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GrowME',
      theme: ThemeData(primarySwatch: Colors.green),
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => RegisterPage(),
      },
      // Gunakan onGenerateRoute agar bisa oper data (User) secara dinamis
      onGenerateRoute: (settings) {
        if (settings.name == '/MainPage') {
          final user = settings.arguments as User;
          return MaterialPageRoute(
            builder: (context) => MainPage(user: user),
          );
        }
        return null;
      },
    );
  }
}
