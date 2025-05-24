import 'package:flutter/material.dart';
import '../models/model_fund.dart';
import '../database/app_database.dart';
import 'package:intl/intl.dart';

class FundCard extends StatelessWidget {
  final int userId;
  final Fund fund;

  const FundCard({super.key, 
    required this.userId,
    required this.fund,
  });

  @override
  Widget build(BuildContext context) {
    const double purchaseAmount = 100000;

    return Card(
      margin: EdgeInsets.all(10),
      child: ListTile(
        leading: Image.asset(fund.image, width: 40, height: 40), // tampilkan gambar
        title: Text(fund.nama),
        subtitle: Text('${fund.tipe} • Return ${fund.untungrugi}%'),
        trailing: ElevatedButton(
          child: Text('Beli'),
          onPressed: () async {
    final currentSaldo = await AppDatabase.instance.getSaldo(userId);
    if (currentSaldo < 1000000) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Saldo tidak cukup untuk investasi')),
      );
      return;
    }
    // Deduct saldo
    final newSaldo = currentSaldo - 1000000;
    await AppDatabase.instance.updateSaldo(userId, newSaldo);

    // Add investment
    await AppDatabase.instance.addInvestment(
      userId,
      fund.nama,
      fund.tipe,
      fund.untungrugi,
      1000000,
    );

    // Add transaction
    await AppDatabase.instance.addTransaction(
      userId,
      'buy',
      1000000,
      DateTime.now().toIso8601String(),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Investasi berhasil')),
    );
          },
        ),
      ),
    );
  }
}
