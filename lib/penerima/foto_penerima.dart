import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:puskeu/extra_screen/curve_bar.dart';
import 'package:puskeu/model/save_token.dart';

class PhotoPenerima extends StatefulWidget {
  final String nikBaru;
  PhotoPenerima({this.nikBaru});
  @override
  _PhotoPenerimaState createState() => _PhotoPenerimaState();
}

class _PhotoPenerimaState extends State<PhotoPenerima> {
  // ============================= Variabel ====================
  File _selectedImage;
  bool _inProgress = false;
  final selectedIndexes = [];

  String nikTamp = "";

  var nikTXT = TextEditingController();
  var jenis = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Location location = new Location();
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;
  List jenisPhoto = [];

  String _mySelection;
  // ============================= Variabel ====================

  // ============================= Init ====================
  @override
  void initState() {
    nikTXT.text = widget.nikBaru;
    print("ini nik di fungsi foto penerima : ${nikTXT.text}");
    getJenisPhoto(widget.nikBaru);
    super.initState();
  }

  void getJenisPhoto(String nik) async {
    try {
      await _getJenisPhoto(widget.nikBaru);
    } catch (e) {
      print(e);
    }
  }

  reset() {
    setState(() {
      _selectedImage = null;
    });
  }
  // ============================= Init ====================

  // ============================= Function ====================

  Future<String> _getJenisPhoto(String nik) async {
    print("ini nik di getJenisPhoto $nik");
    String url =
        'https://app.puskeu.polri.go.id:2216/umkm/mobile/jenis-foto/' + nik;
    print(url);

    var response = await http.get(
      Uri.parse(url),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        // HttpHeaders.authorizationHeader:
        //     "Bearer " + await Token().getAccessToken(),
        "Authorization": "Bearer " + await Token().getAccessToken(),
      },
    );
    print(response.body);
    if (response.statusCode == 200) {
      print(response.body);
      var responeBody = jsonDecode(response.body);

      setState(() {
        jenisPhoto = responeBody;
      });

      return "Get Jenis Foto Success";
    } else {
      throw Exception('Failed to load profile data');
    }
  }

  _getLocation() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (_serviceEnabled) return;
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) return;
    }
    _locationData = await location.getLocation();
    // setState(() {
    //   _isGetLocation = true;
    // });
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
    setState(() {
      _inProgress = true;
    });
    File image = await ImagePicker.pickImage(source: source);
    if (image != null) {
      File cropped = await ImageCropper.cropImage(
        sourcePath: image.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 100,
        maxHeight: 1920,
        maxWidth: 1080,
        compressFormat: ImageCompressFormat.jpg,
        androidUiSettings: AndroidUiSettings(
            toolbarColor: Colors.deepOrange.shade900,
            statusBarColor: Colors.deepOrange.shade900,
            backgroundColor: Colors.white,
            // hideBottomControls: true,
            toolbarTitle: "Cropper"),
      );
      this.setState(() {
        _selectedImage = cropped;
        _inProgress = false;
      });
      _selectedImage.path;
    } else {
      setState(() {
        _inProgress = false;
      });
    }
  }

  // =============================Fungsi upload ============================
  Future<String> addTreatment(String nik, String jenis, double latitude,
      double longitude, String photo) async {
    print("ini data di fungsi addTreadment");
    print(nik);
    print(jenis);
    print(latitude);
    print(longitude);
    print(photo);

    Map<String, String> headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": "Bearer " + await Token().getAccessToken(),
    };

    print("ini data headers : $headers");
    var token = Token().getAccessToken();
    print("ini token di fungsi addTreadment: $token");

    var uri = Uri.parse(
        'https://app.puskeu.polri.go.id:2216/umkm/mobile/penerima-foto/');
    var request = new http.MultipartRequest("POST", uri);

    print("ini uri di fungsi addTreadment: $uri");
    print("ini req di fungsi addTreadment: $request");

    request.headers.addAll(headers);

    request.fields['NIK'] = nik;
    request.fields['KODEFOTO'] = jenis.toString();
    request.fields['LATITUDE'] = latitude.toString();
    request.fields['LONGITUDE'] = longitude.toString();

    if (photo != '') {
      var photoFile = await http.MultipartFile.fromPath("FOTO", photo);
      request.files.add(photoFile);
    }

    http.Response response =
        await http.Response.fromStream(await request.send());
    print("ini response : $response");
    print("ini response body : ${response.body}");
    if (response.statusCode == 200) {
      print(response.body);
      setState(() {
        nikTamp = nik;
      });
      _showAlertDialoSuccess(context, response.statusCode);
      return "Berhasil";
    } else {
      print(response.body);
      _showAlertFieldKosong(context);
      // _showAlertDialog(context, response.body);
      throw (json.decode(response.body));
    }
  }
  // ============================= Function ====================

  // ============================= Body ====================
  @override
  Widget build(BuildContext context) {
    print(_selectedImage?.lengthSync());
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Get.offAll(() => CurveBar());
            },
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.brown[400], Colors.brown[200]])),
          ),
          // backgroundColor: Colors.blueGrey[200],
          elevation: 0,
          title: Row(
            children: <Widget>[
              Text("Upload Data Calon Penerima"),
            ],
          ),
        ),
        bottomNavigationBar: _mySelection != null && _selectedImage != null
            ? MaterialButton(
                color: Colors.blue[200],
                onPressed: () {
                  print(nikTXT.text);
                  print(_mySelection);
                  print(_locationData.longitude);
                  print(_locationData.latitude);
                  print(_selectedImage.path);
                  setState(() {
                    nikTamp = nikTXT.text;
                  });
                  addTreatment(
                      nikTXT.text,
                      _mySelection,
                      _locationData.latitude,
                      _locationData.longitude,
                      _selectedImage.path);
                },
                child: Text("Upload"),
              )
            : _buildBody(context),
        body: _buildBody(context));
  }

  Widget _buildBody(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              getImageWidget(),
              MaterialButton(
                minWidth: 120,
                onPressed: () {
                  getImage(ImageSource.camera);
                  _getLocation();
                  print("Ini print di fungsi ambil foto");
                  print(nikTXT.text);
                  print(_mySelection);
                  print(_locationData.longitude);
                  print(_locationData.latitude);
                  print(_selectedImage.path);
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
              TextFormField(
                readOnly: true,
                decoration: InputDecoration(
                    labelText: "NIK",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))),
                keyboardType: TextInputType.number,
                validator: RequiredValidator(errorText: 'NIK required'),
                controller: nikTXT,
                onSaved: (value) {
                  nikTXT.text = value;
                  nikTamp = nikTXT.text;
                },
              ),
              DropdownButton(
                dropdownColor: Colors.white,
                isExpanded: true,
                hint: Text('Jenis Foto'),
                value: _mySelection,
                items: jenisPhoto.map((item) {
                  return DropdownMenuItem(
                      enabled: item['STSFOTO'] == "1" ? false : true,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(item['NAMAFOTO']),
                          item["STSFOTO"] == "1"
                              ? Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                )
                              : Container(),
                        ],
                      ),
                      value: item['KODEFOTO'].toString());
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _mySelection = value;
                    print(_mySelection);
                    print("ini value jenis foto $value");
                  });
                },
              ),
            ],
          ),
        ),
        (_inProgress)
            ? Container(
                height: MediaQuery.of(context).size.height * 0.95,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : Center(),
      ],
    );
  }
  // ============================= Body ====================

  _showAlertDialoSuccess(BuildContext context, int err) {
    Widget okButton = TextButton(
        child: Text("OK"),
        onPressed: () {
          // Navigator.pop(context);
          Get.offAll(() => PhotoPenerima(
                nikBaru: nikTamp,
              ));
        });
    AlertDialog alert = AlertDialog(
      title: Text("Success"),
      content: Text("Data berhasil diinput"),
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

  _showAlertFieldKosong(BuildContext context) {
    Widget okButton = TextButton(
        child: Text("OK"),
        onPressed: () {
          Navigator.pop(context);
        });
    AlertDialog alert = AlertDialog(
      title: Text("Masalah"),
      content: Text("Data gagal di upload"),
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
// ============================= Function Alert ====================

}

// ============================= Function Alert ====================

