import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:puskeu/extra_screen/curve_bar.dart';
import 'package:puskeu/model/save_token.dart';
import 'package:puskeu/model/scan_model.dart';
import 'package:puskeu/page/add_photo/photo_copy.dart';
// import 'package:qrscan/qrscan.dart' as scanner;
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

class ScanPage extends StatefulWidget {
  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  String textResult = "Hasil QR Scan";
  String scan = "Scan Disini";
  String namaHasilScan = "";
  var temp = "";
  String nikScan = "Belum tersedia \nScan Terlebih dahulu";
  bool _cekValidasiDone = false;
  bool _tampHasil;

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
      appBar: AppBar(
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
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "NIK : $nikScan",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            SizedBox(
              height: 10,
            ),
            _tampHasil == true
                ? Text(
                    "Nama : $namaHasilScan",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  )
                : Container(),
            SizedBox(
              height: 10,
            ),
            OutlinedButton(
              onPressed: () async {
                var cameraStatus = await Permission.camera.status;
                if (cameraStatus.isGranted) {
                  textResult = await FlutterBarcodeScanner.scanBarcode(
                      "#000000", "Cancel", false, ScanMode.QR);
                  print(textResult);
                  // return textResult;
                } else {
                  var isGrant = await Permission.camera.request();
                  if (isGrant.isGranted) {
                    textResult = await FlutterBarcodeScanner.scanBarcode(
                        "#000000", "Cancel", false, ScanMode.QR);
                    print(textResult);
                    // return textResult;
                  }
                }
                print(textResult);
                // print(splitList);
                var temp = textResult.split(";");

                print(temp[0].trim());
                print(temp[1].trim());
                print(temp[2].trim());
                nikScan = temp[0].trim();
                _cekValidasi(temp[2].trim(), temp[0].trim());
              },
              child: Text(scan),
            ),
            SizedBox(
              height: 10,
            ),
            _tampHasil == true
                ? OutlinedButton(
                    onPressed: () {
                      Get.to(() => PhotoPage(nikScan));
                    },
                    child: Text("Upload Foto"))
                : Container(),
          ],
        ),
      ),
    );
  }

  Future<String> _cekValidasi(String uid, String _cekNIK) async {
    // String url =
    //     'https://app.puskeu.polri.go.id:2216/umkm/mobile/penerima/qr/' + uid;

    String url =
        'https://app.puskeu.polri.go.id:2216/umkm/web/penerima/qr_scan/' + uid;

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
      var tamp = json.decode(response.body);
      print("ini debug validasi: " + _cekNIK);
      print(tamp["NIK"]);
      print(tamp["NAMA"]);
      // kondisi NIK
      _cekNIK == tamp["NIK"]
          ? _showAlertDialoSuccess(context)
          : showAlertDialog(context, response.body);
      // Kondisi muncul button
      _cekNIK == tamp["NIK"]
          ? _cekValidasiDone = true
          : _cekValidasiDone = false;
      setState(() {
        scan = "Scan Ulang";
        namaHasilScan = tamp["NAMA"];
        _tampHasil = _cekValidasiDone;
        print("ini hasil tamp");
        print(_tampHasil);
        return _tampHasil;
      });
      print(_cekValidasiDone);
      return response.body;
    } else {
      showAlertDialog(context, response.body);
      throw Exception('Failed to validate');
    }
  }
}

showAlertDialog(BuildContext context, String err) {
  Widget okButton = TextButton(
    child: Text("OK"),
    onPressed: () => Get.offAll(() => CurveBar()),
  );
  AlertDialog alert = AlertDialog(
    title: Text("Masalah"),
    content: Text("Data tidak ditemukan"),
    // Text(
    //     "Data tidak cocok \nData tidak sesuai dengan yang ada di database"),
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

_showAlertDialoSuccess(BuildContext context) {
  Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pop(context);
      });
  AlertDialog alert = AlertDialog(
    title: Text("Berhasil"),
    content: Text("Data cocok"),
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

class ScanResult extends StatefulWidget {
  final String value;
  ScanResult({Key key, this.value}) : super(key: key);

  @override
  _ScanResultState createState() => _ScanResultState();
}

class _ScanResultState extends State<ScanResult> {
  // String text = "";
  Future<Scan> futureScan;

  @override
  void initState() {
    super.initState();
    futureScan = getDataScan("${widget.value}");
  }

  Future<Scan> getDataScan(String textScan) async {
    String url =
        'https://app.puskeu.polri.go.id:2216/umkm/mobile/penerima/qr_scan/' +
            textScan;

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
      return Scan.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to validate');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
          ),
          child: Text("Tampil NIK"),
        ),
      ),
      body: FutureBuilder<Scan>(
        future: futureScan, // a previously-obtained Future<String> or null
        builder: (context, snapshot) {
          // List<Widget> children;
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

  Widget _buildBody(Scan data) {
    return Center(
        child: Column(
      children: <Widget>[
        Text(
          data.nik,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        MaterialButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("OK"),
        ),
      ],
    ));
  }
}
