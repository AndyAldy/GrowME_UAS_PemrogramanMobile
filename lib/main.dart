  import 'package:flutter/material.dart';
  import 'auth/login.dart';
  import 'auth/register.dart';

  void main() {
    runApp(GrowMeApp());
  }

  class GrowMeApp extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
      return MaterialApp(
        title: 'GrowME',
        theme: ThemeData(primarySwatch: Colors.green),
        debugShowCheckedModeBanner: false,
        initialRoute: '/login',
        routes:{
          '/login' : (context) => const LoginPage(),
          '/register': (context) => RegisterPage(),
        }
      );
    }
  }
