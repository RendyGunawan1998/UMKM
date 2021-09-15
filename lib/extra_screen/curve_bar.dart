import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:puskeu/page/profile/profile.dart';
import 'package:puskeu/page/scan/scan.dart';
import 'package:puskeu/page/search/search_page.dart';
import 'package:puskeu/penerima/penerima.dart';

class CurveBar extends StatefulWidget {
  _CurveBarState createState() => _CurveBarState();
}

class _CurveBarState extends State<CurveBar> {
  int _pageIndex = 0;

  final SearchPage _search = SearchPage();
  // final ScanPage _scan = ScanPage();
  final PenerimaPage _penerima = PenerimaPage();

  final ProfilePage _profile = ProfilePage();

  Widget _tampilPageIndex = new SearchPage();

  Widget _choosenPage(int page) {
    switch (page) {
      case 0:
        return _search;
        break;
      // case 1:
      //   return _scan;
      //   break;
      case 1:
        return _penerima;
        break;
      case 2:
        return _profile;
        break;
      default:
        return Container(
          child: Center(
            child: Text(
              'No Page Has Selected',
              style: TextStyle(fontSize: 20),
            ),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        height: 50,
        index: _pageIndex,
        items: <Widget>[
          Icon(
            Icons.search,
            color: Colors.black,
          ),
          // Icon(
          //   Icons.camera,
          //   color: Colors.black,
          // ),
          Icon(
            Icons.person_add,
            color: Colors.black,
          ),
          CircleAvatar(
            backgroundColor: Colors.transparent,
            child: Icon(
              Icons.person,
              color: Colors.black,
            ),
            radius: 14,
          ),
        ],
        color: Colors.brown[400],
        buttonBackgroundColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        animationCurve: Curves.bounceInOut,
        animationDuration: Duration(milliseconds: 100),
        onTap: (int tappedIndex) {
          setState(() {
            _tampilPageIndex = _choosenPage(tappedIndex);
          });
        },
      ),
      body: Container(
        child: _tampilPageIndex,
      ),
    );
  }
}
