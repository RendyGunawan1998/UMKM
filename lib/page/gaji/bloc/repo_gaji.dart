part of 'gaji_bloc.dart';

class GajiRepo {
  Future<List<UserInfoData>> fetchDataFilter(
      {String tahun, String bulan}) async {
    var _nrp = await Token().getUserNRP();
    print(_nrp);

    // #=====================================================================#
    var _url = BASE_URL + "/eksekusi/2?NRP=$_nrp&tahun=$tahun&BULAN=$bulan";
    print("[GajiRepository] fetchGaji, GET: $_url");
    // #=====================================================================#

    var client = new http.Client();

    final response = await client.get(
      Uri.parse(_url),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer" + await Token().getAccessToken(),
      },
    );
    client.close();

    if (response.statusCode < 200 || response.statusCode > 204) {
      throw ErrorModel.fromJson(json.decode(response.body));
    }
    final res = json.decode(response.body);
    final data = res['data'] as List;
    return data.map((data) => UserInfoData.fromJson(data)).toList();
  }
}
