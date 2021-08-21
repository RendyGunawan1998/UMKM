import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:puskeu/bloc/simple_bloc_observer.dart';
import 'package:puskeu/extra_screen/puskeu_splash.dart';
import 'package:get/get.dart';

void main() {
  Bloc.observer = SimpleBlocObserver();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: PuskeuSplash(),
      // home: SearchNIK(),
      // home: SearchPage(),
      // theme: ThemeData(canvasColor: Colors.transparent),
    );
  }
}
