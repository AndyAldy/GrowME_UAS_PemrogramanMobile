import 'package:flutter/material.dart';
import '../models/model_user.dart';
import '../models/model_fund.dart';
import '../database/app_database.dart';
import '../widgets/fund_card.dart';

class HomeScreen extends StatefulWidget {
  final User user;

  const HomeScreen({Key? key, required this.user}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double saldo = 0;

final List<Map<String, dynamic>> funds = [
  {
    'nama': 'Reksa Dana Mandiri',
    'tipe': 'Pasar Uang',
    'untungrugi': 12.0,
    'image': 'assets/image/reksa1.png',
  },
  {
    'nama': 'Reksa Dana BCA',
    'tipe': 'Obligasi',
    'untungrugi': 5.2,
    'image': 'assets/image/reksa2.png',
  },
];


  @override
  void initState() {
    super.initState();
    _loadSaldo();
  }

  Future<void> _loadSaldo() async {
    final s = await AppDatabase.instance.getSaldo(widget.user.id!);
    setState(() {
      saldo = s;
    });
  }

  Future<void> _topUp() async {
    final newSaldo = saldo + 100000;
    await AppDatabase.instance.updateSaldo(widget.user.id!, newSaldo);
    await AppDatabase.instance.addTransaction(
      widget.user.id!,
      'topup',
      100000,
      DateTime.now().toIso8601String(),
    );
    _loadSaldo();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Top up berhasil +100000')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Beranda')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              color: Colors.green[50],
              child: ListTile(
                leading: Icon(Icons.account_balance_wallet, color: Colors.green),
                title: Text('Saldo Anda'),
                subtitle: Text('Rp${saldo.toStringAsFixed(0)}'),
                trailing: ElevatedButton(
                  onPressed: _topUp,
                  child: Text('Top Up'),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text('Reksa Dana Rekomendasi', style: TextStyle(fontSize: 18)),
            Expanded(
              child: ListView.builder(
  itemCount: funds.length,
  itemBuilder: (context, index) {
    final f = funds[index];
    return FundCard(
      userId: widget.user.id!,
      fund: Fund(
        nama: f['nama'],
        tipe: f['tipe'],
        untungrugi: f['untungrugi'],
        image: f['image'],
      ),
    );
  },
),

            ),
          ],
        ),
      ),
    );
  }
}
