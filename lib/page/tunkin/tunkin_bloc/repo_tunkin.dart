part of 'tunkin_bloc.dart';

class TunkinRepo {
  Future<List<Tunkin>> fetchTunkinFilter({String tahun, String bulan}) async {
    var _nrp = await Token().getUserNRP();
    print(_nrp);

    // #=====================================================================#
    var _url = BASE_URL + "/eksekusi/1?NRP=$_nrp&tahun=$tahun&BULAN=$bulan";
    print("[TunkinRepo] fetchTunkin, GET: $_url");
    // #=====================================================================#

    // #=================================DIFFERENT====================================#

    final response = await http.get(
      Uri.parse(_url),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer" + await Token().getAccessToken(),
      },
    );

    if (response.statusCode == 200) {
      print(response.body);

      final res = json.decode(response.body);
      final data = res['data'];
      return (data as List).map((data) => Tunkin.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load tunkin data');
    }
  }
}
