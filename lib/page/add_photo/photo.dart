import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class PhotoPage extends StatefulWidget {
  @override
  _PhotoPageState createState() => _PhotoPageState();
}

class _PhotoPageState extends State<PhotoPage> {
  File _selectedImage;
  bool _inProgress = false;

  Widget getImageWidget() {
    if (_selectedImage != null) {
      return Image.file(
        _selectedImage,
        width: 100,
        height: 100,
        fit: BoxFit.cover,
      );
    } else {
      return Image.asset(
        "assets/images/no_data.png",
        width: 100,
        height: 100,
        fit: BoxFit.cover,
      );
    }
  }

  getImage(ImageSource source) async {
    setState(() {
      _inProgress = true;
    });
    File image = await ImagePicker.pickImage(source: source);
    if (image != null) {
      File cropped = await ImageCropper.cropImage(
          sourcePath: image.path,
          aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
          compressQuality: 100,
          maxHeight: 700,
          maxWidth: 700,
          compressFormat: ImageCompressFormat.jpg,
          androidUiSettings: AndroidUiSettings(
              toolbarColor: Colors.deepOrange.shade900,
              statusBarColor: Colors.deepOrange.shade900,
              backgroundColor: Colors.white,
              toolbarTitle: "Cropper"));
      this.setState(() {
        _selectedImage = cropped;
        _inProgress = false;
      });
    } else {
      setState(() {
        _inProgress = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print(_selectedImage?.lengthSync());
    return Scaffold(
        appBar: AppBar(
          title: Text("Click | Pick "),
        ),
        bottomNavigationBar: MaterialButton(
          color: Colors.blue,
          onPressed: () {},
          child: Text("Upload"),
        ),
        body: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                getImageWidget(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MaterialButton(
                      onPressed: () {
                        getImage(ImageSource.camera);
                      },
                      color: Colors.green,
                      child: Text("Camera"),
                    ),
                    MaterialButton(
                      color: Colors.green,
                      child: Text("Device"),
                      onPressed: () {
                        getImage(ImageSource.gallery);
                      },
                    ),
                  ],
                )
              ],
            ),
            (_inProgress)
                ? Container(
                    height: MediaQuery.of(context).size.height * 0.95,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : Center(),
          ],
        ));
  }
}
