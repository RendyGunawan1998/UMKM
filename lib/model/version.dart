// To parse this JSON data, do
//
//     final versionHp = versionHpFromJson(jsonString);

import 'dart:convert';

List<VersionHp> versionHpFromJson(String str) =>
    List<VersionHp>.from(json.decode(str).map((x) => VersionHp.fromJson(x)));

String versionHpToJson(List<VersionHp> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class VersionHp {
  VersionHp({
    this.version,
    this.urlDownload,
  });

  String version;
  String urlDownload;

  factory VersionHp.fromJson(Map<String, dynamic> json) => VersionHp(
        version: json["version"],
        urlDownload: json["url_download"],
      );

  Map<String, dynamic> toJson() => {
        "version": version,
        "url_download": urlDownload,
      };
}
