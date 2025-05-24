import 'package:flutter/material.dart';
import '../database/app_database.dart';

class PortofolioScreen extends StatefulWidget {
  final int userId;

  const PortofolioScreen({super.key, required this.userId});

  @override
  _PortofolioScreenState createState() => _PortofolioScreenState();
}

class _PortofolioScreenState extends State<PortofolioScreen> {
  double totalInvested = 0;
  double estimatedProfit = 0;

  @override
  void initState() {
    super.initState();
    _loadInvestments();
  }

  Future<void> _loadInvestments() async {
    final investments = await AppDatabase.instance.getInvestments(widget.userId);

    double total = 0;
    double profit = 0;

    for (var inv in investments) {
      final amount = inv['amount'] as double;
      final returnPercent = inv['returnPercent'] as double;
      total += amount;
      profit += amount * (returnPercent / 100);
    }

    setState(() {
      totalInvested = total;
      estimatedProfit = profit;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Portofolio")),
      body: Center(
        child: totalInvested == 0
            ? Text("Belum ada investasi", style: TextStyle(fontSize: 18))
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Total Investasi: Rp${totalInvested.toStringAsFixed(0)}',
                    style: TextStyle(fontSize: 22),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Estimasi Keuntungan: Rp${estimatedProfit.toStringAsFixed(0)}',
                    style: TextStyle(fontSize: 18, color: Colors.green),
                  ),
                ],
              ),
      ),
    );
  }
}
