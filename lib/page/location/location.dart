import 'package:flutter/material.dart';
import 'package:location/location.dart';

class LocationPage extends StatefulWidget {
  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  Location location = new Location();
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;
  // bool _isListenLocation = false;
  bool _isGetLocation = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            // color: Colors.blueGrey[200],
          ),
          child: Text("Location"),
        ),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                _serviceEnabled = await location.serviceEnabled();
                if (!_serviceEnabled) {
                  _serviceEnabled = await location.requestService();
                  if (_serviceEnabled) return;
                }

                _permissionGranted = await location.hasPermission();
                if (_permissionGranted == PermissionStatus.denied) {
                  _permissionGranted = await location.requestPermission();
                  if (_permissionGranted != PermissionStatus.granted) return;
                }
                _locationData = await location.getLocation();
                setState(() {
                  _isGetLocation = true;
                });
              },
              child: Text("Get Location"),
            ),
            _isGetLocation
                ? Text(
                    "Location: ${_locationData.latitude}/ ${_locationData.longitude}")
                : Container(),
            // ElevatedButton(
            //   onPressed: () async {
            //     _serviceEnabled = await location.serviceEnabled();
            //     if (!_serviceEnabled) {
            //       _serviceEnabled = await location.requestService();
            //       if (_serviceEnabled) return;
            //     }

            //     _permissionGranted = await location.hasPermission();
            //     if (_permissionGranted == PermissionStatus.denied) {
            //       _permissionGranted = await location.requestPermission();
            //       if (_permissionGranted != PermissionStatus.granted) return;
            //     }
            //     setState(() {
            //       _isListenLocation = true;
            //     });
            //   },
            //   child: Text("Change Location"),
            // ),
            // StreamBuilder(
            //   stream: location.onLocationChanged,
            //   builder: (context, snapshot) {
            //     if (snapshot.connectionState != ConnectionState.waiting) {
            //       var data = snapshot.data as LocationData;
            //       return Text(
            //           "Location alwayas change: \n ${data.latitude}/ ${data.longitude}");
            //     } else
            //       return Center(
            //         child: CircularProgressIndicator(),
            //       );
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}
