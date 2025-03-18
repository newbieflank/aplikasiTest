// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'minuman.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Minuman _$MinumanFromJson(Map<String, dynamic> json) => Minuman(
      id: json['id'] as int,
      nama: json['nama'] as String,
      deskripsi: json['deskripsi'] as String,
      harga: (json['harga'] as num).toDouble(),
      status: json['status'] as int,
    );

Map<String, dynamic> _$MinumanToJson(Minuman instance) => <String, dynamic>{
      'id': instance.id,
      'nama': instance.nama,
      'deskripsi': instance.deskripsi,
      'harga': instance.harga,
      'status': instance.status,
    };
