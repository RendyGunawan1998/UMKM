// import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BottomPageNew extends StatefulWidget {
  // passing params and function
  final Function saveBulanTahun;
  final String paramBulan;
  final String paramTahun;

  BottomPageNew({
    this.saveBulanTahun,
    this.paramBulan,
    this.paramTahun,
  });

  _BottomPageNewState createState() => _BottomPageNewState();
}

class _BottomPageNewState extends State<BottomPageNew> {
  String currentBulan = "01";
  String currentTahun = "2021";

  List years = ["2021"];

  List<Map<String, dynamic>> dataBulan = [
    {"display": "Januari", "value": "01"},
    {"display": "Februari", "value": "02"},
    {"display": "Maret", "value": "03"},
    {"display": "April", "value": "04"},
    {"display": "Mei", "value": "05"},
    {"display": "Juni", "value": "06"},
    {"display": "Juli", "value": "07"},
    {"display": "Agustus", "value": "08"},
    {"display": "September", "value": "09"},
    {"display": "Oktober", "value": "10"},
    {"display": "November", "value": "11"},
    {"display": "Desember", "value": "12"},
  ];

  void getYears() {
    var now = new DateTime.now().year;
    List<int> abc = [];
    for (var i = 0; i <= 2; i++) {
      // print(year - i);
      abc.add(now - i);
    }

    years = abc.map((item) {
      return {
        "display": item.toString(),
        "value": item.toString(),
      };
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    getYears();

    currentBulan = widget.paramBulan;
    currentTahun = widget.paramTahun;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .60,
      padding: EdgeInsets.only(top: 5),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          color: Colors.white,
        ),
        child: _listView(),
      ),
    );
  }

  Widget _listView() {
    return ListView(
      children: <Widget>[
        ListTile(
          title: Text(
            "Filter",
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
          ),
          trailing: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.crop_free_outlined,
              color: Colors.lightGreen,
            ),
          ),
        ),
        Divider(
          thickness: 4,
          color: Colors.black26,
          indent: 7,
          endIndent: 7,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 25, 10, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 5,
                          child: DropdownButton(
                            dropdownColor: Colors.white,
                            isExpanded: true,
                            hint: Text('Select Month'),
                            value: currentBulan,
                            items: dataBulan.map((item) {
                              return DropdownMenuItem(
                                child: Text(item['display']),
                                value: item['value'],
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                currentBulan = value;
                              });
                            },
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: DropdownButton(
                            dropdownColor: Colors.white,
                            isExpanded: true,
                            hint: Text('Select Year'),
                            value: currentTahun,
                            items: years.map((item) {
                              return DropdownMenuItem(
                                child: Text(item['display']),
                                value: item['value'],
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                currentTahun = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Text("Month :  $currentBulan  / Year:   $currentTahun"),
            SizedBox(
              height: 50,
            ),
            // Text('$_bulanTahun'),
            SizedBox(
              width: 200,
              child: ElevatedButton(
                onPressed: () {
                  print(currentBulan);
                  print(currentTahun);
                  widget.saveBulanTahun(currentBulan, currentTahun);
                  Navigator.pop(context);
                },
                child: Text('Apply Filter'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
