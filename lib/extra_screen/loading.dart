import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:get/get.dart';
import 'package:puskeu/extra_screen/curve_bar.dart';

class LoadingScreen extends StatefulWidget {
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animationRotation;
  Animation<double> animationRadiusIn;
  Animation<double> animationRadiusOut;

  final double initialradius = 30;

  double radius = 0.0;

  @override
  void initState() {
    super.initState();
    loadingDurartion();

    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 3));

    animationRotation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
        parent: controller, curve: Interval(0.0, 1.0, curve: Curves.linear)));

    animationRadiusIn = Tween<double>(
      begin: 1,
      end: 0,
    ).animate(CurvedAnimation(
        parent: controller,
        curve: Interval(0.75, 1.0, curve: Curves.elasticIn)));

    animationRadiusOut = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
        parent: controller,
        curve: Interval(0.0, 0.25, curve: Curves.elasticOut)));

    controller.addListener(() {
      setState(() {
        if (controller.value >= 0.75 && controller.value <= 1.0) {
          radius = animationRadiusIn.value * initialradius;
        } else if (controller.value >= 0.0 && controller.value <= 0.25) {
          radius = animationRadiusOut.value * initialradius;
        }
      });
    });
    controller.repeat();
  }

  void dispose() {
    controller.dispose();
    super.dispose();
  }

  loadingDurartion() async {
    var duration = const Duration(seconds: 3);
    return Timer(duration, () {
      Get.offAll(() => CurveBar());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 100,
      width: 100,
      child: Stack(
        children: [
          RotationTransition(
            turns: animationRotation,
            child: Stack(
              children: <Widget>[
                Dot(
                  radius: 30,
                  color: Colors.black12,
                ),
                Transform.translate(
                  offset: Offset(radius * cos(pi / 4), radius * sin(pi / 4)),
                  child: Dot(
                    radius: 5,
                    color: Colors.redAccent,
                  ),
                ),
                Transform.translate(
                  offset: Offset(
                      radius * cos(2 * pi / 4), radius * sin(2 * pi / 4)),
                  child: Dot(
                    radius: 5,
                    color: Colors.greenAccent,
                  ),
                ),
                Transform.translate(
                  offset: Offset(
                      radius * cos(3 * pi / 4), radius * sin(3 * pi / 4)),
                  child: Dot(
                    radius: 5,
                    color: Colors.blueAccent,
                  ),
                ),
                Transform.translate(
                  offset: Offset(
                      radius * cos(4 * pi / 4), radius * sin(4 * pi / 4)),
                  child: Dot(
                    radius: 5,
                    color: Colors.purple,
                  ),
                ),
                Transform.translate(
                  offset: Offset(
                      radius * cos(5 * pi / 4), radius * sin(5 * pi / 4)),
                  child: Dot(
                    radius: 5,
                    color: Colors.amberAccent,
                  ),
                ),
                Transform.translate(
                  offset: Offset(
                      radius * cos(6 * pi / 4), radius * sin(6 * pi / 4)),
                  child: Dot(
                    radius: 5,
                    color: Colors.blue,
                  ),
                ),
                Transform.translate(
                  offset: Offset(
                      radius * cos(7 * pi / 4), radius * sin(7 * pi / 4)),
                  child: Dot(
                    radius: 5,
                    color: Colors.orangeAccent,
                  ),
                ),
                Transform.translate(
                  offset: Offset(
                      radius * cos(8 * pi / 4), radius * sin(8 * pi / 4)),
                  child: Dot(
                    radius: 5,
                    color: Colors.lightGreenAccent,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Dot extends StatelessWidget {
  final double radius;
  final Color color;

  Dot({Key key, this.radius, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: this.radius,
        height: this.radius,
        decoration: BoxDecoration(
          color: this.color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
