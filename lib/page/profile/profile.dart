import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:puskeu/model/profile_model.dart';
import 'package:http/http.dart' as http;
import 'package:puskeu/model/save_token.dart';
import 'dart:math' as math;

import 'package:puskeu/page/login_design/login_animation.dart';

class ProfilePage extends StatefulWidget {
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  Future<Profile> futureProfile;
  AnimationController _controller;

  Future<Profile> getProfile() async {
    String url = 'https://app.puskeu.polri.go.id:2216/umkm/mobile/profil/';
    print("ini url profile di profile : $url");

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
      print(response.body);
      return Profile.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load profile data');
    }
  }

  @override
  void initState() {
    super.initState();
    futureProfile = getProfile();
    _controller = AnimationController(
      value: 0.0,
      duration: Duration(seconds: 40),
      upperBound: 1,
      lowerBound: -1,
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<Profile>(
        future: futureProfile,
        builder: (context, snapshot) {
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

  Widget _buildBody(Profile data) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildAnimation(data),
          _buildBodyForm(data),
        ],
      ),
    );
  }

  Widget _buildAnimation(Profile data) {
    var size = MediaQuery.of(context).size;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            AnimatedBuilder(
              animation: _controller,
              builder: (BuildContext context, Widget child) {
                return ClipPath(
                  clipper: DrawClip(_controller.value),
                  child: Container(
                    height: size.height * 0.34,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.bottomLeft,
                          end: Alignment.topRight,
                          colors: [Color(0xFF6D4C41), Color(0xFFA1887F)]),
                    ),
                    child: Opacity(
                      opacity: 0.7,
                      child: Image.asset(
                        "assets/images/bg.png",
                        fit: BoxFit.cover,
                        height: 180,
                      ),
                    ),
                  ),
                );
              },
            ),
            _buildName(data),
          ],
        ),
      ],
    );
  }

  //========================= AppBarDone==================
  Widget _buildName(Profile data) {
    var nameInitial = data.nama[0].toUpperCase();
    return Column(
      children: [
        SizedBox(
          height: 15,
        ),
        SizedBox(
          height: 90,
          width: 90,
          child: Stack(
            // overflow: Overflow.visible,
            fit: StackFit.expand,
            children: [
              CircleAvatar(
                backgroundColor: Colors.deepOrange[300],
                child: Text(
                  nameInitial,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
                radius: 30,
              ),
            ],
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          data.nama,
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        SizedBox(
          height: 7,
        ),
        Text(
          data.nrp,
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildBodyForm(Profile data) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                // SizedBox(
                //   height: 20,
                // ),
                _buildFormProfile(data),
                SizedBox(
                  height: 65,
                ),
                _buildLogOut(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // BUILD FORM 2
  Widget _buildFormProfile(Profile data) {
    return Card(
      elevation: 3,
      child: Column(
        children: <Widget>[
          _buildPangkat(data),
          Divider(
            height: 1,
            color: Colors.black54,
            indent: 7,
            endIndent: 5,
          ),
          _buildSatker(data),
          Divider(
            height: 1,
            color: Colors.black54,
            indent: 7,
            endIndent: 5,
          ),
          _buildPhone(data),
        ],
      ),
    );
  }

  Widget _buildItemData(String tag, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          tag,
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
        Text(
          value,
          style: TextStyle(color: Colors.black54, fontSize: 13),
        ),
      ],
    );
  }

  Widget _buildPangkat(Profile data) {
    return Container(
      padding: EdgeInsets.all(10),
      child: IntrinsicHeight(
        child: Row(
          children: <Widget>[
            Icon(
              Icons.shield,
              color: Colors.green,
              size: 30,
            ),
            SizedBox(
              width: 10,
            ),
            VerticalDivider(
              thickness: 1,
              color: Colors.black54,
              width: 1,
              indent: 5,
              endIndent: 5,
            ),
            SizedBox(
              width: 20,
            ),
            _buildItemData("Pangkat", data.pangkat)
          ],
        ),
      ),
    );
  }

  Widget _buildSatker(Profile data) {
    return Container(
      padding: EdgeInsets.all(10),
      child: IntrinsicHeight(
        child: Row(
          children: <Widget>[
            Icon(
              Icons.home,
              color: Colors.blue,
              size: 30,
            ),
            SizedBox(
              width: 10,
            ),
            VerticalDivider(
              thickness: 1,
              color: Colors.black54,
              width: 1,
              indent: 5,
              endIndent: 5,
            ),
            SizedBox(
              width: 20,
            ),
            _buildItemData("SATKER", data.kdsatker)
          ],
        ),
      ),
    );
  }

  Widget _buildPhone(Profile data) {
    return Container(
      padding: EdgeInsets.all(10),
      child: IntrinsicHeight(
        child: Row(
          children: <Widget>[
            Icon(
              Icons.phone,
              color: Colors.deepOrange[400],
              size: 30,
            ),
            SizedBox(
              width: 10,
            ),
            VerticalDivider(
              thickness: 1,
              color: Colors.black54,
              width: 1,
              indent: 5,
              endIndent: 5,
            ),
            SizedBox(
              width: 20,
            ),
            _buildItemData("Telp", data.nomorhp),
          ],
        ),
      ),
    );
  }

  Widget _buildLogOut() {
    return Stack(
      children: [
        ListTile(
          onTap: () async {
            await Token().removeToken();
            Get.offAll(() => LoginAnimation());
          },
          title: Text(
            'Logout',
            style: TextStyle(color: Colors.black, fontSize: 16),
          ),
          subtitle: Text(
            'Keluar dari Aplikasi',
            style: TextStyle(color: Colors.black54, fontSize: 13),
          ),
          trailing: Icon(
            Icons.power_settings_new,
            color: Colors.red,
            size: 30,
          ),
        ),
      ],
    );
  }
}

class DrawClip extends CustomClipper<Path> {
  double move = 0;
  double slice = math.pi;
  DrawClip(this.move);
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height * 0.8);
    double xCenter =
        size.width * 0.5 + (size.width * 0.6 + 1) * math.sin(move * slice);
    double yCenter = size.height * 0.8 + 69 * math.cos(move * slice);
    path.quadraticBezierTo(xCenter, yCenter, size.width, size.height * 0.8);

    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
