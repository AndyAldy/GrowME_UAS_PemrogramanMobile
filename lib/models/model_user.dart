class User {
  final int? id;
  final String email;
  final String password;
  final double saldo;

  User({
    this.id,
    required this.email,
    required this.password,
    required this.saldo,
  });

  String get username => email.split('@')[0];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'password': password,
      'saldo': saldo,
    };
  }

  static User fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] is int ? map['id'] as int : int.tryParse(map['id'].toString()),
      email: map['email'] as String,
      password: map['password'] as String,
      saldo: map['saldo'] is double
          ? map['saldo'] as double
          : double.tryParse(map['saldo'].toString()) ?? 0.0,
    );
  }
}
