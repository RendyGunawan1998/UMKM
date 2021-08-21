// To parse this JSON data, do
//
//     final profile = profileFromJson(jsonString);

import 'dart:convert';

List<Profile> profileFromJson(String str) =>
    List<Profile>.from(json.decode(str).map((x) => Profile.fromJson(x)));

String profileToJson(List<Profile> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Profile {
  Profile({
    this.nrp,
    this.nama,
    this.pangkat,
    this.kdsatker,
    this.nomorhp,
  });

  String nrp;
  String nama;
  String pangkat;
  String kdsatker;
  String nomorhp;

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        nrp: json["NRP"],
        nama: json["NAMA"],
        pangkat: json["PANGKAT"],
        kdsatker: json["KDSATKER"],
        nomorhp: json["NOMORHP"],
      );

  Map<String, dynamic> toJson() => {
        "NRP": nrp,
        "NAMA": nama,
        "PANGKAT": pangkat,
        "KDSATKER": kdsatker,
        "NOMORHP": nomorhp,
      };
}
