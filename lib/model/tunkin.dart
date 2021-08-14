import 'dart:convert';

List<Tunkin> tunkinFromJson(String str) =>
    List<Tunkin>.from(json.decode(str).map((x) => Tunkin.fromJson(x)));

String tunkinToJson(List<Tunkin> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Tunkin {
  Tunkin({
    this.tahun,
    this.bulan,
    this.nrp,
    this.pangkat,
    this.jabatan,
    this.klasjabatan,
    this.nilaitunkin,
    this.potongantunkin,
    this.pph21,
    this.bersih,
    this.nmsatker,
    this.nmuappaw,
    this.nmpeg,
  });

  int tahun;
  int bulan;
  String nrp;
  String pangkat;
  String jabatan;
  int klasjabatan;
  int nilaitunkin;
  int potongantunkin;
  double pph21;
  int bersih;
  String nmsatker;
  String nmuappaw;
  String nmpeg;

  factory Tunkin.fromJson(Map<String, dynamic> json) => Tunkin(
        tahun: json["TAHUN"],
        bulan: json["BULAN"],
        nrp: json["NRP"],
        pangkat: json["PANGKAT"],
        jabatan: json["JABATAN"],
        klasjabatan: json["KLASJABATAN"],
        nilaitunkin: json["NILAITUNKIN"],
        potongantunkin: json["POTONGANTUNKIN"],
        pph21: json["PPH21"],
        bersih: json["BERSIH"],
        nmsatker: json["NMSATKER"],
        nmuappaw: json["NMUAPPAW"],
        nmpeg: json["NMPEG"],
      );

  Map<String, dynamic> toJson() => {
        "TAHUN": tahun,
        "BULAN": bulan,
        "NRP": nrp,
        "PANGKAT": pangkat,
        "JABATAN": jabatan,
        "KLASJABATAN": klasjabatan,
        "NILAITUNKIN": nilaitunkin,
        "POTONGANTUNKIN": potongantunkin,
        "PPH21": pph21,
        "BERSIH": bersih,
        "NMSATKER": nmsatker,
        "NMUAPPAW": nmuappaw,
        "NMPEG": nmpeg,
      };
}
