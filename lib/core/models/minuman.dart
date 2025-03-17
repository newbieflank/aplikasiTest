import 'package:json_annotation/json_annotation.dart';

part 'minuman.g.dart';

@JsonSerializable()
class Minuman {
  String id;
  String nama;
  String deskripsi;
  double harga;
  bool status;
  Minuman({
    required this.id,
    required this.nama,
    required this.deskripsi,
    required this.harga,
    required this.status,
  });

  factory Minuman.fromJson(Map<String, dynamic> json) =>
      _$MinumanFromJson(json);

  Map<String, dynamic> toJson() => _$MinumanToJson(this);
}
