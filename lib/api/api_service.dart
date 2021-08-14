// import 'package:get/get.dart';
import 'package:http/http.dart' as http;
// import 'package:puskeu/main.dart';
import 'dart:convert';
import 'package:puskeu/model/save_token.dart';

Future loginUser(String email, String password) async {
  String url = 'http://103.247.216.226:11234/mobile/login';

  var _body = {'email': email, 'password': password};
  var response = await http.post(
    Uri.parse(url),
    body: json.encode(_body),
    headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
    },
  );
  //var toJson = jsonDecode(response.body);
  if (response.statusCode == 200) {
    Token().saveToken(response.body);
    print('Token : ' + response.body);

    return response.body;
  } else {
    // Get.snackbar('Login', "NRP/Password salah");
    // throw Exception(response.body);
    throw json.decode(response.body);
  }
}

Future getUserInfo() async {
  String url = 'http://103.247.216.226:11234/mobile/user';

  var response = await http.get(
    Uri.parse(url),
    headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": "Bearer" + await Token().getAccessToken(),
      //access token dlm bentuk bearer //disini udh ada auth untuk access
    },
  );
  //var toJson = jsonDecode(response.body);
  if (response.statusCode == 200) {
    final res = json.decode(response.body);
    Token().saveUserData(json.encode(res["user"]));
    return response.body;
  } else {
    // throw Exception("Failed to load data");
    throw response;
  }
}
