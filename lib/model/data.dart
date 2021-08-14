import 'dart:convert';

List<UserInfoData> userInfoDataFromJson(String str) => List<UserInfoData>.from(
    json.decode(str).map((x) => UserInfoData.fromJson(x)));

String userInfoDataToJson(List<UserInfoData> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserInfoData {
  UserInfoData({
    this.tahun,
    this.bulan,
    this.nrp,
    this.nmpeg,
    this.npwp,
    this.nmBank,
    this.rekening,
    this.gapok,
    this.tistri,
    this.tanak,
    this.tjupns,
    this.tstruktur,
    this.tfungsi,
    this.tpapua,
    this.tpolwan,
    this.tpencil,
    this.bulat,
    this.tberas,
    this.tpajak,
    this.tlauk,
    this.tbabin,
    this.tsandi,
    this.tbrevet,
    this.tkhusus,
    this.tbatas,
    this.potkelbtj,
    this.potpfk2,
    this.potpfk10,
    this.pph,
    this.iwp,
    this.bpjs,
    this.sewarmh,
    this.potkelbtj1,
    this.potlain,
    this.bersih,
    this.nmgol1,
    this.sebutjab,
    this.nmsatker,
    this.nmuappaw,
  });

  String tahun;
  String bulan;
  String nrp;
  String nmpeg;
  String npwp;
  String nmBank;
  String rekening;
  int gapok;
  int tistri;
  int tanak;
  int tjupns;
  int tstruktur;
  int tfungsi;
  int tpapua;
  int tpolwan;
  int tpencil;
  int bulat;
  int tberas;
  int tpajak;
  int tlauk;
  int tbabin;
  int tsandi;
  int tbrevet;
  int tkhusus;
  int tbatas;
  int potkelbtj;
  int potpfk2;
  int potpfk10;
  int pph;
  int iwp;
  int bpjs;
  int sewarmh;
  int potkelbtj1;
  int potlain;
  int bersih;
  String nmgol1;
  String sebutjab;
  String nmsatker;
  String nmuappaw;

  factory UserInfoData.fromJson(Map<String, dynamic> json) => UserInfoData(
        tahun: json["TAHUN"],
        bulan: json["BULAN"],
        nrp: json["NRP"],
        nmpeg: json["NMPEG"],
        npwp: json["NPWP"],
        nmBank: json["NM_BANK"],
        rekening: json["REKENING"],
        gapok: json["GAPOK"],
        tistri: json["TISTRI"],
        tanak: json["TANAK"],
        tjupns: json["TJUPNS"],
        tstruktur: json["TSTRUKTUR"],
        tfungsi: json["TFUNGSI"],
        tpapua: json["TPAPUA"],
        tpolwan: json["TPOLWAN"],
        tpencil: json["TPENCIL"],
        bulat: json["BULAT"],
        tberas: json["TBERAS"],
        tpajak: json["TPAJAK"],
        tlauk: json["TLAUK"],
        tbabin: json["TBABIN"],
        tsandi: json["TSANDI"],
        tbrevet: json["TBREVET"],
        tkhusus: json["TKHUSUS"],
        tbatas: json["TBATAS"],
        potkelbtj: json["POTKELBTJ"],
        potpfk2: json["POTPFK2"],
        potpfk10: json["POTPFK10"],
        pph: json["PPH"],
        iwp: json["IWP"],
        bpjs: json["BPJS"],
        sewarmh: json["SEWARMH"],
        potkelbtj1: json["POTKELBTJ1"],
        potlain: json["POTLAIN"],
        bersih: json["BERSIH"],
        nmgol1: json["NMGOL1"],
        sebutjab: json["SEBUTJAB"],
        nmsatker: json["NMSATKER"],
        nmuappaw: json["NMUAPPAW"],
      );

  Map<String, dynamic> toJson() => {
        "TAHUN": tahun,
        "BULAN": bulan,
        "NRP": nrp,
        "NMPEG": nmpeg,
        "NPWP": npwp,
        "NM_BANK": nmBank,
        "REKENING": rekening,
        "GAPOK": gapok,
        "TISTRI": tistri,
        "TANAK": tanak,
        "TJUPNS": tjupns,
        "TSTRUKTUR": tstruktur,
        "TFUNGSI": tfungsi,
        "TPAPUA": tpapua,
        "TPOLWAN": tpolwan,
        "TPENCIL": tpencil,
        "BULAT": bulat,
        "TBERAS": tberas,
        "TPAJAK": tpajak,
        "TLAUK": tlauk,
        "TBABIN": tbabin,
        "TSANDI": tsandi,
        "TBREVET": tbrevet,
        "TKHUSUS": tkhusus,
        "TBATAS": tbatas,
        "POTKELBTJ": potkelbtj,
        "POTPFK2": potpfk2,
        "POTPFK10": potpfk10,
        "PPH": pph,
        "IWP": iwp,
        "BPJS": bpjs,
        "SEWARMH": sewarmh,
        "POTKELBTJ1": potkelbtj1,
        "POTLAIN": potlain,
        "BERSIH": bersih,
        "NMGOL1": nmgol1,
        "SEBUTJAB": sebutjab,
        "NMSATKER": nmsatker,
        "NMUAPPAW": nmuappaw,
      };
}
