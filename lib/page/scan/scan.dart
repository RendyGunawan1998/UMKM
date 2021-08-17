import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get.dart';
import 'package:puskeu/model/save_token.dart';
import 'package:puskeu/page/login_design/login_animation.dart';
import 'package:qrscan/qrscan.dart' as scanner;

class ScanPage extends StatefulWidget {
  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  String text = "Hasil QR Scan";

  Future<String> _scan() async {
    return await FlutterBarcodeScanner.scanBarcode(
            "#000000", "Cancel", true, ScanMode.QR)
        .then((value) => null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
          ),
          child: Text("Scan"),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await Token().removeToken();
              Get.offAll(LoginAnimation());
            },
            icon: Icon(
              Icons.power_settings_new,
              color: Colors.red,
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(text),
            SizedBox(
              height: 20,
            ),
            OutlinedButton(
              onPressed: () async {
                text = await scanner.scan();
                setState(() {
                  // text = _scan();
                });
              },
              child: Text("Scan Disini"),
            ),
          ],
        ),
      ),
    );
  }
}
