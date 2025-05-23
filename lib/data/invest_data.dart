import '../models/model_fund.dart';

class InvestmentData {
  static List<Fund> investments = [];

  static double get totalInvested {
    return investments.length * 1000000;
  }

  static double get estimatedProfit {
    return investments.fold(0.0, (sum, item) {
      return sum + (1000000 * item.untungrugi / 100);
    });
  }

  static void addInvestment(Fund fund) {
    investments.add(fund);
  }
}
