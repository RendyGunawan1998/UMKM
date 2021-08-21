import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
// import 'package:get/get.dart';
import 'package:puskeu/model/new_nik.dart';
// import 'package:puskeu/model/nik.dart';
import 'package:puskeu/model/save_token.dart';
import 'package:puskeu/page/add_photo/photo.dart';
// import 'package:puskeu/page/add_photo/photo.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  // List data;

  // Future<Nik> futureNik;
  Future<List<NikBaru>> futureNik;

  @override
  void initState() {
    super.initState();
    futureNik = fetchNik();
  }

  Future<List<NikBaru>> fetchNik() async {
    var response = await http.get(
      // Uri.parse(
      //     "https://app.puskeu.polri.go.id:2216/umkm/mobile/penerima/cari_nik/2125"),
      Uri.parse(
          "https://app.puskeu.polri.go.id:2216/umkm/mobile/penerima/cari_nik/?nik=21"),

      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer" + await Token().getAccessToken(),
      },
    );
    print(response);
    if (response.statusCode == 200) {
      // return Nik.fromJson(json.decode(response.body));
      print(response.body);

      final res = json.decode(response.body);
      final data = res['data'];
      return (data as List).map((data) => NikBaru.fromJson(data)).toList();
    } else {
      print(response.body);
      throw Exception('Failed to load data');
    }
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
            Text("Search"),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<List<NikBaru>>(
          future: futureNik,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return _buildbody(snapshot.data);
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }

  Widget _buildbody(List<NikBaru> data) {
    return Container(
      padding: EdgeInsets.all(10.0),
      width: Get.width,
      height: Get.height * 0.8,
      child: ListView.builder(
        itemCount: data.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(
              data[index].nik,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
            subtitle: Text(
              data[index].nama,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
            trailing: IconButton(
                onPressed: () {
                  Get.to(() => PhotoPage(data[index]));
                },
                icon: Icon(Icons.add)),
          );
        },
      ),
    );
  }
}
