class User {
  final int id;
  final String email;
  final String password;
  final double saldo;

  User({
    required this.id,
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
      id: map['id'] != null ? int.tryParse(map['id'].toString()) ?? 0 : 0,
      email: map['email'] as String,
      password: map['password'] as String,
      saldo: map['saldo'] is double
          ? map['saldo'] as double
          : double.tryParse(map['saldo'].toString()) ?? 0.0,
    );
  }
}
