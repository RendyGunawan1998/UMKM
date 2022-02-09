// ignore_for_file: missing_return

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:package_info/package_info.dart';
import 'package:puskeu/extra_screen/curve_bar.dart';
// import 'package:puskeu/model/new_nik.dart';
import 'package:puskeu/model/nikv2.dart';
import 'package:puskeu/model/save_token.dart';
import 'package:puskeu/model/version.dart';
import 'package:puskeu/page/add_photo/photo_asli.dart';
import 'package:puskeu/page/login_design/login_animation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:version/version.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  // Future<List<NikBaru>> futureNik;
  Future<List<Nikv2>> futureNik;
  Future<String> futureProfile;
  TextEditingController _searchTxt = TextEditingController();
  String searchString = "";
  String tampKDSATKER = "";
  bool statusCari = false;

  String versi;

  String link;

  Future<VersionHp> cekVersi;

  Version currentVersion;
  Version latestVersion;

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    cekVersi = cekVersion();
    futureProfile = getProfile();
    // clearTamp();
    // print("disini kdsatker di init :$tampKDSATKER");
    futureNik = fetchNik("", "");
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<VersionHp> cekVersion() async {
    try {
      String url = 'https://app.puskeu.polri.go.id:2216/umkm/mobile/version';
      // print("ini url version : $url");

      PackageInfo packageInfo = await PackageInfo.fromPlatform();

      String appName = packageInfo.appName;
      String packageName = packageInfo.packageName;
      String version = packageInfo.version;
      String buildNumber = packageInfo.buildNumber;
      print(appName);
      print(packageName);
      print(buildNumber);
      print(version);
      currentVersion = Version.parse(version);
      print("ini currentVersion = $currentVersion");

      var response = await http.get(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer " + await Token().getAccessToken(),
        },
      );
      //var toJson = jsonDecode(response.body);
      if (response.statusCode == 200) {
        var tamp = json.decode(response.body);
        versi = tamp["version"];
        link = tamp['url_download'];
        print("ini link : $link");
        latestVersion = Version.parse(versi);
        print("ini latestVersion = $latestVersion");
        if (latestVersion > currentVersion) {
          print("perlu update");
          return _showAlertToUpdate(context);
        } else if (currentVersion == latestVersion) {
          print("updated");
          return null;
        }
        // return latestVersion;
      } else {
        await Token().removeToken();
        return Get.offAll(() => LoginAnimation());
      }
    } catch (e) {
      print(e);
      await Token().removeToken();
      return Get.offAll(() => LoginAnimation());
    }
  }

  _showAlertToUpdate(BuildContext context) {
    Widget okButton = TextButton(
        child: Text("Update"),
        onPressed: () {
          setState(() {
            currentVersion = latestVersion;
          });
          _launchURL();
        });
    AlertDialog alert = AlertDialog(
      title: Text("Pemberitahuan"),
      content: Text(
          "Ada versi terbaru untuk aplikasi mobile. Segera update ke versi terbaru"),
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

  void _launchURL() async => await canLaunch(link)
      ? await launch(link)
      : throw 'Could not launch $link';

  Future<String> getProfile() async {
    String url = 'https://app.puskeu.polri.go.id:2216/umkm/mobile/profil/';
    // print("ini url profile di profile : $url");

    var response = await http.get(
      Uri.parse(url),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer " + await Token().getAccessToken(),
      },
    );
    //var toJson = jsonDecode(response.body);
    if (response.statusCode == 200) {
      // print(response.body);
      var tamp = json.decode(response.body);

      setState(() {
        tampKDSATKER = tamp["KDSATKER"];
        // print("ini kd sakter di getProfile $tampKDSATKER");
        futureNik = fetchNik("", tampKDSATKER);
        return tampKDSATKER;
      });
      return tampKDSATKER;
      // return Profile.fromJson(jsonDecode(response.body));
    } else {
      await Token().removeToken();
      return Get.offAll(() => LoginAnimation());
      // throw Exception('Failed to load profile data');
    }
  }

  Future<List<Nikv2>> fetchNik(String cariNIK, String satker) async {
    satker = tampKDSATKER;
    // print("ini sakter di fetch nik : $satker");

    try {
      var url =
          "https://app.puskeu.polri.go.id:2216/umkm/mobile/penerima/cari_nik/?nik=$cariNIK&kdsatker=$satker"; //old
      // "https://app.puskeu.polri.go.id:2216/umkm/mobile/v2/penerima/cari_nik/?nik=$cariNIK&kdsatker=$satker"; //NEW
      // "https://app.puskeu.polri.go.id:2216/umkm/mobile/penerima/cari_nik_raw/?nik=$cariNIK&kdsatker=$satker"; //Raw
      print("ini url fetch nik : $url");
      var response = await http.get(
        Uri.parse(url),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer " + await Token().getAccessToken(),
        },
      );
      // print("ini response body fetch nik : ${response.body}");
      if (response.statusCode == 200) {
        // return Nik.fromJson(json.decode(response.body));
        // print(response.body);
        print("ini status 200");

        final res = json.decode(response.body);
        final data = res['data'];
        return (data as List).map((data) => Nikv2.fromJson(data)).toList();
      } else {
        print("ini else throw");
        // print(response.body);
        await Token().removeToken();
        return Get.offAll(() => LoginAnimation());
        // throw Exception('Failed to load data');
      }
    } catch (e) {
      print(e);
      print("ini catch error");
      await Token().removeToken();
      return Get.offAll(() => LoginAnimation());
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
      body: SingleChildScrollView(
        child: FutureBuilder<List<Nikv2>>(
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

  _searchbar() {
    return Padding(
        padding: EdgeInsets.only(top: 8),
        child: Theme(
          data: ThemeData(
            primaryColor: Colors.teal[200],
            primaryColorDark: Colors.tealAccent,
          ),
          child: TextFormField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.teal[100],
                ),
              ),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    // _searchTxt.text = "";
                    _searchTxt.clear();
                    // futureNik = fetchNik("", "");

                    Get.offAll(() => CurveBar());
                  });
                },
                icon: Icon(Icons.clear),
              ),
              labelText: "NIK",
              hintText: "Cari NIK",
            ),
            onChanged: (value) {
              if (value.length > 9) {
                setState(() {
                  searchString = value;
                  print("ini search string $searchString");
                  futureNik = fetchNik(searchString, tampKDSATKER);
                });
              } else
                return null;
            },
            controller: _searchTxt,
          ),
        ));
  }

  Widget _buildbody(List<Nikv2> data) {
    return Container(
      padding: EdgeInsets.all(10.0),
      width: Get.width,
      height: Get.height * 0.8,
      child: Column(
        children: <Widget>[
          _searchbar(),
          Expanded(
            child: ListView.builder(
              itemCount: data.length,
              itemBuilder: (BuildContext context, int index) {
                return data[index].nik.contains(searchString)
                    ? Card(
                        child: Padding(
                          padding:
                              const EdgeInsets.only(top: 5, left: 16, right: 5),
                          child: ListTile(
                            title: Text(
                              data[index].nik,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18.0),
                            ),
                            subtitle: Text(
                              data[index].nama,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18.0),
                            ),
                            trailing: IconButton(
                                onPressed: () {
                                  Get.to(() => PhotoPageAsli(data[index]));
                                },
                                icon: Icon(Icons.add)),
                          ),
                        ),
                      )
                    : Container();
              },
            ),
          ),
        ],
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    Widget okButton =
        TextButton(child: Text("OK"), onPressed: () => Navigator.pop(context));
    AlertDialog alert = AlertDialog(
      title: Text("Masalah"),
      content: Text("KDSATKER tidak ditemukan"),
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
}
