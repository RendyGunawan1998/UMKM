import 'package:flutter/material.dart';
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
                setState(() {});
              },
              child: Text("Scan Disini"),
            ),
          ],
        ),
      ),
    );
  }
}
