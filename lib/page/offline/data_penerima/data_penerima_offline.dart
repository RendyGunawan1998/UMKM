import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:puskeu/model/m_penerima_offline.dart';
import 'package:puskeu/model/profile_model.dart';
import 'package:puskeu/page/offline/data_penerima/foto_offline.dart';

class DataPenerimaOffline extends StatefulWidget {
  @override
  _DataPenerimaOfflineState createState() => _DataPenerimaOfflineState();
}

class _DataPenerimaOfflineState extends State<DataPenerimaOffline> {
  Future<Profile> futureProfile;

  TextEditingController _namaTxt = TextEditingController();
  TextEditingController _nikTxt = TextEditingController();
  TextEditingController _alamat = TextEditingController();
  TextEditingController _tglLahirTxt = TextEditingController();
  TextEditingController _tmptLahirTxt = TextEditingController();
  TextEditingController _telp = TextEditingController();
  TextEditingController _job = TextEditingController();
  final formkey = new GlobalKey<FormState>();
  List<List<dynamic>> rows = [];
  List<dynamic> row = [];
  //  {
  //       "nik": "nik",
  //         "nama": "14.97534313396318",
  //         "alamat": "101.22998536005622",
  //         "tglLahir": "101.22998536005622",
  //         "tmptLahir": "101.22998536005622",
  //         "telp": "101.22998536005622",
  //         "job": "101.22998536005622"
  //   }

  String validate(value) {
    if (value == null || value.isEmpty || value == "") {
      return "Field tidak boleh kosong";
    } else {
      return null;
    }
  }

  // saveToCSV() async {
  //   List<dynamic> row = [];
  //   row.add("nik");
  //   row.add("nama");
  //   row.add("alamat");
  //   row.add("tglLahir");
  //   row.add("tmptLahir");
  //   row.add("telp");
  //   row.add("job");
  //   rows.add(row);
  //   for (int i = 0; i < penerimaList.length; i++) {
  //     List<dynamic> row = [];
  //     row.add(penerimaList[i]["nik"]);
  //     row.add(penerimaList[i]["nama"]);
  //     row.add(penerimaList[i]["alamat"]);
  //     row.add(penerimaList[i]["tglLahir"]);
  //     row.add(penerimaList[i]["tmptLahir"]);
  //     row.add(penerimaList[i]["telp"]);
  //     row.add(penerimaList[i]["job"]);
  //     rows.add(row);
  //   }
  // }

// List jf = [{'id' : 1,'value' : "KTP"},]
  reset() {
    _nikTxt.clear();
    _namaTxt.clear();
    _alamat.clear();
    _tglLahirTxt.clear();
    _tmptLahirTxt.clear();
    _telp.clear();
    _job.clear();
  }

  @override
  void initState() {
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
      body: _buildBody(context),
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
      elevation: 0,
      title: Image.asset(
        "assets/images/presisi.png",
        width: 200,
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
        child: Container(
          height: Get.height,
          width: Get.width,
          child: Column(
            children: [
              _getFormField(),
              Align(
                alignment: FractionalOffset.bottomCenter,
                child: OutlinedButton(
                    onPressed: () async {
                      if (formkey.currentState.validate()) {
                        formkey.currentState.save();
                        print("NIK: ${_nikTxt.text}");
                        print("Nama: ${_namaTxt.text}");
                        print("Alamat: ${_alamat.text}");
                        print("Tgl Lahir: ${_tglLahirTxt.text}");
                        print("Tmpt Lahir: ${_tmptLahirTxt.text}");
                        print("Job: ${_job.text}");
                        print("telp: ${_telp.text}");

                        // row.add(_nikTxt.text);
                        // row.add(_namaTxt.text);
                        // row.add(_alamat.text);
                        // row.add(_tglLahirTxt.text);
                        // row.add(_tmptLahirTxt.text);
                        // row.add(_job.text);
                        // row.add(_telp.text);
                        // rows.add(row);
                        // reset();
                        print("ROWS : $rows");
                        print("validasi sukses");
                        Get.to(
                          () => FotoOffline(
                            nik: _nikTxt.text,
                            nama: _namaTxt.text,
                            tmpt: _tmptLahirTxt.text,
                            tgl: _tglLahirTxt.text,
                            alamat: _alamat.text,
                            telp: _telp.text,
                            kerja: _job.text,
                          ),
                        );
                      } else {
                        _showAlertfieldkosong(context);
                        print("unsuccess validate");
                      }
                    },
                    child: Text("Simpan Data")),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getFormField() {
    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      key: formkey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            keyboardType: TextInputType.number,
            scrollPadding: EdgeInsets.only(left: 10),
            decoration: InputDecoration(
              hintText: "NIK",
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
              print("NIK : ${_nikTxt.text}");
            },
          ),
          _hbox(7),
          _tff("Nama", _namaTxt, TextInputType.name),
          _hbox(7),
          _tff("Tempat Lahir", _tmptLahirTxt, TextInputType.name),
          _hbox(7),
          _tff2("Tanggal Lahir", "Cth : 01 Januari 2021", _tglLahirTxt,
              TextInputType.name),
          _hbox(7),
          _tff("Alamat", _alamat, TextInputType.streetAddress),
          _hbox(7),
          _tff("No  Telp", _telp, TextInputType.number),
          _hbox(7),
          _tff("Pekerjaan", _job, TextInputType.name),
        ],
      ),
    );
  }

  Widget _hbox(double h) {
    return SizedBox(
      height: h,
    );
  }

  Widget _tff(String hint, TextEditingController cont, TextInputType tipe) {
    return TextFormField(
      keyboardType: tipe,
      decoration: InputDecoration(
        hintText: hint,
        border: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      validator: validate,
      controller: cont,
      onSaved: (value) {
        cont.text = value;
        print("$hint : ${cont.text}");
      },
    );
  }

  Widget _tff2(String hint, String label, TextEditingController cont,
      TextInputType tipe) {
    return TextFormField(
      keyboardType: tipe,
      decoration: InputDecoration(
        hintText: hint,
        labelText: label,
        border: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      validator: validate,
      controller: cont,
      onSaved: (value) {
        cont.text = value;
        print("$hint : ${cont.text}");
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
}
