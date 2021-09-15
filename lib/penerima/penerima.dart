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
  TextEditingController _jenisKelamin = TextEditingController();
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
  bool statusUpload = true;

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

  String validate(value) {
    if (value == null || value.isEmpty || value == "") {
      return "Field tidak boleh kosong";
    } else {
      return null;
    }
  }

  // Future<String> cekNik(String nik) async {
  //   String url =
  //       "https://app.puskeu.polri.go.id:2216/umkm/mobile/cek_nik/?nik=" + nik;
  //   print("ini url fungsi cek nik di pendataan : $url");
  //   var response = await http.post(
  //     Uri.parse(url),
  //     headers: {
  //       "Accept": "application/json",
  //       "Content-Type": "application/json",
  //       "Authorization": "Bearer " + await Token().getAccessToken(),
  //     },
  //   );
  //   var debugBearer = await Token().getAccessToken();
  //   print("ini debug fungsi cek nik $debugBearer");
  //   print(response.body);
  //   if (response.statusCode == 200) {
  //     print(response.body);
  //     return _showAlertTerdaftar(context);
  //   } else {
  //     return response.body;
  //   }
  // }

  Future<Profile> getDataSatker() async {
    String url = 'https://app.puskeu.polri.go.id:2216/umkm/mobile/profil/';
    print("ini url profile di pendataan : $url");

    var response = await http.get(
      Uri.parse(url),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer " + await Token().getAccessToken(),
      },
    );
    var debugBearer = await Token().getAccessToken();
    print(debugBearer);
    print(response.body);
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

  reset() {
    _nikTxt.clear();
    _namaTxt.clear();
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
    _namaPetugas.text = namaSatker;
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
      autovalidate: true,
      key: formkey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisAlignment: MainAxisAlignment.start,
        children: [
          TextFormField(
            onTap: () {
              setState(() {
                namaSatker = data.nama;
                noHpPetugas = data.nomorhp;
                nrpSatker = data.nrp;
                _namaPetugas.text = namaSatker;
                _noHPPetugas.text = noHpPetugas;
                _noAnggota.text = nrpSatker;
              });
            },
            keyboardType: TextInputType.number,
            scrollPadding: EdgeInsets.only(left: 10),
            decoration: InputDecoration(
              labelText: "NIK",
              hintText: "Masukkan NIK",
              border:
                  UnderlineInputBorder(borderRadius: BorderRadius.circular(5)),
            ),
            validator: (value) {
              if (value == null || value.isEmpty || value == "") {
                return "NIK tidak boleh kosong";
              } else if (value.length < 16) {
                return "NIK tidak boleh kurang dari 16 angka";
              } else if (value.length > 16) {
                return "NIK tidak boleh lebih dari 16 angka";
              } else {
                return null;
              }
            },
            controller: _nikTxt,
            onSaved: (value) {
              _nikTxt.text = value;
              nikTamp = _nikTxt.text;
            },
          ),
          SizedBox(
            height: 7,
          ),
          _getNama(),
          SizedBox(
            height: 18,
          ),
          Text(
            "Tempat Tanggal Lahir",
            style: TextStyle(fontSize: 15),
          ),
          SizedBox(
            height: 5,
          ),
          // _getTTL(),
          TextFormField(
            decoration: InputDecoration(
              labelText: "Kota, dd-mm-yyyy (Jakarta, 17-Agustus-1945)",
              hintText: "Masukkan TTL",
              border:
                  UnderlineInputBorder(borderRadius: BorderRadius.circular(5)),
            ),
            controller: _ttlTxt,
            onSaved: (value) {
              _ttlTxt.text = value;
            },
          ),
          SizedBox(
            height: 7,
          ),
          _getJK(),
          SizedBox(
            height: 4,
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: "Alamat",
              hintText: "Masukkan alamat",
              border:
                  UnderlineInputBorder(borderRadius: BorderRadius.circular(5)),
            ),
            validator: validate,
            controller: _alamat,
            onSaved: (value) {
              if (value == null || value.isEmpty || value == "") {
                _alamat.text = "-";
              } else
                _alamat.text = value;
            },
          ),
          SizedBox(
            height: 7,
          ),
          _getList("NIB", "Masukkan NIB", _nibTxt),
          SizedBox(
            height: 7,
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: "Bidang Usaha",
              hintText: "Masukkan bidang usaha",
              border:
                  UnderlineInputBorder(borderRadius: BorderRadius.circular(5)),
            ),
            validator: validate,
            controller: _jenisUsaha,
            onSaved: (value) {
              if (value == null || value.isEmpty || value == "") {
                _jenisUsaha.text = "-";
              } else
                _jenisUsaha.text = value;
            },
          ),
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
          SizedBox(
            height: 7,
          ),
          Center(
            child: OutlinedButton(
                onPressed: () async {
                  if (formkey.currentState.validate()) {
                    formkey.currentState.save();
                    print("Ini Nik : $_nikTxt");
                    print("Ini nama : $_namaTxt");

                    print("Ini ttl : $_ttlTxt");
                    print("Ini tahun : $_tahunTxt");
                    print("Ini bulan : $_bulanTxt");
                    print("Ini tanggal : $_tanggalTxt");

                    tampJK = _jenisKelamin.text[0].toUpperCase();
                    print("Ini jenis kelamin : $tampJK");
                    print("Ini alamat : $_alamat");
                    print("Ini nib : $_nibTxt");
                    print("Ini jenis usaha : $_jenisUsaha");
                    print("Ini alamat usaha : $_alamatUsaha");
                    print("Ini no telp : $_noHP");
                    print("Ini nama sakter : $_namaPetugas");
                    print("Ini no sakter : $_noAnggota");
                    print("Ini hp sakter : $_noHPPetugas");
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
                        // Token().saveToken(response.body);
                        print('Token : ' + response.body);
                        print("UPLOAD SUKSES");
                        setState(() {
                          nikTamp = _nikTxt.text;
                          statusButton = true;
                          statusUpload = false;
                          print("Ini tampungan nik di response : $nikTamp");
                        });
                        print(response.body);
                        _showAlertDialogSuccess(context);
                        return response.body;
                        // Get.offAll(() => LoadingScreen());
                      } else {
                        _showAlertDialog(context);
                      }
                    } catch (e) {
                      print(e);
                    }
                  } else {
                    _showAlertfieldkosong(context);
                    print("unsuccess validate");
                  }
                },
                child: Text("Simpan Data")),
          ),
        ],
      ),
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
        if (value == null || value.isEmpty || value == "") {
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
          child: DropdownButtonFormField(
            hint: Text("Tanggal"),
            isExpanded: true,
            value: currentDay,
            iconSize: 25,
            onChanged: (value) {
              setState(() {
                if (value == null || value.isEmpty || value == "") {
                  _tanggalTxt.text = "01";
                } else
                  currentDay = value;
                _tanggalTxt.text = currentDay;
                print(_tanggalTxt.text);
              });
            },
            onSaved: (value) {
              setState(() {
                if (value == null || value.isEmpty || value == "") {
                  _tanggalTxt.text = "01";
                } else
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
        Text(
          "-",
          style: TextStyle(color: Colors.black, fontSize: 40),
        ),
        Expanded(
          flex: 3,
          child: DropdownButtonFormField(
            dropdownColor: Colors.white,
            isExpanded: true,
            hint: Text('Bulan'),
            value: currentBulan,
            // validator: (value) {
            //   if (value == null || value.isEmpty || value == "") {
            //     return "Bulan kosong";
            //   } else {
            //     return null;
            //   }
            // },
            items: dataBulan.map((item) {
              return DropdownMenuItem(
                child: Text(item['display']),
                value: item['value'],
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                if (value == null || value.isEmpty || value == "") {
                  _bulanTxt.text = "01";
                } else
                  currentBulan = value;
                _bulanTxt.text = currentBulan;
                print("ini kondisi jika kosong : ${_bulanTxt.text}");
              });
            },
            onSaved: (value) {
              setState(() {
                if (value == null || value.isEmpty || value == "") {
                  _bulanTxt.text = "01";
                } else
                  currentBulan = value;
                _bulanTxt.text = currentBulan;
                print("ini kondisi jika kosong : ${_bulanTxt.text}");
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
          child: DropdownButtonFormField(
            dropdownColor: Colors.white,
            isExpanded: true,
            hint: Text('Tahun'),
            value: currentTahun,
            // validator: (value) {
            //   if (value == null || value.isEmpty || value == "") {
            //     return "Tahun kosong";
            //   } else {
            //     return null;
            //   }
            // },
            items: years.map((item) {
              return DropdownMenuItem(
                child: Text(item['display']),
                value: item['value'],
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                if (value == null || value.isEmpty || value == "") {
                  _tahunTxt.text = "2021";
                } else
                  currentTahun = value;
                _tahunTxt.text = currentTahun;
                print("ini kondisi jika kosong : ${_bulanTxt.text}");
              });
            },
            onSaved: (value) {
              setState(() {
                if (value == null || value.isEmpty || value == "") {
                  _tahunTxt.text = "2021";
                } else
                  currentTahun = value;
                _tahunTxt.text = currentTahun;
                print("ini kondisi jika kosong : ${_bulanTxt.text}");
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
              child: DropdownButtonFormField(
                hint: Text("Jenis Kelamin"),
                isExpanded: true,
                value: jkValue,
                iconSize: 25,
                // elevation: 16,
                // validator: validate,
                onChanged: (value) {
                  setState(() {
                    if (value == null || value.isEmpty || value == "") {
                      _jenisKelamin.text = "L";
                    } else
                      jkValue = value;
                    _jenisKelamin.text = jkValue;
                  });
                },
                onSaved: (value) {
                  setState(() {
                    if (value == null || value.isEmpty || value == "") {
                      _jenisKelamin.text = "L";
                    } else
                      jkValue = value;
                    _jenisKelamin.text = jkValue;
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
      // validator: validate,
      controller: _controller,
      onSaved: (value) {
        if (value == null || value.isEmpty || value == "") {
          _controller.text = "-";
        } else
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
      // validator: validate,
      controller: _noHP,
      onSaved: (value) {
        if (value == null || value.isEmpty || value == "") {
          _noHP.text = "-";
        } else
          _noHP.text = value;
      },
    );
  }

  _showAlertTerdaftar(BuildContext context) {
    Widget okButton = TextButton(
        child: Text("OK"),
        onPressed: () {
          reset();
          Navigator.pop(context);
          // Get.offAll(() => PenerimaPage());
        });
    AlertDialog alert = AlertDialog(
      title: Text("Perhatian"),
      content: Text("NIK sudah pernah terdaftar"),
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

  _showAlertDialog(BuildContext context) {
    Widget okButton = TextButton(
        child: Text("OK"),
        onPressed: () {
          Navigator.pop(context);
        });
    AlertDialog alert = AlertDialog(
      title: Text("Gagal"),
      content: Text("Upload data calon penerima gagal"),
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

  _showAlertfieldkosong(BuildContext context) {
    Widget okButton = TextButton(
        child: Text("OK"),
        onPressed: () {
          Navigator.pop(context);
        });
    AlertDialog alert = AlertDialog(
      title: Text("Gagal"),
      content: Text(
          "Masih ada kolom kosong\nCek lagi pada kolom NIK, Nama, Alamat, dan Bidang Usaha."),
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
          // Navigator.pop(context);
          Get.to(() => PhotoPenerima(
                nikBaru: nikTamp,
              ));
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
}
