class UserBalance {
  static double _balance = 500000; // saldo awal Rp500.000

  static double get balance => _balance;

  static void topUp(double amount) {
    _balance += amount;
  }

  static void spend(double amount) {
    if (_balance >= amount) {
      _balance -= amount;
    }
  }
}
