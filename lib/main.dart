import 'package:flutter/material.dart';
import 'package:growme/auth/login.dart';
import 'package:growme/auth/register.dart';
import 'Pages/menu_utama.dart';
import 'models/model_user.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(UserAdapter());
  await Hive.openBox<User>('users');

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
