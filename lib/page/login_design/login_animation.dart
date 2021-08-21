import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:puskeu/extra_screen/curve_bar.dart';
import 'package:puskeu/get_data/fetch.dart';
import 'package:puskeu/model/save_token.dart';
import 'dart:math' as math;

import 'package:http/http.dart' as http;
import '../../extra_screen/loading.dart';

class LoginAnimation extends StatefulWidget {
  _LoginAnimationState createState() => _LoginAnimationState();
}

class _LoginAnimationState extends State<LoginAnimation>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool _obsecureText = true;

  TextEditingController userTC = new TextEditingController();
  TextEditingController passTC = new TextEditingController();

  // LoginRequestModel requestModel;
  bool visible = false;

  String message = '';

  @override
  void initState() {
    super.initState();
    cekLogin();
    // requestModel = new LoginRequestModel();
    //animation
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
    userTC.dispose();
    passTC.dispose();
    super.dispose();
  }

  void cekLogin() async {
    try {
      // get token from local storage
      var token = await Token().getAccessToken();
      if (token != null) {
        Get.offAll(() => CurveBar());
      }
    } catch (e) {
      print(e);
    }
  }

  String validatePassword(value) {
    if (value.isEmpty) {
      return "Password can't be empty";
    }
    // else if (value.length <= 7) {
    //   return "Password to short, please make 7 character";
    // }
    else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[100],
      // Color(0xff21254A),
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _buildAnimation(),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                // padding: const EdgeInsets.only(left: 7),
                child: Image.asset(
                  "assets/images/puskeu.png",
                  width: 100,
                  height: 100,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Form(
                key: formKey,
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      TextFormField(
                          decoration: InputDecoration(
                              hintText: "Masukkan NRP/NIP",
                              labelText: "NRP/NIP",
                              prefixIcon: Icon(
                                Icons.person,
                                color: Colors.grey,
                              ),
                              border: UnderlineInputBorder(
                                  borderRadius: BorderRadius.circular(20))),
                          keyboardType: TextInputType.number,
                          validator:
                              RequiredValidator(errorText: 'NRP/NIP required'),
                          controller: userTC,
                          onSaved: (value) {
                            userTC.text = value;
                          }),
                      SizedBox(height: 15),
                      TextFormField(
                          decoration: InputDecoration(
                            labelText: "Password",
                            hintText: "Masukkan Kata Sandi",
                            prefixIcon: Icon(Icons.lock, color: Colors.grey),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obsecureText
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obsecureText = !_obsecureText;
                                });
                              },
                            ),
                            border: UnderlineInputBorder(
                                borderRadius: BorderRadius.circular(20)),
                          ),
                          obscureText: _obsecureText,
                          validator: validatePassword,
                          controller: passTC,
                          onSaved: (value) {
                            passTC.text = value;
                          }),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        _buildButtonLogin(),
      ],
    );
  }

  Widget _buildAnimation() {
    var size = MediaQuery.of(context).size;
    return AnimatedBuilder(
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
    );
  }

  Widget _buildButtonLogin() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 200,
          child: MaterialButton(
            onPressed: () {
              _testLogin();
            },
            color: Colors.blueAccent,
            child: Text(
              "LOGIN",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
        ),
      ],
    );
  }

  void _testLogin() async {
    if (formKey.currentState.validate()) {
      setState(() {
        visible = true;
      });

      var _body = {'NRP': userTC.text, 'password': passTC.text};
      print("NRP " + json.encode(_body));
      try {
        var response = await http.post(
          Uri.parse("https://app.puskeu.polri.go.id:2216/umkm/mobile/login/"),
          body: json.encode(_body),
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/json",
            // "Authorization": "Bearer " + await Token().getAccessToken(),
          },
        );
        if (response.statusCode == 200) {
          Token().saveToken(response.body);
          print('Token : ' + response.body);
          setState(() {
            visible = false;
          });

          await getDataNIK();
          Get.offAll(() => LoadingScreen());
        } else {
          setState(() {
            visible = false;
          });
          _showAlertDialog(context, response.statusCode);
        }
      } catch (e) {
        print(e);
      }
    } else {
      print("validate unsuccess");
    }
  }
}

_showAlertDialog(BuildContext context, int err) {
  Widget okButton = TextButton(
    child: Text("OK"),
    onPressed: () => Navigator.pop(context),
  );
  AlertDialog alert = AlertDialog(
    title: Text("Error"),
    content: Text("NRP/Password salah \nSilahkan ulangi kembali."),
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
