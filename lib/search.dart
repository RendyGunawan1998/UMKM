import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:puskeu/model/nik.dart';
import 'package:puskeu/model/save_token.dart';
import 'package:puskeu/page/add_photo/photo.dart';

import 'nik_model.dart';

class SearchNIK extends StatefulWidget {
  @override
  _SearchNIKState createState() => _SearchNIKState();
}

class _SearchNIKState extends State<SearchNIK> {
  List<User> user = null;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Get API"),
        ),
        body: Center(
          child: Column(
            children: [
              Text((user != null) ? user[0].name : "Tidak ada data"),
              RaisedButton(
                onPressed: () {
                  User.connectToAPI().then((value) {
                    user = value;
                    setState(() {});
                  });
                },
                child: Text("GET"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
