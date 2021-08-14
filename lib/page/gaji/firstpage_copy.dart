import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:puskeu/extra_screen/loading.dart';
import 'package:puskeu/extra_screen/filter.dart';
import 'package:puskeu/model/data.dart';
import 'package:puskeu/model/save_token.dart';
import 'package:puskeu/page/gaji/bloc/gaji_bloc.dart';
import 'package:puskeu/widgets/errors/loaddata_error.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirstPageBloc extends StatefulWidget {
  FirstPageBloc({
    Key key,
  }) : super(key: key);
  _FirstPageBlocState createState() => _FirstPageBlocState();
}

class _FirstPageBlocState extends State<FirstPageBloc> {
  final GajiBloc _gajiBloc = GajiBloc(gajirepo: GajiRepo());
  // Future<UserInfoData> futureUser;

  // params untuk filtering
  String bulan;
  String tahun;
  List<String> bulanTahun = [];

  void cekBT() async {
    // get bulan tahun from shared preference
    var token = await Token().getBulanTahun('bulanTahun');
    // print("$token");
    if (token != null) {
      // print("$res");
      setState(() {
        bulan = token[0];
        tahun = token[1];
      });
    } else {
      // print("Null");
      setState(() {
        bulan = getCurrentMonth();
        tahun = getCurrentYear();
      });
    }
    _gajiBloc.add(GajiUpdate(bulan: bulan, tahun: tahun));
  }

  final formkey = new GlobalKey<FormState>();

  static String getCurrentYear() {
    String formattedDate = DateFormat('yyyy').format(DateTime.now());
    return formattedDate;
  }

  static String getCurrentMonth() {
    String formattedDate = DateFormat('MM').format(DateTime.now());
    return formattedDate;
  }

  Future<void> getDataFilter() async {
    setState(() {
      tahun = getCurrentYear();
      bulan = getCurrentMonth();
    });
  }

  removeParamBulanTahun() async {
    // digunakan untuk clear SP bulanTahun
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove('bulanTahun');
  }

  @override
  void initState() {
    super.initState();
    // removeParamBulanTahun();
    cekBT();

    // klo udah pake cekBT, function getDataFilter tidak perlu lagi dipanggil,
    // karena kita ambil bulan dan tahun dari shared preferences
    // getDataFilter();
    // cara manggil event bloc
    _gajiBloc.add(GajiFetch(
      bulan: bulan,
      tahun: tahun,
    ));
  }

  void _saveBulanTahun(String _paramBulan, String _paramTahun) {
    print("bulan: $_paramBulan");
    print("tahun: $_paramTahun");
    setState(() {
      bulan = _paramBulan;
      tahun = _paramTahun;
    });
    _gajiBloc.add(GajiUpdate(bulan: bulan, tahun: tahun));
    Token().saveBulanTahun('bulanTahun', [_paramBulan, _paramTahun]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.blueGrey[200], Colors.blueGrey[100]])),
        ),
        // backgroundColor: Colors.blueGrey[200],
        elevation: 0,
        title: Row(
          children: <Widget>[
            _buildAppbar(),
          ],
        ),
      ),
      body: BlocProvider(
        create: (context) => GajiBloc(
          gajirepo: GajiRepo(),
        ),
        child: BlocBuilder<GajiBloc, GajiState>(
          bloc: _gajiBloc,
          builder: (context, state) {
            if (state is GajiOnFailure) {
              //error
              return LoadDataError(
                subtitle: state.dataError.message,
              );
            }

            //hasData
            if (state is GajiDataLoaded) {
              if (state.dataList.isEmpty) {
                return Center(
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.fromLTRB(60, 140, 50, 0),
                          child: Image.asset(
                            "assets/images/no_data.png",
                            width: 150,
                            height: 100,
                            fit: BoxFit.fill,
                            // color: Colors.black.withOpacity(0.3),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 5, 20, 50),
                          child: Column(
                            children: [
                              Text("No Data"),
                              Text("Data Gaji bulan ini belum diproses"),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }
              return _buildBody1(state.dataList[0]);
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildBody1(UserInfoData data) {
    return ListView(
      shrinkWrap: true,
      children: [
        _buildProfile(data),
        SizedBox(
          height: 10,
        ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
              bottomLeft: Radius.circular(25),
              bottomRight: Radius.circular(25),
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _buildGajiBersih(data),
                _buildDetailGaji(data),
                _buildDetailGajiList(context, data),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _buildAppbar() {
    return Image.asset(
      "assets/images/presisi.png",
      width: 200,
    );
  }

  Widget _buildProfile(UserInfoData data) {
    // var nameInitial = data.nmpeg[0].toUpperCase();
    // if (data.nmpeg == null) {
    //   nameInitial = "";
    // }
    return Card(
      color: Colors.white,
      elevation: 0,
      child: ListTile(
        title: Text(
          data.nmpeg,
          style: TextStyle(color: Colors.black),
        ),
        subtitle: Text(
          data.nrp,
          style: TextStyle(color: Colors.black),
        ),
        leading: CircleAvatar(
          radius: 22,
          child: Text(
            data.nmpeg[0].toUpperCase(),
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          backgroundColor: Colors.orange,
        ),
        trailing: TextButton(
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) {
                    LoadingScreen();
                    return _buildDetailPersonil(context, data);
                  });
            },
            child: Text(
              "DETAILS",
              style: TextStyle(color: Colors.blue),
            )),
      ),
    );
  }

  Widget _buildGajiBersih(UserInfoData data) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: Colors.white,
        child: Container(
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.deepPurple,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Gaji Bersih",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    NumberFormat.simpleCurrency(
                            locale: 'id', name: 'Rp ', decimalDigits: 0)
                        .format(data.bersih),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailGaji(UserInfoData data) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: Colors.grey,
        child: Container(
          height: 50,
          color: Colors.grey.shade300,
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 4,
                child: Text(
                  "Detail Gaji",
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              Expanded(
                flex: 6,
                child: Text(
                  TextShowBulan.showBulan(data.bulan.toString()) +
                      " - " +
                      data.tahun,
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailGajiList(BuildContext context, UserInfoData data) {
    return Column(children: <Widget>[
      _buildItemDetail("NAMA BANK", data.nmBank),
      _buildItemDetail("NO REKENING", data.rekening),
      _buildItemDetail2("Gapok", data.gapok.toString()),
      _buildItemDetail2("TUN ISTRI", data.tistri.toString()),
      _buildItemDetail2("TUN ANAK", data.tanak.toString()),
      _buildItemDetail2("TUN JUPNS", data.tjupns.toString()),
      _buildItemDetail2("TUN STRUKTUR", data.tstruktur.toString()),
      _buildItemDetail2("TUN FUNGSI", data.tfungsi.toString()),
      _buildItemDetail2("TUN PAPUA", data.tpapua.toString()),
      _buildItemDetail2("TUN PENCIL", data.tpencil.toString()),
      _buildItemDetail2("TUN BERAS", data.tberas.toString()),
      _buildItemDetail2("TUN POLWAN", data.tpolwan.toString()),
      _buildItemDetail2("BULAT", data.bulat.toString()),
      _buildItemDetail2("TUN PAJAK", data.tpajak.toString()),
      _buildItemDetail2("TUN LAUK", data.tlauk.toString()),
      _buildItemDetail2("TUN BABIN", data.tbabin.toString()),
      _buildItemDetail2("TUN SANDI", data.tsandi.toString()),
      _buildItemDetail2("TUN BREVET", data.tbrevet.toString()),
      _buildItemDetail2("TUN KHUSUS", data.tkhusus.toString()),
      _buildItemDetail2("TUN BATAS", data.tbatas.toString()),
      _buildItemDetail2("POT KELBTJ", data.potkelbtj.toString()),
      _buildItemDetail2("POT PFK2", data.potpfk2.toString()),
      _buildItemDetail2("POT PFK10", data.potpfk10.toString()),
      _buildItemDetail2("PPH", data.pph.toString()),
      _buildItemDetail2("IWP", data.iwp.toString()),
      _buildItemDetail2("BPJS", data.bpjs.toString()),
      _buildItemDetail2("SEWA RMH", data.sewarmh.toString()),
      _buildItemDetail2("POT KELBTJ1", data.potkelbtj1.toString()),
      _buildItemDetail2("POT LAIN", data.potlain.toString()),
    ]);
  }

  Widget _buildItemDetail(String tag, String value) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 7, 15, 5),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                flex: 4,
                child: Text(
                  tag,
                  style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              Expanded(
                flex: 6,
                child: Text(
                  value,
                  style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.right,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildItemDetail2(String tag, String value) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 7, 15, 5),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                flex: 4,
                child: Text(
                  tag,
                  style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              Expanded(
                flex: 6,
                child: Text(
                  "Rp " + TextFormat.simpleCurrency(value),
                  style: TextStyle(
                    color: ChangeColorData.changeColor(value),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.right,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailPersonil(BuildContext context, UserInfoData data) {
    return Container(
      height: MediaQuery.of(context).size.height * .60,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          color: Colors.white,
        ),
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            ListTile(
              title: Text(
                "Data Personil",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
              ),
            ),
            Divider(
              thickness: 2,
              color: Colors.grey,
              indent: 8,
              endIndent: 8,
            ),
            Column(
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      flex: 7,
                      child: Container(
                        padding: EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "NAMA",
                              style:
                                  TextStyle(fontSize: 14, color: Colors.black),
                            ),
                            Text(
                              data.nmpeg,
                              textAlign: TextAlign.left,
                              style:
                                  TextStyle(fontSize: 14, color: Colors.black),
                            ),
                            Divider(
                              thickness: 0.1,
                            ),
                            Text(
                              "NRP/NIP",
                              style:
                                  TextStyle(fontSize: 14, color: Colors.black),
                            ),
                            Text(
                              data.nrp,
                              textAlign: TextAlign.left,
                              style:
                                  TextStyle(fontSize: 14, color: Colors.black),
                            ),
                            Divider(
                              thickness: 1.5,
                            )
                          ],
                        ),
                      ),
                    ),
                    // Expanded(
                    //   flex: 3,
                    //   child: Container(
                    //     child: Image.asset(
                    //       "assets/images/polisi.jpg",
                    //       height: 100,
                    //       width: 100,
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
                _buildDetail(data),
                _buildDetail1("Jabatan", data.sebutjab),
                _buildDetail1("SATKER", data.nmsatker),
                _buildDetail1("POLDA", data.nmuappaw),
                _buildDetail1("NPWP", data.npwp),
                _buildDetail1("NO REKENING", data.rekening),
                _buildDetail1("NAMA BANK", data.nmBank),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetail(UserInfoData data) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                flex: 5,
                child: Text(
                  "PANGKAT",
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 14,
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child: Text(
                  data.nmgol1,
                  style: TextStyle(
                    color: Colors.orange,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetail1(String tag, String value) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                flex: 5,
                child: Text(
                  tag,
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 14,
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child: Text(
                  value,
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: TextButton(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (context) {
                return BottomPageNew(
                  saveBulanTahun: _saveBulanTahun,
                  paramBulan: bulan,
                  paramTahun: tahun,
                );
              });
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.tune_sharp,
              color: Color(0xFF3D465A),
            ),
            SizedBox(
              width: 9,
            ),
            Text(
              "Filter",
              style: TextStyle(
                color: Color(0xFF3D465A),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class TextFormat {
  static String simpleCurrency(String value) {
    var data = int.parse(value);
    final numberformat = new NumberFormat(
      "#,###.##",
      "id",
    );
    return numberformat.format(data).toString();
  }
}

class TextShowBulan {
  static showBulan(String value) {
    if (value == '01') {
      return 'Januari';
    } else if (value == '02') {
      return 'Februari';
    } else if (value == '03') {
      return 'Maret';
    } else if (value == '04') {
      return 'April';
    } else if (value == '05') {
      return 'Mei';
    } else if (value == '06') {
      return 'Juni';
    } else if (value == '07') {
      return 'Juli';
    } else if (value == '08') {
      return 'Agustus';
    } else if (value == '09') {
      return 'September';
    } else if (value == '10') {
      return 'Oktober';
    } else if (value == '11') {
      return 'November';
    } else if (value == '12') {
      return 'Desember';
    }
  }
}

class ChangeColorData {
  static changeColor(String value) {
    if (value == '0') {
      return Colors.red;
    } else {
      return Colors.black54;
    }
  }
}
