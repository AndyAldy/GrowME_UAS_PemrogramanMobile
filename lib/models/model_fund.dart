import 'package:hive/hive.dart';

part 'model_fund.g.dart'; // Akan di-generate otomatis

@HiveType(typeId: 0) // Gunakan typeId yang berbeda dari model_user (misalnya 0)
class Fund extends HiveObject {
  @HiveField(0)
  String nama;

  @HiveField(1)
  String tipe;

  @HiveField(2)
  double untungrugi;

  @HiveField(3)
  String image;

  Fund({
    required this.nama,
    required this.tipe,
    required this.untungrugi,
    required this.image,
  });
}
