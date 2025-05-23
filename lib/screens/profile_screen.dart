import 'package:flutter/material.dart';
import 'package:growme/models/model_user.dart';
import '../auth/login.dart';
import '../database/app_database.dart';

class ProfileScreen extends StatefulWidget {
  final User user;

  const ProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  double saldo = 0.0;

  @override
  void initState() {
    super.initState();
    _loadSaldo();
  }

  Future<void> _loadSaldo() async {
    final s = await AppDatabase.instance.getSaldo(widget.user.id!); // ✅ pakai id user
    setState(() {
      saldo = s;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profil")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Card(
              color: Colors.green[50],
              child: ListTile(
                leading: Icon(Icons.account_balance_wallet, color: Colors.green),
                title: Text("Saldo Anda"),
                subtitle: Text("Rp${saldo.toStringAsFixed(0)}"),
              ),
            ),
            SizedBox(height: 20),
            CircleAvatar(radius: 40, child: Icon(Icons.person, size: 40)),
            SizedBox(height: 10),
            Text(widget.user.username ?? "Nama Pengguna", style: TextStyle(fontSize: 18)),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => LoginPage()),
                );
              },
              child: Text("Logout"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
