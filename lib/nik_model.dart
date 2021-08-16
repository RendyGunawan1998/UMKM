import 'dart:convert';
import 'package:http/http.dart' as http;

class User {
  String nik;
  String name;

  User({this.nik, this.name});

  factory User.createUser(Map<String, dynamic> object) {
    return User(nik: object['NIK'], name: object['NAMA']);
  }

  static Future<List<User>> connectToAPI() async {
    String apiURL =
        "https://app.puskeu.polri.go.id:2216/umkm/mobile/penerima/cari_nik/?nik=2125";
    var apiResult = await http.get(
      Uri.parse(apiURL),
      headers: {
        "Authorization":
            'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJVVUlEIjoiMjM1MmJlMzctOTdhOC00MTM2LThhZjAtMGFlZjE5NGNjOWNhIiwiZXhwIjoxNjYwMzk1OTA3LCJwZXR1Z2FzIjp7Ik5SUCI6IjUiLCJOQU1BIjoibWFobXVkIiwiUEFOR0tBVCI6InRlc3QgcGFuZ2thdCIsIktEU0FUS0VSIjoiMTIzNDUiLCJOT01PUkhQIjoiMDgxMjA4MTIwODEyIn19.H7zb7A-oJTSUvehrj4c3vM2Q7zjVze91McX_LZFUF54'
      },
    );
    var jsonObject = json.decode(apiResult.body);
    // var userData = (jsonObject as Map<String, dynamic>)['data'];
    var userData = jsonObject['data'];

    // return User.createUser(userData);
    return (userData as List).map((e) => User.createUser(e)).toList();
  }
}
