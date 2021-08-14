// To parse this JSON data, do
//
//     final nik = nikFromJson(jsonString);

import 'dart:convert';

List<Nik> nikFromJson(String str) =>
    List<Nik>.from(json.decode(str).map((x) => Nik.fromJson(x)));

String nikToJson(List<Nik> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Nik {
  Nik({
    this.nik,
    this.nama,
    this.tanggalahir,
    this.jeniskelamin,
    this.alamatNamajalan,
    this.alamatNorumah,
    this.alamatRt,
    this.alamatRw,
    this.alamatKelurahan,
    this.alamatKecamatan,
    this.alamatKabupaten,
    this.alamatPropinsi,
    this.nib,
    this.alamatusahaNamajalan,
    this.alamatusahaNorumah,
    this.alamatusahaRt,
    this.alamatusahaRw,
    this.alamatusahaKelurahan,
    this.alamatusahaKecamatan,
    this.alamatusahaKabupaten,
    this.alamatusahaPropinsi,
    this.kodepos,
    this.nomorhp,
    this.petugasEntry,
    this.waktuEntry,
    this.petugasSurvey,
    this.waktuSurvey,
    this.petugasScan,
    this.petugasSerahterima,
    this.waktuSerahterima,
    this.petugasBukti,
    this.kdsatker,
    this.jenisusaha,
    this.status,
  });

  String nik;
  String nama;
  DateTime tanggalahir;
  String jeniskelamin;
  String alamatNamajalan;
  int alamatNorumah;
  int alamatRt;
  int alamatRw;
  String alamatKelurahan;
  String alamatKecamatan;
  String alamatKabupaten;
  String alamatPropinsi;
  String nib;
  String alamatusahaNamajalan;
  int alamatusahaNorumah;
  int alamatusahaRt;
  int alamatusahaRw;
  String alamatusahaKelurahan;
  String alamatusahaKecamatan;
  String alamatusahaKabupaten;
  String alamatusahaPropinsi;
  String kodepos;
  String nomorhp;
  int petugasEntry;
  DateTime waktuEntry;
  int petugasSurvey;
  DateTime waktuSurvey;
  int petugasScan;
  int petugasSerahterima;
  DateTime waktuSerahterima;
  int petugasBukti;
  String kdsatker;
  String jenisusaha;
  int status;

  factory Nik.fromJson(Map<String, dynamic> json) => Nik(
        nik: json["NIK"],
        nama: json["NAMA"],
        tanggalahir: DateTime.parse(json["TANGGALAHIR"]),
        jeniskelamin: json["JENISKELAMIN"],
        alamatNamajalan: json["ALAMAT_NAMAJALAN"],
        alamatNorumah: json["ALAMAT_NORUMAH"],
        alamatRt: json["ALAMAT_RT"],
        alamatRw: json["ALAMAT_RW"],
        alamatKelurahan: json["ALAMAT_KELURAHAN"],
        alamatKecamatan: json["ALAMAT_KECAMATAN"],
        alamatKabupaten: json["ALAMAT_KABUPATEN"],
        alamatPropinsi: json["ALAMAT_PROPINSI"],
        nib: json["NIB"],
        alamatusahaNamajalan: json["ALAMATUSAHA_NAMAJALAN"],
        alamatusahaNorumah: json["ALAMATUSAHA_NORUMAH"],
        alamatusahaRt: json["ALAMATUSAHA_RT"],
        alamatusahaRw: json["ALAMATUSAHA_RW"],
        alamatusahaKelurahan: json["ALAMATUSAHA_KELURAHAN"],
        alamatusahaKecamatan: json["ALAMATUSAHA_KECAMATAN"],
        alamatusahaKabupaten: json["ALAMATUSAHA_KABUPATEN"],
        alamatusahaPropinsi: json["ALAMATUSAHA_PROPINSI"],
        kodepos: json["KODEPOS"],
        nomorhp: json["NOMORHP"],
        petugasEntry: json["PETUGAS_ENTRY"],
        waktuEntry: DateTime.parse(json["WAKTU_ENTRY"]),
        petugasSurvey: json["PETUGAS_SURVEY"],
        waktuSurvey: DateTime.parse(json["WAKTU_SURVEY"]),
        petugasScan: json["PETUGAS_SCAN"],
        petugasSerahterima: json["PETUGAS_SERAHTERIMA"],
        waktuSerahterima: DateTime.parse(json["WAKTU_SERAHTERIMA"]),
        petugasBukti: json["PETUGAS_BUKTI"],
        kdsatker: json["KDSATKER"],
        jenisusaha: json["JENISUSAHA"],
        status: json["STATUS"],
      );

  Map<String, dynamic> toJson() => {
        "NIK": nik,
        "NAMA": nama,
        "TANGGALAHIR":
            "${tanggalahir.year.toString().padLeft(4, '0')}-${tanggalahir.month.toString().padLeft(2, '0')}-${tanggalahir.day.toString().padLeft(2, '0')}",
        "JENISKELAMIN": jeniskelamin,
        "ALAMAT_NAMAJALAN": alamatNamajalan,
        "ALAMAT_NORUMAH": alamatNorumah,
        "ALAMAT_RT": alamatRt,
        "ALAMAT_RW": alamatRw,
        "ALAMAT_KELURAHAN": alamatKelurahan,
        "ALAMAT_KECAMATAN": alamatKecamatan,
        "ALAMAT_KABUPATEN": alamatKabupaten,
        "ALAMAT_PROPINSI": alamatPropinsi,
        "NIB": nib,
        "ALAMATUSAHA_NAMAJALAN": alamatusahaNamajalan,
        "ALAMATUSAHA_NORUMAH": alamatusahaNorumah,
        "ALAMATUSAHA_RT": alamatusahaRt,
        "ALAMATUSAHA_RW": alamatusahaRw,
        "ALAMATUSAHA_KELURAHAN": alamatusahaKelurahan,
        "ALAMATUSAHA_KECAMATAN": alamatusahaKecamatan,
        "ALAMATUSAHA_KABUPATEN": alamatusahaKabupaten,
        "ALAMATUSAHA_PROPINSI": alamatusahaPropinsi,
        "KODEPOS": kodepos,
        "NOMORHP": nomorhp,
        "PETUGAS_ENTRY": petugasEntry,
        "WAKTU_ENTRY":
            "${waktuEntry.year.toString().padLeft(4, '0')}-${waktuEntry.month.toString().padLeft(2, '0')}-${waktuEntry.day.toString().padLeft(2, '0')}",
        "PETUGAS_SURVEY": petugasSurvey,
        "WAKTU_SURVEY":
            "${waktuSurvey.year.toString().padLeft(4, '0')}-${waktuSurvey.month.toString().padLeft(2, '0')}-${waktuSurvey.day.toString().padLeft(2, '0')}",
        "PETUGAS_SCAN": petugasScan,
        "PETUGAS_SERAHTERIMA": petugasSerahterima,
        "WAKTU_SERAHTERIMA":
            "${waktuSerahterima.year.toString().padLeft(4, '0')}-${waktuSerahterima.month.toString().padLeft(2, '0')}-${waktuSerahterima.day.toString().padLeft(2, '0')}",
        "PETUGAS_BUKTI": petugasBukti,
        "KDSATKER": kdsatker,
        "JENISUSAHA": jenisusaha,
        "STATUS": status,
      };
}
