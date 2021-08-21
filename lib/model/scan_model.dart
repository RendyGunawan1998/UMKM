// To parse this JSON data, do
//
//     final scan = scanFromJson(jsonString);

import 'dart:convert';

List<Scan> scanFromJson(String str) =>
    List<Scan>.from(json.decode(str).map((x) => Scan.fromJson(x)));

String scanToJson(List<Scan> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Scan {
  Scan({
    this.nik,
  });

  String nik;

  factory Scan.fromJson(Map<String, dynamic> json) => Scan(
        nik: json["NIK"],
      );

  Map<String, dynamic> toJson() => {
        "NIK": nik,
      };
}
