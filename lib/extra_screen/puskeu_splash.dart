import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:puskeu/main.dart';
import 'package:puskeu/extra_screen/curve_bar.dart';
import 'package:puskeu/main.dart';
import 'package:puskeu/page/login_design/login_animation.dart';

import '../model/save_token.dart';

class PuskeuSplash extends StatefulWidget {
  _PuskeuSplashState createState() => _PuskeuSplashState();
}

class _PuskeuSplashState extends State<PuskeuSplash> {
  @override
  void initState() {
    super.initState();
    cekLogin();
    cekToken();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void cekLogin() async {
    try {
      var token = await Token().getAccessToken();
      if (token != null) {
        Get.offAll(() => CurveBar());
      } else {
        splashStart();
      }
    } catch (e) {
      print(e);
    }
  }

  void cekToken() async {
    try {
      var token = await Token().getAccessToken();
      if (token.endsWith(null)) {
        Get.offAll(() => CurveBar());
      } else {
        LoginAnimation();
      }
    } catch (e) {
      print(e);
    }
  }

  splashStart() async {
    var duration = const Duration(seconds: 2);
    return Timer(duration, () {
      Get.offAll(() => LoginAnimation());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/images/puskeu.png',
              width: 200,
              height: 250,
            ),
          ],
        ),
      ),
    );
  }
}
