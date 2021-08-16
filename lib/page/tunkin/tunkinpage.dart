// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:intl/intl.dart';
// import 'package:puskeu/extra_screen/filter.dart';
// import 'package:puskeu/extra_screen/loading.dart';
// import 'package:puskeu/model/data.dart';
// import 'package:puskeu/get_data/fetch.dart';
// import 'package:puskeu/model/save_token.dart';
// import 'package:puskeu/model/tunkin.dart';
// import 'package:puskeu/page/tunkin/tunkin_bloc/tunkin_bloc.dart';
// import 'package:puskeu/widgets/errors/loaddata_error.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class TunkinPage extends StatefulWidget {
//   _TunkinPageState createState() => _TunkinPageState();
// }

// class _TunkinPageState extends State<TunkinPage> {
//   final TunkinBloc _tunkinBloc = TunkinBloc(tunkinrepo: TunkinRepo());
//   Future<UserInfoData> futureUser;
//   final formkey = new GlobalKey<FormState>();

//   // params untuk filtering
//   String bulan;
//   String tahun;
//   List<String> bulanTahun = [];

//   void cekBT() async {
//     // get bulan tahun from shared preference
//     var token = await Token().getBulanTahun('bulanTahun');
//     // print("$token");
//     if (token != null) {
//       // print("$res");
//       setState(() {
//         bulan = token[0];
//         tahun = token[1];
//       });
//     } else {
//       // print("Null");
//       setState(() {
//         bulan = getCurrentMonth();
//         tahun = getCurrentYear();
//       });
//     }
//     _tunkinBloc.add(TunkinUpdate(bulan: bulan, tahun: tahun));
//   }

//   @override
//   void initState() {
//     super.initState();
//     getDataFilter();
//     // removeParamBulanTahun();
//     // cekBT();
//     futureUser = fetchData();
//     // cara manggil event bloc
//     _tunkinBloc.add(TunkinFetch(
//       bulan: bulan,
//       tahun: tahun,
//     ));
//   }

//   static String getCurrentYear() {
//     String formattedDate = DateFormat('yyyy').format(DateTime.now());
//     return formattedDate;
//   }

//   static String getCurrentMonth() {
//     String formattedDate = DateFormat('MM').format(DateTime.now());
//     return formattedDate;
//   }

//   Future<void> getDataFilter() async {
//     setState(() {
//       tahun = getCurrentYear();
//       bulan = getCurrentMonth();
//     });
//   }

//   removeParamBulanTahun() async {
//     // digunakan untuk clear SP bulanTahun
//     SharedPreferences pref = await SharedPreferences.getInstance();
//     pref.remove('bulanTahun');
//   }

//   void _saveBulanTahun(String _paramBulan, String _paramTahun) {
//     print("bulan: $_paramBulan");
//     print("tahun: $_paramTahun");
//     setState(() {
//       bulan = _paramBulan;
//       tahun = _paramTahun;
//     });
//     futureUser = fetchData();
//     _tunkinBloc.add(TunkinUpdate(bulan: bulan, tahun: tahun));

//     Token().saveBulanTahun('bulanTahun', [_paramBulan, _paramTahun]);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         flexibleSpace: Container(
//           decoration: BoxDecoration(
//               gradient: LinearGradient(
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                   colors: [Colors.blueGrey[200], Colors.blueGrey[100]])),
//         ),
//         // backgroundColor: Colors.blueGrey[200],
//         elevation: 0,
//         title: Row(
//           children: <Widget>[
//             Image.asset(
//               "assets/images/presisi.png",
//               width: 200,
//             ),
//           ],
//         ),
//       ),
//       body: BlocProvider(
//         create: (context) => TunkinBloc(
//           tunkinrepo: TunkinRepo(),
//         ),
//         child: BlocBuilder<TunkinBloc, TunkinState>(
//           bloc: _tunkinBloc,
//           builder: (context, state) {
//             if (state is TunkinOnFailure) {
//               //error
//               return LoadDataError(
//                 subtitle: state.dataError.message,
//               );
//             }
//             //hasData
//             if (state is TunkinDataLoaded) {
//               if (state.tunkin.isEmpty) {
//                 return Center(
//                   child: Container(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Container(
//                           padding: EdgeInsets.fromLTRB(60, 120, 50, 0),
//                           child: Image.asset(
//                             "assets/images/no_data.png",
//                             width: 150,
//                             height: 100,
//                             fit: BoxFit.fill,
//                           ),
//                         ),
//                         Padding(
//                           padding: EdgeInsets.fromLTRB(30, 5, 20, 50),
//                           child: Column(
//                             children: [
//                               Text("No Data"),
//                               Text("Data Tunkin bulan ini belum diproses"),
//                             ],
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                 );
//                 // return Text('No Data');
//               }
//               return _buildBody(state.tunkin[0]);
//             }
//             return const Center(child: CircularProgressIndicator());
//           },
//         ),
//       ),
//       bottomNavigationBar: _buildBottomBar(),
//     );
//   }

//   Widget _buildBody(Tunkin data1) {
//     return ListView(
//       shrinkWrap: true,
//       children: [
//         _buildDetailProfile(data1),
//         SizedBox(
//           height: 10,
//         ),
//         Container(
//           width: double.infinity,
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(25),
//               topRight: Radius.circular(25),
//               bottomLeft: Radius.circular(25),
//               bottomRight: Radius.circular(25),
//             ),
//           ),
//           child: SingleChildScrollView(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: <Widget>[
//                 _buildTunkinBersih(data1),
//                 _buildDetailTunkin(data1),
//                 _buildItemTunkin("Kelas Jabatan", data1.klasjabatan.toString()),
//                 _buildDataTunkin("Nilai Tunkin", data1.nilaitunkin),
//                 _buildDataTunkin("POT TUNKIN", data1.potongantunkin),
//               ],
//             ),
//           ),
//         )
//       ],
//     );
//     // Column(
//     //   children: <Widget>[

//     //     Divider(
//     //       thickness: 1.5,
//     //       indent: 10,
//     //       endIndent: 10,
//     //     ),
//     //   ],
//     // );
//   }

//   Widget _buildDetailProfile(Tunkin data1) {
//     var nameInitial = data1?.nmpeg[0]?.toUpperCase() ?? "";
//     if (data1.nmpeg == null) {
//       nameInitial = "";
//     }
//     return Card(
//       color: Colors.white,
//       elevation: 0,
//       child: ListTile(
//         title: Text(
//           data1?.nmpeg ?? "",
//           style: TextStyle(color: Colors.black),
//         ),
//         subtitle: Text(
//           data1?.nrp ?? "",
//           style: TextStyle(color: Colors.black),
//         ),
//         leading: CircleAvatar(
//           radius: 22,
//           child: Text(
//             // data1?.nmpeg[0][1].toUpperCase() ?? "",
//             nameInitial,
//             textAlign: TextAlign.center,
//             style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
//           ),
//           backgroundColor: Colors.orange,
//         ),
//         trailing: TextButton(
//             onPressed: () {
//               showModalBottomSheet(
//                   context: context,
//                   isScrollControlled: true,
//                   builder: (context) {
//                     LoadingScreen();
//                     return _detailListViewTunkin();
//                   });
//             },
//             child: Text(
//               "DETAILS",
//               style: TextStyle(color: Colors.blue),
//             )),
//       ),
//     );

//     // Container(
//     //   padding: EdgeInsets.all(5),
//     //   margin: EdgeInsets.all(5),
//     //   child: ListTile(
//     //     title: Text(
//     //       data1.nmpeg,
//     //       style: TextStyle(color: Colors.black),
//     //     ),
//     //     subtitle: Text(data1.nrp),
//     //     leading: CircleAvatar(
//     //       backgroundColor: Colors.deepOrange[300],
//     //       radius: 22,
//     //       child: Text(
//     //         data1.nmpeg[0].toUpperCase(),
//     //         textAlign: TextAlign.center,
//     //         style: TextStyle(
//     //             color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
//     //       ),
//     //     ),
//     //     trailing: FlatButton(
//     //         onPressed: () {
//     //           showModalBottomSheet(
//     //               context: context,
//     //               isScrollControlled: true,
//     //               builder: (context) {
//     //                 return _detailListViewTunkin();
//     //               });
//     //         },
//     //         child: Text(
//     //           "DETAILS",
//     //           style: TextStyle(color: Colors.blue),
//     //         )),
//     //   ),
//     // );
//   }

//   Widget _detailListViewTunkin() {
//     return FutureBuilder<UserInfoData>(
//       future: futureUser,
//       builder: (context, snapshot) {
//         if (snapshot.hasError) {
//           return Text(
//             '${snapshot.error}',
//             style: TextStyle(color: Colors.red),
//           );
//         } else if (snapshot.hasData) {
//           return _detailPersonil(snapshot.data);
//         } else {
//           return Center(child: CircularProgressIndicator());
//         }
//       },
//     );
//   }

//   Widget _detailPersonil(UserInfoData data) {
//     return Container(
//       height: MediaQuery.of(context).size.height * .60,
//       child: Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(30),
//             topRight: Radius.circular(30),
//           ),
//           color: Colors.white,
//         ),
//         child: ListView(
//           shrinkWrap: true,
//           children: <Widget>[
//             SizedBox(
//               height: 10,
//             ),
//             ListTile(
//               title: Text(
//                 "Data Personil",
//                 style: TextStyle(color: Colors.black),
//               ),
//               leading: IconButton(
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//                 icon: Icon(Icons.arrow_back, color: Colors.black),
//               ),
//             ),
//             Divider(
//               thickness: 2,
//               color: Colors.grey,
//               indent: 8,
//               endIndent: 8,
//             ),
//             Column(
//               children: <Widget>[
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     Expanded(
//                       flex: 7,
//                       child: Container(
//                         padding: EdgeInsets.all(15),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: <Widget>[
//                             Text(
//                               "NAMA",
//                               style:
//                                   TextStyle(fontSize: 14, color: Colors.black),
//                             ),
//                             Text(
//                               data.nmpeg,
//                               textAlign: TextAlign.left,
//                               style:
//                                   TextStyle(fontSize: 14, color: Colors.black),
//                             ),
//                             Divider(
//                               thickness: 0.1,
//                             ),
//                             Text(
//                               "NRP/NIP",
//                               style:
//                                   TextStyle(fontSize: 14, color: Colors.black),
//                             ),
//                             Text(
//                               data.nrp,
//                               textAlign: TextAlign.left,
//                               style:
//                                   TextStyle(fontSize: 14, color: Colors.black),
//                             ),
//                             Divider(
//                               thickness: 1.5,
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     // Expanded(
//                     //   flex: 3,
//                     //   child: Container(
//                     //     child: Image.asset(
//                     //       "assets/images/polisi.jpg",
//                     //       height: 100,
//                     //       width: 100,
//                     //     ),
//                     //   ),
//                     // ),
//                   ],
//                 ),
//                 _buildDetailDataPersonil("PANGKAT", data.nmgol1),
//                 _buildDetailDataPersonil2("JABATAN", data.sebutjab),
//                 _buildDetailDataPersonil2("SATKER", data.nmsatker),
//                 _buildDetailDataPersonil2("POLDA", data.nmuappaw),
//                 _buildDetailDataPersonil2("NPWP", data.npwp),
//                 _buildDetailDataPersonil2("NO REKENING", data.rekening),
//                 _buildDetailDataPersonil2("NAMA BANK", data.nmBank),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildDetailDataPersonil(String tag, String value) {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
//       child: Column(
//         children: <Widget>[
//           Row(
//             children: <Widget>[
//               Expanded(
//                 flex: 5,
//                 child: Text(
//                   tag,
//                   style: TextStyle(
//                     color: Colors.black54,
//                     fontSize: 14,
//                   ),
//                 ),
//               ),
//               Expanded(
//                 flex: 5,
//                 child: Text(
//                   value,
//                   style: TextStyle(fontSize: 14, color: Colors.orange),
//                   textAlign: TextAlign.right,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDetailDataPersonil2(String tag, String value) {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
//       child: Column(
//         children: <Widget>[
//           Row(
//             children: <Widget>[
//               Expanded(
//                 flex: 5,
//                 child: Text(
//                   tag,
//                   style: TextStyle(
//                     color: Colors.black54,
//                     fontSize: 14,
//                   ),
//                 ),
//               ),
//               Expanded(
//                 flex: 5,
//                 child: Text(
//                   value,
//                   style: TextStyle(
//                     fontSize: 14,
//                   ),
//                   textAlign: TextAlign.right,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildTunkinBersih(Tunkin data1) {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(10, 0, 10, 5),
//       child: Container(
//         padding: EdgeInsets.all(15),
//         decoration: BoxDecoration(
//           color: Colors.deepPurple,
//           //border: Border.all(),
//           borderRadius: BorderRadius.circular(20),
//         ),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                 Text(
//                   "Tunkin Bersih",
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 16,
//                   ),
//                 ),
//                 SizedBox(
//                   height: 5,
//                 ),
//                 Text(
//                   NumberFormat.simpleCurrency(
//                           locale: 'id', name: 'Rp ', decimalDigits: 0)
//                       .format(data1.bersih),
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 32,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildDetailTunkin(Tunkin data1) {
//     return Padding(
//       padding: const EdgeInsets.all(10),
//       child: Card(
//         child: Container(
//           height: 60,
//           color: Colors.grey.shade300,
//           padding: EdgeInsets.symmetric(horizontal: 8),
//           child: Row(
//             children: <Widget>[
//               Expanded(
//                 flex: 4,
//                 child: Text(
//                   "Detail Tunkin",
//                   style: TextStyle(
//                     color: Colors.black87,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 18,
//                   ),
//                 ),
//               ),
//               Expanded(
//                 flex: 6,
//                 child: Text(
//                   TextShowBulan.showBulan(data1.bulan) +
//                       " - " +
//                       data1.tahun.toString(),
//                   style: TextStyle(
//                     color: Colors.black87,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 18,
//                   ),
//                   textAlign: TextAlign.right,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildItemTunkin(String tag, String value) {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(20, 7, 20, 5),
//       child: Column(
//         children: <Widget>[
//           Row(
//             children: <Widget>[
//               Expanded(
//                 flex: 4,
//                 child: Text(
//                   tag,
//                   style: TextStyle(
//                     color: Colors.black54,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 16,
//                   ),
//                 ),
//               ),
//               Expanded(
//                 flex: 6,
//                 child: Text(
//                   value,
//                   style: TextStyle(
//                     color: Colors.black54,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 16,
//                   ),
//                   textAlign: TextAlign.right,
//                 ),
//               )
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDataTunkin(String tag, int value) {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(20, 7, 20, 5),
//       child: Column(
//         children: <Widget>[
//           Row(
//             children: <Widget>[
//               Expanded(
//                 flex: 4,
//                 child: Text(
//                   tag,
//                   // "Nilai Tunkin",
//                   style: TextStyle(
//                     color: Colors.black54,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 16,
//                   ),
//                 ),
//               ),
//               Expanded(
//                 flex: 6,
//                 child: Text(
//                   NumberFormat.simpleCurrency(
//                           locale: 'id', name: 'Rp ', decimalDigits: 0)
//                       .format(value),
//                   style: TextStyle(
//                     color: Colors.black54,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 16,
//                   ),
//                   textAlign: TextAlign.right,
//                 ),
//               )
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildBottomBar() {
//     return Container(
//       height: 40,
//       decoration: BoxDecoration(
//         color: Colors.transparent,
//       ),
//       child: TextButton(
//         onPressed: () {
//           showModalBottomSheet(
//               context: context,
//               builder: (context) {
//                 return BottomPageNew(
//                   saveBulanTahun: _saveBulanTahun,
//                   paramBulan: bulan,
//                   paramTahun: tahun,
//                 );
//               });
//         },
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Icon(
//               Icons.tune_sharp,
//               color: Color(0xFF3D465A),
//             ),
//             SizedBox(
//               width: 9,
//             ),
//             Text(
//               "Filter",
//               style: TextStyle(
//                 color: Color(0xFF3D465A),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class TextShowBulan {
//   static showBulan(int value) {
//     if (value == 01) {
//       return 'Januari';
//     } else if (value == 02) {
//       return 'Februari';
//     } else if (value == 03) {
//       return 'Maret';
//     } else if (value == 04) {
//       return 'April';
//     } else if (value == 05) {
//       return 'Mei';
//     } else if (value == 06) {
//       return 'Juni';
//     } else if (value == 07) {
//       return 'Juli';
//     } else if (value == 08) {
//       return 'Agustus';
//     } else if (value == 09) {
//       return 'September';
//     } else if (value == 10) {
//       return 'Oktober';
//     } else if (value == 11) {
//       return 'November';
//     } else
//       return 'Desember';
//   }
// }
