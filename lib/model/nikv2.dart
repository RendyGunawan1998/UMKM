// To parse this JSON data, do
//
//     final nikv2 = nikv2FromJson(jsonString);

import 'dart:convert';

List<Nikv2> nikv2FromJson(String str) => List<Nikv2>.from(json.decode(str).map((x) => Nikv2.fromJson(x)));

String nikv2ToJson(List<Nikv2> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Nikv2 {
  Nikv2({
    this.nik,
    this.nama,
  });

  String nik;
  String nama;

  factory Nikv2.fromJson(Map<String, dynamic> json) => Nikv2(
    nik: json["NIK"],
    nama: json["NAMA"],
  );

  Map<String, dynamic> toJson() => {
    "NIK": nik,
    "NAMA": nama,
  };
}
