// To parse this JSON data, do
//
//     final nikBaru = nikBaruFromJson(jsonString);

import 'dart:convert';

List<NikBaru> nikBaruFromJson(String str) =>
    List<NikBaru>.from(json.decode(str).map((x) => NikBaru.fromJson(x)));

String nikBaruToJson(List<NikBaru> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class NikBaru {
  NikBaru({
    this.nik,
    this.nama,
    this.tanggalahir,
    this.jeniskelamin,
    this.namajeniskelamin,
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
    this.noRekeningBank,
    this.namaBank,
    this.atasNama,
    this.cetakUndangan,
  });

  String nik;
  String nama;
  String tanggalahir;
  String jeniskelamin;
  String namajeniskelamin;
  String alamatNamajalan;
  String alamatNorumah;
  String alamatRt;
  String alamatRw;
  String alamatKelurahan;
  String alamatKecamatan;
  String alamatKabupaten;
  String alamatPropinsi;
  String nib;
  String alamatusahaNamajalan;
  String alamatusahaNorumah;
  String alamatusahaRt;
  String alamatusahaRw;
  String alamatusahaKelurahan;
  String alamatusahaKecamatan;
  String alamatusahaKabupaten;
  String alamatusahaPropinsi;
  String kodepos;
  String nomorhp;
  String petugasEntry;
  String waktuEntry;
  String petugasSurvey;
  String waktuSurvey;
  String petugasScan;
  String petugasSerahterima;
  String waktuSerahterima;
  String petugasBukti;
  String kdsatker;
  String jenisusaha;
  String status;
  String noRekeningBank;
  String namaBank;
  String atasNama;
  String cetakUndangan;

  factory NikBaru.fromJson(Map<String, dynamic> json) => NikBaru(
        nik: json["NIK"],
        nama: json["NAMA"],
        tanggalahir: json["TANGGALAHIR"],
        jeniskelamin: json["JENISKELAMIN"],
        namajeniskelamin: json["NAMAJENISKELAMIN"],
        alamatNamajalan: json["ALAMAT_NAMAJALAN"],
        alamatNorumah: json["ALAMAT_NORUMAH"].toString(),
        alamatRt: json["ALAMAT_RT"].toString(),
        alamatRw: json["ALAMAT_RW"].toString(),
        alamatKelurahan: json["ALAMAT_KELURAHAN"],
        alamatKecamatan: json["ALAMAT_KECAMATAN"],
        alamatKabupaten: json["ALAMAT_KABUPATEN"],
        alamatPropinsi: json["ALAMAT_PROPINSI"],
        nib: json["NIB"],
        alamatusahaNamajalan: json["ALAMATUSAHA_NAMAJALAN"],
        alamatusahaNorumah: json["ALAMATUSAHA_NORUMAH"].toString(),
        alamatusahaRt: json["ALAMATUSAHA_RT"].toString(),
        alamatusahaRw: json["ALAMATUSAHA_RW"].toString(),
        alamatusahaKelurahan: json["ALAMATUSAHA_KELURAHAN"],
        alamatusahaKecamatan: json["ALAMATUSAHA_KECAMATAN"],
        alamatusahaKabupaten: json["ALAMATUSAHA_KABUPATEN"],
        alamatusahaPropinsi: json["ALAMATUSAHA_PROPINSI"],
        kodepos: json["KODEPOS"],
        nomorhp: json["NOMORHP"],
        petugasEntry: json["PETUGAS_ENTRY"].toString(),
        waktuEntry: json["WAKTU_ENTRY"],
        petugasSurvey: json["PETUGAS_SURVEY"].toString(),
        waktuSurvey: json["WAKTU_SURVEY"],
        petugasScan: json["PETUGAS_SCAN"].toString(),
        petugasSerahterima: json["PETUGAS_SERAHTERIMA"].toString(),
        waktuSerahterima: json["WAKTU_SERAHTERIMA"],
        petugasBukti: json["PETUGAS_BUKTI"].toString(),
        kdsatker: json["KDSATKER"],
        jenisusaha: json["JENISUSAHA"],
        status: json["STATUS"].toString(),
        noRekeningBank: json["no_rekening_bank"],
        namaBank: json["nama_bank"],
        atasNama: json["atas_nama"],
        cetakUndangan: json["cetak_undangan"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "NIK": nik,
        "NAMA": nama,
        "TANGGALAHIR": tanggalahir,
        "JENISKELAMIN": jeniskelamin,
        "NAMAJENISKELAMIN": namajeniskelamin,
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
        "WAKTU_ENTRY": waktuEntry,
        "PETUGAS_SURVEY": petugasSurvey,
        "WAKTU_SURVEY": waktuSurvey,
        "PETUGAS_SCAN": petugasScan,
        "PETUGAS_SERAHTERIMA": petugasSerahterima,
        "WAKTU_SERAHTERIMA": waktuSerahterima,
        "PETUGAS_BUKTI": petugasBukti,
        "KDSATKER": kdsatker,
        "JENISUSAHA": jenisusaha,
        "STATUS": status,
        "no_rekening_bank": noRekeningBank,
        "nama_bank": namaBank,
        "atas_nama": atasNama,
        "cetak_undangan": cetakUndangan,
      };
}
