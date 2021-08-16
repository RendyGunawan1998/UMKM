import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:puskeu/model/nik.dart';
import 'package:puskeu/model/save_token.dart';
import 'package:puskeu/page/add_photo/photo.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  // List data;

  Future<Nik> futureNik;

  @override
  void initState() {
    super.initState();
    futureNik = fetchNik();
  }

  Future<Nik> fetchNik() async {
    var response = await http.get(
      Uri.parse(
          "https://app.puskeu.polri.go.id:2216/umkm/mobile/penerima/cari_nik/2125"),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer" + await Token().getAccessToken(),
      },
    );
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return Nik.fromJson(json.decode(response.body)[0]);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }

    // setState(() {
    //   var convertToJson = json.decode(response.body);
    //   data = convertToJson;
    // });
    // return "Success";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("NIK"),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<Nik>(
          future: futureNik,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return _buildbody(snapshot.data);
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }

            // By default, show a loading spinner.
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }

  Widget _buildbody(Nik data) {
    return Container(
        padding: EdgeInsets.all(10.0),
        child: ListTile(
          title: Text(
            data.nik,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
          ),
          trailing: IconButton(
              onPressed: () {
                Get.to(PhotoPage());
              },
              icon: Icon(Icons.add)),
        ));
  }
}
