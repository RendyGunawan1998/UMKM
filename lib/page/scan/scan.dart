import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:puskeu/model/save_token.dart';
import 'package:puskeu/model/scan_model.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:http/http.dart' as http;

class ScanPage extends StatefulWidget {
  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  String textResult = "Hasil QR Scan";
  var temp = "";
  String nikScan = "Belum tersedia \nScan Terlebih dahulu";

  @override
  void initState() {
    super.initState();
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
        title: Row(
          children: <Widget>[
            Text("Scan"),
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
            OutlinedButton(
              onPressed: () async {
                textResult = await scanner.scan();
                // final splitNames = textResult.split(';');
                // List splitList;
                // for (int i = 0; i < textResult.length; i++) {
                //   splitList.add(splitNames[i].trim());
                // }
                print(textResult);
                // print(splitList);
                var temp = textResult.split(";");

                print(temp[0].trim());
                print(temp[1].trim());
                print(temp[2].trim());
                nikScan = temp[0].trim();
                _cekValidasi(temp[0].trim());

                setState(() {
                  // Get.to(() => ScanResult(value: temp[0].trim()));
                });
              },
              child: Text("Scan Disini"),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  Future<String> _cekValidasi(String nik) async {
    String url =
        'https://app.puskeu.polri.go.id:2216/umkm/web/penerima/QR/' + nik;

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
      _showAlertDialoSuccess(context, response.statusCode);
      return response.body;
    } else {
      showAlertDialog(context, response.statusCode);
      throw Exception('Failed to validate');
    }
  }
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

showAlertDialog(BuildContext context, int err) {
  Widget okButton = TextButton(
    child: Text("OK"),
    onPressed: () => Navigator.pop(context),
  );
  AlertDialog alert = AlertDialog(
    title: Text("Error"),
    content: Text("Data tidak cocok"),
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

_showAlertDialoSuccess(BuildContext context, int err) {
  Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pop(context);
      });
  AlertDialog alert = AlertDialog(
    title: Text("Success"),
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
