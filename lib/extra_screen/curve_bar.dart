import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:puskeu/page/scan/scan.dart';
import 'package:puskeu/page/search/search_page.dart';

class CurveBar extends StatefulWidget {
  _CurveBarState createState() => _CurveBarState();
}

class _CurveBarState extends State<CurveBar> {
  int _pageIndex = 0;

  final SearchPage _search = SearchPage();
  final ScanPage _scan = ScanPage();
  // final ProfileNewDesign _profile = ProfileNewDesign();

  Widget _tampilPageIndex = new SearchPage();

  Widget _choosenPage(int page) {
    switch (page) {
      case 0:
        return _search;
        break;
      case 1:
        return _scan;
        break;
      // case 2:
      //   return _profile;
      //   break;
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
            color: Colors.white,
          ),
          Icon(
            Icons.camera,
            color: Colors.white,
          ),
          Icon(
            Icons.add_chart_rounded,
            color: Colors.white,
          ),
          // CircleAvatar(
          //   backgroundImage: AssetImage('assets/images/polisi.jpg'),
          //   radius: 14,
          // ),
        ],
        color: Colors.brown.shade200,
        buttonBackgroundColor: Colors.red[400],
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
