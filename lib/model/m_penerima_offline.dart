class PenerimaOff {
  final String nik;
  final String nama;
  final String tmptLahir;
  final String tglLahir;
  final String alamat;
  final String telp;
  final String job;

  PenerimaOff(this.nik, this.nama, this.alamat, this.job, this.tmptLahir,
      this.tglLahir, this.telp);
}

// To parse this JSON data, do
//
//     final penerimaOffline = penerimaOfflineFromJson(jsonString);

// import 'dart:convert';

// PenerimaOffline penerimaOfflineFromJson(String str) =>
//     PenerimaOffline.fromJson(json.decode(str));

// String penerimaOfflineToJson(PenerimaOffline data) =>
//     json.encode(data.toJson());

// class PenerimaOffline {
//   PenerimaOffline({
//     this.results,
//   });

//   List<Result> results;

//   factory PenerimaOffline.fromJson(Map<String, dynamic> json) =>
//       PenerimaOffline(
//         results: json["results"] == null
//             ? null
//             : List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "results": results == null
//             ? null
//             : List<dynamic>.from(results.map((x) => x.toJson())),
//       };
// }

// class Result {
//   Result({
//     this.nik,
//     this.nama,
//     this.tmptLahir,
//     this.tglLahir,
//     this.alamat,
//     this.telp,
//     this.job,
//     this.created,
//     this.updated,
//   });

//   String nik;
//   String nama;
//   String tmptLahir;
//   String tglLahir;
//   String alamat;
//   String telp;
//   String job;
//   DateTime created;
//   DateTime updated;

//   factory Result.fromJson(Map<String, dynamic> json) => Result(
//         nik: json["NIK"] == null ? null : json["NIK"],
//         nama: json["Nama"] == null ? null : json["Nama"],
//         tmptLahir: json["TmptLahir"] == null ? null : json["TmptLahir"],
//         tglLahir: json["TglLahir"] == null ? null : json["TglLahir"],
//         alamat: json["Alamat"] == null ? null : json["Alamat"],
//         telp: json["Telp"] == null ? null : json["Telp"],
//         job: json["Job"] == null ? null : json["Job"],
//         created:
//             json["created"] == null ? null : DateTime.parse(json["created"]),
//         updated:
//             json["updated"] == null ? null : DateTime.parse(json["updated"]),
//       );

//   Map<String, dynamic> toJson() => {
//         "NIK": nik == null ? null : nik,
//         "Nama": nama == null ? null : nama,
//         "TmptLahir": tmptLahir == null ? null : tmptLahir,
//         "TglLahir": tglLahir == null ? null : tglLahir,
//         "Alamat": alamat == null ? null : alamat,
//         "Telp": telp == null ? null : telp,
//         "Job": job == null ? null : job,
//         "created": created == null ? null : created.toIso8601String(),
//         "updated": updated == null ? null : updated.toIso8601String(),
//       };
// }
