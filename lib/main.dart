import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:puskeu/bloc/simple_bloc_observer.dart';
import 'package:puskeu/extra_screen/puskeu_splash.dart';
import 'package:get/get.dart';
import 'package:puskeu/model/save_token.dart';
import 'package:puskeu/page/login_design/login_animation.dart';

void main() {
  Bloc.observer = SimpleBlocObserver();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BTPKLW Versi 1.0',
      home: PuskeuSplash(),
    );
  }
}

class MyAppPage extends StatefulWidget {
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<PuskeuSplash> {
  // Timer timer;

  // @override
  // void initState() {
  //   timer = Timer.periodic(Duration(seconds: 10), cekAppBackground());
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(),
    );
  }
}
