import 'package:flutter/material.dart';

class LoadDataError extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color bgColor;
  final Function onTap;

  const LoadDataError(
      {Key key, this.title, this.subtitle, this.bgColor, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 0, bottom: 0),
              child: CircleAvatar(
                radius: 28,
                child: Text(
                  ':(',
                  style: TextStyle(fontSize: 30),
                  textAlign: TextAlign.center,
                ),
                foregroundColor: Colors.white,
                backgroundColor: Colors.red,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, right: 10, left: 10),
              child: Text(
                title ?? "Oopss, Error",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Text.rich(
              TextSpan(text: subtitle ?? "Oopss, Error"),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
