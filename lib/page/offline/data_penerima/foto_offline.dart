// import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';

class FotoOffline extends StatefulWidget {
  final String nik;
  final String nama;
  final String tmpt;
  final String tgl;
  final String alamat;
  final String telp;
  final String kerja;
  FotoOffline(
      {this.nik,
      this.nama,
      this.tmpt,
      this.tgl,
      this.alamat,
      this.telp,
      this.kerja});
  @override
  _FotoOfflineState createState() => _FotoOfflineState();
}

class _FotoOfflineState extends State<FotoOffline> {
  // ============================= Variabel ====================
  File _selectedImage;
  final selectedIndexes = [];

  final picker = ImagePicker();

  String nikTamp = "";

  var tnik = TextEditingController();
  var tnama = TextEditingController();
  var tTmpt = TextEditingController();
  var tTgl = TextEditingController();
  var tAlamat = TextEditingController();
  var tTelp = TextEditingController();
  var tKerja = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Location location = new Location();
  List jenisPhoto = [];

  String _mySelection;
  // ============================= Variabel ====================

  // ============================= Init ====================
  @override
  void initState() {
    tnik.text = widget.nik;
    tnama.text = widget.nama;
    tTmpt.text = widget.tmpt;
    tTgl.text = widget.tgl;
    tAlamat.text = widget.alamat;
    tTelp.text = widget.telp;
    tKerja.text = widget.kerja;
    super.initState();
  }

  reset() {
    setState(() {
      _selectedImage = null;
    });
  }

  Widget getImageWidget() {
    if (_selectedImage != null) {
      return Image.file(
        _selectedImage,
        width: 300,
        height: 300,
        fit: BoxFit.cover,
      );
    } else {
      return Image.asset(
        "assets/images/no_data.png",
        width: 100,
        height: 100,
        fit: BoxFit.cover,
      );
    }
  }

  getImage(ImageSource source) async {
    final image = await picker.getImage(
      source: ImageSource.camera,
      maxHeight: 800,
      maxWidth: 600,
      imageQuality: 96,
    );
    print('Original path: ${image.path}');
    String dir = path.dirname(image.path);
    String newPath = path.join(dir, 'case01wd03id01.jpg');
    print('NewPath: $newPath');

    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
        print("Byte : ${_selectedImage.lengthSync()}");
        saveFoto(newPath);
      });
    } else {
      print("Foto Kosong");
      // setState(() {
      //   _inProgress = false;
      // });
    }
  }

  // =============================Fungsi upload ============================
  // Future<String> addTreatment(String nik, String jenis, double latitude,
  //     double longitude, String photo) async {
  //   print("ini data di fungsi addTreadment");
  //   print(nik);
  //   print(jenis);
  //   print(latitude);
  //   print(longitude);
  //   print(photo);

  //   Map<String, String> headers = {
  //     "Accept": "application/json",
  //     "Content-Type": "application/json",
  //     "Authorization": "Bearer " + await Token().getAccessToken(),
  //   };

  //   print("ini data headers : $headers");
  //   var token = Token().getAccessToken();
  //   print("ini token di fungsi addTreadment: $token");

  //   var uri = Uri.parse(
  //       'https://app.puskeu.polri.go.id:2216/umkm/mobile/penerima-foto/');
  //   var request = new http.MultipartRequest("POST", uri);

  //   print("ini uri di fungsi addTreadment: $uri");
  //   print("ini req di fungsi addTreadment: $request");

  //   request.headers.addAll(headers);

  //   request.fields['NIK'] = nik;
  //   request.fields['KODEFOTO'] = jenis.toString();
  //   request.fields['LATITUDE'] = latitude.toString();
  //   request.fields['LONGITUDE'] = longitude.toString();

  //   if (photo != '') {
  //     var photoFile = await http.MultipartFile.fromPath("FOTO", photo);
  //     request.files.add(photoFile);
  //   }

  //   http.Response response =
  //       await http.Response.fromStream(await request.send());
  //   print("ini response : $response");
  //   print("ini response body : ${response.body}");
  //   if (response.statusCode == 200) {
  //     print(response.body);
  //     nikTamp = nik;
  //     _showAlertDialoSuccess(context, response.statusCode);
  //     return "Berhasil";
  //   } else {
  //     print(response.body);
  //     _showAlertFieldKosong(context);
  //     // _showAlertDialog(context, response.body);
  //     throw (json.decode(response.body));
  //   }
  // }
  // ============================= Function ====================

  // ============================= Body ====================
  @override
  Widget build(BuildContext context) {
    // print(_selectedImage?.lengthSync());
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.brown[400], Colors.brown[200]])),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
        title: Text(
          "Tambah Foto Data Calon Penerima",
          style: TextStyle(
            fontSize: 18,
          ),
        ),
      ),
      body: _buildBody(context),
      bottomNavigationBar: _mySelection != null && _selectedImage != null
          ? MaterialButton(
              color: Colors.blue[200],
              onPressed: () {
                print(tnik.text);
                print(tnama.text);
                print(tTmpt.text);
                print(tTgl.text);
                print(tAlamat.text);
                print(tTelp.text);
                print(tKerja.text);
                print(_mySelection);
                print(_selectedImage.path);

                // addTreatment(
                //     nikTXT.text,
                //     _mySelection,
                //     _locationData.latitude,
                //     _locationData.longitude,
                //     _selectedImage.path);
                // _selectedImage = null;
              },
              child: Text("Upload"),
            )
          : _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(15, 5, 15, 10),
      child: Container(
        height: Get.height,
        width: Get.width,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _hbox(100),
                tff(tnik),
                _hbox(10),
                tff(tnama),
                _hbox(10),
                tff(tTmpt),
                _hbox(10),
                tff(tTgl),
                _hbox(10),
                tff(tAlamat),
                _hbox(10),
                tff(tTelp),
                _hbox(10),
                tff(tKerja),
                _hbox(10),
                getImageWidget(),
                MaterialButton(
                  minWidth: 120,
                  onPressed: () {
                    getImage(ImageSource.camera);

                    print(_mySelection);
                    print(_selectedImage);
                  },
                  color: Colors.green,
                  child: Text("Ambil Foto"),
                ),
                MaterialButton(
                  minWidth: 120,
                  color: Colors.green,
                  child: Text("Hapus Foto"),
                  onPressed: () {
                    reset();
                  },
                ),
                // DropdownButton(
                //   dropdownColor: Colors.white,
                //   isExpanded: true,
                //   hint: Text('Jenis Foto'),
                //   value: _mySelection,
                //   items: jenisPhoto.map((item) {
                //     return DropdownMenuItem(
                //       enabled: item['STSFOTO'] == "1" ? false : true,
                //       child: Row(
                //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //         children: [
                //           Text(item['NAMAFOTO']),
                //           item["STSFOTO"] == "1"
                //               ? Icon(
                //                   Icons.check_circle,
                //                   color: Colors.green,
                //                 )
                //               : Container(),
                //         ],
                //       ),
                //       value: item['KODEFOTO'].toString(),
                //     );
                //   }).toList(),
                //   onChanged: (value) {
                //     setState(() {
                //       _mySelection = value;
                //       print(_mySelection);
                //     });
                //   },
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget tff(TextEditingController cont) {
    return TextFormField(
      readOnly: true,
      decoration: InputDecoration(
          // labelText: "NIK",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20))),
      keyboardType: TextInputType.number,
      controller: cont,
      onSaved: (value) {
        cont.text = value;
      },
    );
  }

  Widget _hbox(double h) {
    return SizedBox(
      height: h,
    );
  }

  saveFoto(path) async {
    final SharedPreferences savedImage = await SharedPreferences.getInstance();
    savedImage.setString("image_path", path);
  }
}
