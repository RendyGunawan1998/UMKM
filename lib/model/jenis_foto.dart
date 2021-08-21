// To parse this JSON data, do
//
//     final jenisFoto = jenisFotoFromJson(jsonString);

import 'dart:convert';

List<JenisFoto> jenisFotoFromJson(String str) =>
    List<JenisFoto>.from(json.decode(str).map((x) => JenisFoto.fromJson(x)));

String jenisFotoToJson(List<JenisFoto> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class JenisFoto {
  JenisFoto({
    this.kodefoto,
    this.namafoto,
    this.isMust,
  });

  int kodefoto;
  String namafoto;
  int isMust;

  factory JenisFoto.fromJson(Map<String, dynamic> json) => JenisFoto(
        kodefoto: json["KODEFOTO"],
        namafoto: json["NAMAFOTO"],
        isMust: json["IS_MUST"],
      );

  Map<String, dynamic> toJson() => {
        "KODEFOTO": kodefoto,
        "NAMAFOTO": namafoto,
        "IS_MUST": isMust,
      };
}
