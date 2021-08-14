import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:puskeu/model/nik.dart';
import 'package:puskeu/model/save_token.dart';

Future<Nik> fetchNIK() async {
  final response = await http.get(
    Uri.parse(
        'https://app.puskeu.polri.go.id:2216/umkm/mobile/penerima/cari_nik/2125'),
    headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": "Bearer" + await Token().getAccessToken(),
    },
  );

  if (response.statusCode == 200) {
    print(response.body);
    return Nik.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load user data');
  }
}

Future getDataNIK() async {
  String url =
      'https://app.puskeu.polri.go.id:2216/umkm/mobile/penerima/cari_nik/2125';

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
    Token().saveUserData(json.encode(res));
    return response.body;
  } else {
    // throw Exception("Failed to load data");
    throw response;
  }
}
