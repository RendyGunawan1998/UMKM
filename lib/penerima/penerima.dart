import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:puskeu/model/profile_model.dart';
import 'package:http/http.dart' as http;
import 'package:puskeu/model/save_token.dart';
import 'package:puskeu/penerima/foto_penerima.dart';

class PenerimaPage extends StatefulWidget {
  @override
  _PenerimaPageState createState() => _PenerimaPageState();
}

class _PenerimaPageState extends State<PenerimaPage> {
  Future<Profile> futureProfile;

  TextEditingController _namaTxt = TextEditingController();
  TextEditingController _nikTxt = TextEditingController();
  TextEditingController _tahunTxt = TextEditingController();
  TextEditingController _bulanTxt = TextEditingController();
  TextEditingController _tanggalTxt = TextEditingController();
  TextEditingController _ttlTxt = TextEditingController();
  TextEditingController _nibTxt = TextEditingController();
  TextEditingController _alamat = TextEditingController();
  TextEditingController _alamatUsaha = TextEditingController();
  TextEditingController _noHP = TextEditingController();
  TextEditingController _jenisUsaha = TextEditingController();
  TextEditingController _namaPetugas = TextEditingController();
  TextEditingController _noAnggota = TextEditingController();
  TextEditingController _noHPPetugas = TextEditingController();
  final formkey = new GlobalKey<FormState>();

  bool statusButton = false;

  String jkValue;
  String tampJK;
  String namaSatker;
  String nrpSatker;
  String noHpPetugas;

  String nikTamp = "";

  String currentDay;
  String currentBulan;
  String currentTahun;
  String waktu = "";

  List<String> jenisKelamin = <String>['Laki', 'Perempuan'];
  List years = ["2021"];

  String validateNIK(value) {
    if (value.isEmpty) {
      return "NIK tidak boleh kosong";
    } else if (value.length <= 16) {
      return "NIK tidak boleh kurang dari 16 angka";
    } else if (value.length >= 16) {
      return "NIK tidak boleh lebih dari 16 angka";
    } else {
      return null;
    }
  }

  String validateNama(value) {
    if (value.isEmpty) {
      return "Nama tidak boleh kosong";
    } else {
      return null;
    }
  }

  Future<Profile> getDataSatker() async {
    String url = 'https://app.puskeu.polri.go.id:2216/umkm/mobile/profil/';

    var response = await http.get(
      Uri.parse(url),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer" + await Token().getAccessToken(),
      },
    );
    //var toJson = jsonDecode(response.body);
    if (response.statusCode == 200) {
      print(response.body);
      return Profile.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load profile data');
    }
  }

  List<String> tanggal = <String>[
    '01',
    '02',
    '03',
    '04',
    '05',
    '06',
    '07',
    '08',
    '09',
    '10',
    '11',
    '12',
    '13',
    '14',
    '15',
    '16',
    '17',
    '18',
    '19',
    '20',
    '21',
    '22',
    '23',
    '24',
    '25',
    '26',
    '27',
    '28',
    '29',
    '30',
    '31',
  ];

  List<Map<String, dynamic>> dataBulan = [
    {"display": "Januari", "value": "01"},
    {"display": "Februari", "value": "02"},
    {"display": "Maret", "value": "03"},
    {"display": "April", "value": "04"},
    {"display": "Mei", "value": "05"},
    {"display": "Juni", "value": "06"},
    {"display": "Juli", "value": "07"},
    {"display": "Agustus", "value": "08"},
    {"display": "September", "value": "09"},
    {"display": "Oktober", "value": "10"},
    {"display": "November", "value": "11"},
    {"display": "Desember", "value": "12"},
  ];

  void now() {
    var timeNow = new DateTime.now();
    // final formatedDate = new DateFormat('yyyy-MM-dd');
    final time = DateFormat("yyyy-MM-dd").format(timeNow);
    waktu = time;
    print("Ini waktu sekarang : $time");
  }

  void getYears() {
    var now = new DateTime.now().year;
    List<int> abc = [];
    for (var i = 0; i <= 99; i++) {
      // print(year - i);
      abc.add(now - i);
    }

    years = abc.map((item) {
      return {
        "display": item.toString(),
        "value": item.toString(),
      };
    }).toList();
  }

  @override
  void initState() {
    futureProfile = getDataSatker();
    getYears();
    now();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppbar(),
      body: FutureBuilder<Profile>(
        future: futureProfile,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return _buildBody(snapshot.data);
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }

  Widget _buildAppbar() {
    return AppBar(
      flexibleSpace: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.brown[400], Colors.brown[200]])),
      ),
      // backgroundColor: Colors.blueGrey[200],
      elevation: 0,
      title: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Image.asset(
            "assets/images/presisi.png",
            width: 200,
          ),
        ],
      ),
    );
  }

  Widget _buildBody(Profile data) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
        child: _getFormField(data),
      ),
    );
  }

  Widget _getFormField(Profile data) {
    return Form(
      key: formkey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _getNik(),
          SizedBox(
            height: 7,
          ),
          _getNama(),
          SizedBox(
            height: 18,
          ),
          Text(
            "Tanggal Lahir",
            style: TextStyle(fontSize: 15),
          ),
          SizedBox(
            height: 5,
          ),
          _getTTL(),
          SizedBox(
            height: 7,
          ),
          _getJK(),
          SizedBox(
            height: 4,
          ),
          _getList("Alamat", "Masukkan alamat", _alamat),
          SizedBox(
            height: 7,
          ),
          _getList("NIB", "Masukkan NIB", _nibTxt),
          SizedBox(
            height: 7,
          ),
          _getList("Bidang Usaha", "Masukkan bidang usaha", _jenisUsaha),
          SizedBox(
            height: 7,
          ),
          _getList("Alamat Usaha", "Masukkan alamat usaha", _alamatUsaha),
          SizedBox(
            height: 7,
          ),
          _getNoHP(),
          SizedBox(
            height: 7,
          ),
          TextFormField(
            readOnly: true,
            decoration: InputDecoration(
                labelText: "Nama Petugas Pendata",
                hintText: "Klik Disini",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20))),
            keyboardType: TextInputType.number,
            controller: _namaPetugas,
            onTap: () {
              setState(() {
                namaSatker = data.nama;
                _namaPetugas.text = namaSatker;
              });
            },
            onSaved: (value) {
              _namaPetugas.text = value;
            },
          ),
          SizedBox(
            height: 7,
          ),
          TextFormField(
            readOnly: true,
            decoration: InputDecoration(
                labelText: "Nomor Anggota Petugas Pendata",
                hintText: "Klik Disini",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20))),
            keyboardType: TextInputType.number,
            controller: _noAnggota,
            onTap: () {
              setState(() {
                nrpSatker = data.nrp;
                _noAnggota.text = nrpSatker;
              });
            },
            onSaved: (value) {
              _noAnggota.text = value;
            },
          ),
          SizedBox(
            height: 7,
          ),
          TextFormField(
            onTap: () {
              setState(() {
                noHpPetugas = data.nomorhp;
                _noHPPetugas.text = noHpPetugas;
              });
            },
            readOnly: true,
            decoration: InputDecoration(
                labelText: "No HP Petugas Pendata",
                hintText: "Klik Disini",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20))),
            keyboardType: TextInputType.number,
            controller: _noHPPetugas,
            onSaved: (value) {
              _noHPPetugas.text = value;
            },
          ),
          SizedBox(
            height: 7,
          ),
          Center(
            child: OutlinedButton(
                onPressed: () async {
                  // Get.to(() => PhotoPage(nikScan));
                  if (formkey.currentState.validate()) {
                    formkey.currentState.save();
                    print("Ini Nik : ${_nikTxt.text}");
                    print("Ini nama : ${_namaTxt.text}");
                    _ttlTxt.text = _tahunTxt.text +
                        "-" +
                        _bulanTxt.text +
                        "-" +
                        _tanggalTxt.text;
                    print("Ini ttl : ${_ttlTxt.text}");
                    print("Ini tahun : ${_tahunTxt.text}");
                    print("Ini bulan : ${_bulanTxt.text}");
                    print("Ini tanggal : ${_tanggalTxt.text}");

                    tampJK = jkValue[0].toUpperCase();
                    print("Ini jenis kelamin : $tampJK");
                    print("Ini alamat : ${_alamat.text}");
                    print("Ini nib : ${_nibTxt.text}");
                    print("Ini jenis usaha : ${_jenisUsaha.text}");
                    print("Ini alamat usaha : ${_alamatUsaha.text}");
                    print("Ini no telp : ${_noHP.text}");
                    print("Ini nama sakter : ${_namaPetugas.text}");
                    print("Ini nama sakter : ${_noAnggota.text}");
                    print("Ini nama sakter : ${_noHPPetugas.text}");
                    now();
                    print("Ini tanggal masuk : $waktu");
                    print("Ini tampungan nik : $nikTamp");

                    print("validasi sukses");
                    var _body = {
                      'nik': _nikTxt.text,
                      'nama': _namaTxt.text,
                      'tanggal_lahir': _ttlTxt.text,
                      'jk': tampJK,
                      'alamat': _alamat.text,
                      'nib': _nibTxt.text,
                      'jenis_usaha': _jenisUsaha.text,
                      'alamat_usaha': _alamatUsaha.text,
                      'nomor_hp': _noHP.text,
                      'nama_petugas': _namaPetugas.text,
                      'nomor_anggota': _noAnggota.text,
                      'nomor_hape_petugas': _noHPPetugas.text,
                      'tanggal_masuk': waktu,
                    };
                    print("Ini Body " + json.encode(_body));
                    try {
                      var response = await http.post(
                        Uri.parse(
                            "https://app.puskeu.polri.go.id:2216/umkm/mobile/penerima/lampiran1/"),
                        body: json.encode(_body),
                        headers: {
                          "Accept": "application/json",
                          "Content-Type": "application/json",
                          "Authorization":
                              "Bearer " + await Token().getAccessToken(),
                        },
                      );
                      print(response.body);
                      if (response.statusCode == 200) {
                        // SharedPreferences prefs = await SharedPreferences.getInstance();
                        // prefs.setBool("isLoggedIn", true);
                        Token().saveToken(response.body);
                        print('Token : ' + response.body);
                        print("UPLOAD SUKSES");
                        setState(() {
                          nikTamp = _nikTxt.text;
                          statusButton = true;

                          print("Ini tampungan nik di response : $nikTamp");
                        });
                        print(response.body);
                        _showAlertDialogSuccess(context);
                        return response.body;
                        // Get.offAll(() => LoadingScreen());
                      } else {
                        setState(() {
                          statusButton = false;
                        });
                        _showAlertDialog(context);
                      }
                    } catch (e) {
                      print(e);
                    }
                  } else {
                    print("unsuccess validate");
                  }
                },
                child: Text("Upload data")),
          ),
          SizedBox(
            height: 10,
          ),
          statusButton == true
              ? Center(
                  child: OutlinedButton(
                      onPressed: () {
                        Get.to(() => PhotoPenerima(
                              nikBaru: nikTamp,
                            ));
                      },
                      child: Text("Upload Data Calon Penerima")),
                )
              : Container(),
        ],
      ),
    );
  }

  Widget _getNik() {
    return TextFormField(
      scrollPadding: EdgeInsets.only(left: 10),
      decoration: InputDecoration(
        labelText: "NIK",
        hintText: "Masukkan NIK",
        border: UnderlineInputBorder(borderRadius: BorderRadius.circular(5)),
      ),
      validator: (value) {
        if (value.isEmpty) {
          return "NIK tidak boleh kosong";
        } else if (value.length <= 15) {
          return "NIK tidak boleh kurang atau lebih dari 16 angka";
        } else {
          return null;
        }
      },
      controller: _nikTxt,
      onSaved: (value) {
        _nikTxt.text = value;
        nikTamp = _nikTxt.text;
      },
    );
  }

  Widget _getNama() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Nama",
        hintText: "Masukkan Nama",
        border: UnderlineInputBorder(borderRadius: BorderRadius.circular(5)),
      ),
      validator: (value) {
        if (value.isEmpty) {
          return "Nama tidak boleh kosong";
        } else {
          return null;
        }
      },
      // RequiredValidator(errorText: 'Nama tidak boleh kosong'),
      controller: _namaTxt,
      onSaved: (value) {
        _namaTxt.text = value;
      },
    );
  }

  Widget _getTTL() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 3,
          child: DropdownButton(
            hint: Text("Tanggal"),
            isExpanded: true,
            value: currentDay,
            iconSize: 25,
            // elevation: 16,
            onChanged: (value) {
              setState(() {
                currentDay = value;
                _tanggalTxt.text = currentDay;
                print(_tanggalTxt.text);
              });
            },
            items: tanggal.map(
              (item) {
                return DropdownMenuItem(
                  value: item,
                  child: new Text(item),
                );
              },
            ).toList(),
          ),
        ),
        // Expanded(
        //   child: TextFormField(
        //     decoration: InputDecoration(
        //       labelText: "Tanggal ",
        //       hintText: "Tanggal",
        //       border:
        //           OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
        //     ),
        //     controller: _tanggalTxt,
        //     onSaved: (value) {
        //       _namaTxt.text = value;
        //     },
        //   ),
        // ),
        Text(
          "-",
          style: TextStyle(color: Colors.black, fontSize: 40),
        ),
        Expanded(
          flex: 3,
          child: DropdownButton(
            dropdownColor: Colors.white,
            isExpanded: true,
            hint: Text('Bulan'),
            value: currentBulan,
            items: dataBulan.map((item) {
              return DropdownMenuItem(
                child: Text(item['display']),
                value: item['value'],
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                currentBulan = value;
                _bulanTxt.text = currentBulan;
                print(_bulanTxt.text);
              });
            },
          ),
        ),

        Text(
          "-",
          style: TextStyle(color: Colors.black, fontSize: 40),
        ),
        Expanded(
          flex: 3,
          child: DropdownButton(
            dropdownColor: Colors.white,
            isExpanded: true,
            hint: Text('Tahun'),
            value: currentTahun,
            items: years.map((item) {
              return DropdownMenuItem(
                child: Text(item['display']),
                value: item['value'],
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                currentTahun = value;
                _tahunTxt.text = currentTahun;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _getJK() {
    return ListView(
      shrinkWrap: true,
      children: [
        Row(
          children: [
            Expanded(
              flex: 3,
              child: Text(
                "Jenis Kelamin :",
                style: TextStyle(fontSize: 15),
              ),
            ),
            Expanded(
              flex: 7,
              child: DropdownButton(
                hint: Text("Jenis Kelamin"),
                isExpanded: true,
                value: jkValue,
                iconSize: 25,
                // elevation: 16,
                onChanged: (value) {
                  setState(() {
                    jkValue = value;
                  });
                },
                items: jenisKelamin.map(
                  (item) {
                    return DropdownMenuItem(
                      value: item,
                      child: new Text(item),
                    );
                  },
                ).toList(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _getList(
      String label, String hint, TextEditingController _controller) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: UnderlineInputBorder(borderRadius: BorderRadius.circular(5)),
      ),
      controller: _controller,
      onSaved: (value) {
        _controller.text = value;
      },
    );
  }

  Widget _getNoHP() {
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: "No Telp",
        hintText: "Masukkan No Telp",
        border: UnderlineInputBorder(borderRadius: BorderRadius.circular(5)),
      ),
      controller: _noHP,
      onSaved: (value) {
        _noHP.text = value;
      },
    );
  }
}

_showAlertDialog(BuildContext context) {
  Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pop(context);
      });
  AlertDialog alert = AlertDialog(
    title: Text("Gagal"),
    content: Text("Data tidak dapat di upload"),
    actions: [
      okButton,
    ],
  );
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

_showAlertDialogSuccess(BuildContext context) {
  Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pop(context);
      });
  AlertDialog alert = AlertDialog(
    title: Text("Sukses"),
    content: Text("Data berhasil di upload"),
    actions: [
      okButton,
    ],
  );
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
