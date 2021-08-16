import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:puskeu/model/save_token.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PhotoPage extends StatefulWidget {
  @override
  _PhotoPageState createState() => _PhotoPageState();
}

class _PhotoPageState extends State<PhotoPage> {
  File _selectedImage;
  ProgressDialog pr;
  bool _inProgress = false;

  var nikTXT = TextEditingController();
  var jenis = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Location location = new Location();
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;
  // bool _isListenLocation = false;
  bool _isGetLocation = false;

  final List<String> nameList = <String>[
    "Tampak Depan",
    "Tampak Kiri",
    "Tampak Kanan",
    "Tampak Belakang",
  ];

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
    setState(() {
      _isGetLocation = true;
    });
  }

  Widget getImageWidget() {
    if (_selectedImage != null) {
      return Image.file(
        _selectedImage,
        width: 100,
        height: 100,
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

  // =================== GET IMAGE DONE ================
  getImage(ImageSource source) async {
    setState(() {
      _inProgress = true;
    });
    File image = await ImagePicker.pickImage(source: source);
    if (image != null) {
      File cropped = await ImageCropper.cropImage(
        sourcePath: image.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 50,
        maxHeight: 200,
        maxWidth: 200,
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

  void _buttonUpload() async {
    if (formKey.currentState.validate()) {
      String url =
          'https://app.puskeu.polri.go.id:2216/umkm/mobile/penerima-foto/';

      var _body = {
        'NIK': nikTXT.text,
        'KODEFOTO': TextValue.showBulan(jenis.text),
        'LATITUDE': _locationData.latitude,
        'LONGITUDE': _locationData.longitude,
        'FOTO': _selectedImage,
      };
      try {
        var response = await http.post(
          Uri.parse(url),
          body: json.encode(_body),
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/json",
          },
        );
        if (response.statusCode == 200) {
          Token().saveToken(response.body);
          print('Token : ' + response.body);
          print("Success upload");

          // return response.body;
        } else {
          _showAlertDialog(context, response.statusCode);
        }
      } catch (e) {
        print(e);
      }
    } else {
      print("upload unsuccess");
    }
  }

  Future<String> addTreatment(String nik, int jenis, double latitude,
      double longitude, String photo) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    Map<String, String> headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": "Bearer " + await Token().getAccessToken(),
    };

    var uri = Uri.parse(
        'https://app.puskeu.polri.go.id:2216/umkm/mobile/penerima-foto/');
    var request = new http.MultipartRequest("POST", uri);

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
    // print(response);
    if (response.statusCode == 200) {
      // final data = json.decode(response.body);
      print(response.body);
      return "Berhasil";
    } else {
      // return "gagal";
      print(response.body);
      _showAlertDialog(context, response.statusCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    print(_selectedImage?.lengthSync());
    return Scaffold(
      appBar: AppBar(
        title: Text("Click | Pick "),
      ),
      bottomNavigationBar: MaterialButton(
        color: Colors.blue,
        onPressed: () {
          // print({'NIK': nikTXT.text});
          // print({'KODEFOTO': TextValue.showBulan(jenis.text)});
          // print({'LATITUDE': _locationData.latitude});
          // print({'LONGITUDE': _locationData.longitude});
          addTreatment(
              nikTXT.text,
              TextValue.showBulan(jenis.text),
              _locationData.latitude,
              _locationData.longitude,
              _selectedImage.path);
          // _buttonUpload();
        },
        child: Text("Upload"),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: formKey,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  getImageWidget(),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        MaterialButton(
                          minWidth: 120,
                          onPressed: () {
                            getImage(ImageSource.camera);
                            _getLocation();
                          },
                          color: Colors.green,
                          child: Text("Take Photo"),
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                              hintText: "Contoh: 2125",
                              labelText: "NIK",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20))),
                          keyboardType: TextInputType.number,
                          validator:
                              RequiredValidator(errorText: 'NIK required'),
                          controller: nikTXT,
                          onSaved: (value) {
                            nikTXT.text = value;
                          },
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        MaterialButton(
                          minWidth: 120,
                          color: Colors.green,
                          child: Text("Delete"),
                          onPressed: () {
                            getImage(ImageSource.gallery);
                          },
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                              hintText: "D/B/L/R",
                              labelText: "Jenis Foto",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20))),
                          keyboardType: TextInputType.text,
                          validator:
                              RequiredValidator(errorText: 'NIK required'),
                          controller: jenis,
                          onSaved: (value) {
                            jenis.text = value;
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),
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
      ),
    );
  }
}

class TextValue {
  static showBulan(String display) {
    if (display == 'Depan') {
      return 1;
    } else if (display == 'Kiri') {
      return 2;
    } else if (display == 'Kanan') {
      return 123;
    } else if (display == 'Belakang') {
      return 1111;
    }
  }
}

_showAlertDialog(BuildContext context, int err) {
  Widget okButton = TextButton(
    child: Text("OK"),
    onPressed: () => Navigator.pop(context),
  );
  AlertDialog alert = AlertDialog(
    title: Text("Error"),
    content: Text("Something wrong. \nPlease try again"),
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
