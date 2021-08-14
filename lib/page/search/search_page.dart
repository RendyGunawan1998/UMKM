import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:puskeu/model/nik.dart';
import 'package:puskeu/model/save_token.dart';
import 'package:puskeu/page/add_photo/photo.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  // int index = 0;
  // TextEditingController _controllerTxt = TextEditingController();

  // List<String> foodListSearch = [];
  // List<String> foodList = [
  //   'Orange',
  //   'Berries',
  //   'Lemons',
  //   'Apples',
  //   'Mangoes',
  //   'Dates',
  //   'Avocados',
  //   'Black Beans',
  //   'Chickpeas',
  //   'Pinto beans',
  //   'White Beans',
  //   'Green lentils',
  //   'Split Peas',
  //   'Rice',
  //   'Oats',
  //   'Quinoa',
  //   'Pasta',
  //   'Sparkling water',
  //   'Coconut water',
  //   'Herbal tea',
  //   'Kombucha',
  //   'Almonds',
  //   'Peannuts',
  //   'Chia seeds',
  //   'Flax seeds',
  //   'Canned tomatoes',
  //   'Olive oil',
  //   'Broccoli',
  //   'Onions',
  //   'Garlic',
  //   'Carots',
  //   'Leafy greens',
  //   'Meat',
  // ];

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Container(
  //         decoration: BoxDecoration(
  //           borderRadius: BorderRadius.circular(25),
  //           color: Colors.blueGrey[200],
  //         ),
  //         child: TextField(
  //           onChanged: (value) {
  //             setState(() {
  //               foodListSearch = foodList
  //                   .where((element) => element.contains(value.toLowerCase()))
  //                   .toList();
  //             });
  //           },
  //           controller: _controllerTxt,
  //           decoration: InputDecoration(
  //             border: InputBorder.none,
  //             errorBorder: InputBorder.none,
  //             enabledBorder: InputBorder.none,
  //             focusedBorder: InputBorder.none,
  //             contentPadding: EdgeInsets.all(15),
  //             hintText: "Search NIP",
  //           ),
  //         ),
  //       ),
  //       actions: [
  //         TextButton(
  //           onPressed: () {
  //             _controllerTxt.clear();
  //           },
  //           child: Icon(
  //             Icons.close,
  //             color: Colors.red,
  //           ),
  //         ),
  //       ],
  //     ),
  //     body: ListView.builder(
  //         itemCount: foodList.length,
  //         itemBuilder: (context, index) {
  //           return Padding(
  //             padding: const EdgeInsets.all(10),
  //             child: Column(
  //               children: [
  //                 ListTile(
  //                   leading: CircleAvatar(
  //                     child: Icon(Icons.person),
  //                   ),
  //                   title: Text(
  //                     foodList[index],
  //                     style:
  //                         TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
  //                   ),
  //                   trailing: IconButton(
  //                       onPressed: () {
  //                         Get.to(PhotoPage());
  //                       },
  //                       icon: Icon(Icons.add)),
  //                 ),
  //               ],
  //             ),
  //           );
  //         }),
  //   );
  // }

  // Widget _noData(BuildContext context) {
  //   return Center(
  //     child: Container(
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           Container(
  //             padding: EdgeInsets.fromLTRB(60, 120, 50, 0),
  //             child: Image.asset(
  //               "assets/images/no_data.png",
  //               width: 150,
  //               height: 100,
  //               fit: BoxFit.fill,
  //             ),
  //           ),
  //           Padding(
  //             padding: EdgeInsets.fromLTRB(30, 5, 20, 50),
  //             child: Column(
  //               children: [
  //                 Text("Tidak ada data"),
  //                 Text("Data yang dicari tidak ada"),
  //               ],
  //             ),
  //           )
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Future<Nik> futureNik;
  List<Nik> _list = [];
  List<Nik> _search = [];
  var loading = false;

  TextEditingController _controller = TextEditingController();

  Future<void> fetchList() async {
    setState(() {
      loading = true;
    });
    _list.clear();
    final response = await http.get(Uri.parse(
        "https://app.puskeu.polri.go.id:2216/umkm/mobile/penerima/cari_nik/2125"));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        for (Map i in data) {
          _list.add(Nik.fromJson(i));
          loading = false;
        }
      });
    } else {
      Container(
        height: MediaQuery.of(context).size.height * 0.95,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }

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
      // final data = jsonDecode(response.body);
      // setState(() {
      //   for (Map i in data) {
      //     _list.add(Nik.fromJson(i));
      //     loading = false;
      //   }
      // });
      print('Token: ' + response.body);
      // return Nik.fromJson(jsonDecode(response.body));
    } else {
      Container(
        height: MediaQuery.of(context).size.height * 0.95,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }

  onSearch(String text) async {
    _search.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }
    _list.forEach((f) {
      if (f.nik.contains(text)) _search.add(f);
    });

    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    futureNik = fetchNIK();
    // fetchList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: FutureBuilder<Nik>(
          future: futureNik,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return _buildBody(snapshot.data);
            } else if (snapshot.hasError) {
              return Text("error");
            }
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }

  // Widget _buildBody(Nik data) {
  //   return Container(
  //       child: Column(
  //     children: [
  //       Container(
  //         padding: EdgeInsets.all(10),
  //         color: Colors.blue,
  //         child: Card(
  //           child: ListTile(
  //             leading: Icon(Icons.search),
  //             title: TextField(
  //               controller: _controller,
  //               onChanged: onSearch,
  //               decoration: InputDecoration(
  //                 hintText: "Cari NIK",
  //                 border: InputBorder.none,
  //               ),
  //             ),
  //             trailing: IconButton(
  //                 onPressed: () {
  //                   _controller.clear();
  //                   onSearch("");
  //                 },
  //                 icon: Icon(Icons.cancel)),
  //           ),
  //         ),
  //       ),
  //       loading
  //           ? Center(
  //               child: CircularProgressIndicator(),
  //             )
  //           : Expanded(
  //               child: _search.length != 0 || _controller.text.isNotEmpty
  //                   ? ListView.builder(
  //                       itemCount: _search.length,
  //                       itemBuilder: (context, i) {
  //                         final b = _search[i];
  //                         return Container(
  //                             padding: EdgeInsets.all(10.0),
  //                             child: Column(
  //                               crossAxisAlignment: CrossAxisAlignment.start,
  //                               children: <Widget>[
  //                                 Text(
  //                                   b.nik,
  //                                   style: TextStyle(
  //                                       fontWeight: FontWeight.bold,
  //                                       fontSize: 18.0),
  //                                 ),
  //                                 SizedBox(
  //                                   height: 4.0,
  //                                 ),
  //                                 Text(b.nomorhp),
  //                               ],
  //                             ));
  //                       },
  //                     )
  //                   : ListView.builder(
  //                       itemCount: _list.length,
  //                       itemBuilder: (context, i) {
  //                         final a = _list[i];
  //                         return Container(
  //                             padding: EdgeInsets.all(10.0),
  //                             child: ListTile(
  //                               title: Text(
  //                                 a.nik,
  //                                 style: TextStyle(
  //                                     fontWeight: FontWeight.bold,
  //                                     fontSize: 18.0),
  //                               ),
  //                               trailing: IconButton(
  //                                   onPressed: () {
  //                                     Get.to(PhotoPage());
  //                                   },
  //                                   icon: Icon(Icons.add)),
  //                             ));
  //                       },
  //                     ),
  //             ),
  //     ],
  //   ));
  // }

  Widget _buildBody(Nik data) {
    return Column(children: <Widget>[
      _buildNik(data),
    ]);
  }

  Widget _buildNik(Nik data) {
    return ListTile(
      leading: Icon(Icons.person),
      title: Text(data.nik),
      subtitle: Text(data.nomorhp),
    );
  }
}
