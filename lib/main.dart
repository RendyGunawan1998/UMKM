import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:puskeu/bloc/simple_bloc_observer.dart';
import 'package:puskeu/extra_screen/puskeu_splash.dart';
import 'package:get/get.dart';

void main() {
  Bloc.observer = SimpleBlocObserver();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: PuskeuSplash(),
      // theme: ThemeData(canvasColor: Colors.transparent),
    );
  }
}

// class LoginPage extends StatefulWidget {
//   _LoginPageState createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   GlobalKey<FormState> formKey = GlobalKey<FormState>();

//   bool _obsecureText = true;

//   TextEditingController userTC = new TextEditingController();
//   TextEditingController passTC = new TextEditingController();

//   LoginRequestModel requestModel;
//   bool isApiCall = false;

//   String message = '';

//   @override
//   void initState() {
//     super.initState();
//     // cekLogin();
//     requestModel = new LoginRequestModel();
//   }

//   void cekLogin() async {
//     // get token from local storage
//     var token = await Token().getAccessToken();
//     print("token : $token");
//     if (token != null) {
//       Get.offAll(() => CurveBar());
//     }
//   }

//   void dispose() {
//     userTC.dispose();
//     passTC.dispose();
//     super.dispose();
//   }

//   String validatePassword(value) {
//     if (value.isEmpty) {
//       return "Password can't be empty";
//     } else if (value.length <= 7) {
//       return "Password to short, please make 7 character";
//     } else {
//       return null;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       resizeToAvoidBottomInset: true,
//       body: Padding(
//         padding: const EdgeInsets.only(top: 60),
//         child: Stack(
//           fit: StackFit.expand,
//           children: <Widget>[
//             Column(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: <Widget>[
//                 _buildBGPolisi(),
//               ],
//             ),
//             SingleChildScrollView(
//               padding: EdgeInsets.all(10),
//               child: _buildFormLogin(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildBGPolisi() {
//     return Opacity(
//       opacity: 0.5,
//       child: Image.asset(
//         "assets/images/bg.png",
//         width: 600,
//         height: 300,
//       ),
//     );
//   }

//   Widget _buildFormLogin() {
//     return Column(
//       children: <Widget>[
//         Image.asset(
//           "assets/images/puskeu.png",
//           width: 120,
//         ),
//         SizedBox(
//           height: 10,
//         ),
//         Text(
//           "GAJI DAN TUNKIN",
//           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//         ),
//         SizedBox(height: 35),
//         Form(
//           key: formKey,
//           child: Container(
//             padding: EdgeInsets.all(10),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               //border: Border.all(),
//               borderRadius: BorderRadius.circular(15),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey,
//                   blurRadius: 20,
//                   // offset: Offset(10, 10),
//                 ),
//                 BoxShadow(
//                   color: Colors.grey,
//                   blurRadius: 20,
//                   // offset: Offset(10, 10),
//                 ),
//               ],
//             ),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: <Widget>[
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: <Widget>[
//                     Text(
//                       "Login",
//                       style:
//                           TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
//                       textAlign: TextAlign.left,
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 30),
//                 TextFormField(
//                   decoration: InputDecoration(
//                       hintText: "Masukkan NRP/NIP",
//                       labelText: "NRP/NIP",
//                       prefixIcon: Icon(
//                         Icons.person,
//                         color: Colors.blue[900],
//                       ),
//                       border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(20))),
//                   validator: RequiredValidator(errorText: 'NRP/NIP required'),
//                   controller: userTC,
//                   onSaved: (value) => requestModel.email = value,
//                 ),
//                 SizedBox(height: 15),
//                 TextFormField(
//                   decoration: InputDecoration(
//                     labelText: "Password",
//                     hintText: "Masukkan Kata Sandi",
//                     prefixIcon: Icon(Icons.lock, color: Colors.blue[900]),
//                     suffixIcon: IconButton(
//                       icon: Icon(
//                         _obsecureText ? Icons.visibility_off : Icons.visibility,
//                         color: Colors.blue[900],
//                       ),
//                       onPressed: () {
//                         setState(() {
//                           _obsecureText = !_obsecureText;
//                         });
//                       },
//                     ),
//                     border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(20)),
//                   ),
//                   obscureText: _obsecureText,
//                   validator: validatePassword,
//                   controller: passTC,
//                   onSaved: (value) => requestModel.password = value,
//                 ),
//                 SizedBox(height: 20),
//               ],
//             ),
//           ),
//         ),
//         SizedBox(
//           height: 20,
//         ),
//         _buildButtonLogin(),
//         SizedBox(
//           height: 20,
//         ),
//         OutlinedButton(
//           onPressed: () {
//             Get.offAll(() => CardPage());
//           },
//           child: Text(
//             'Task',
//             style: TextStyle(color: Colors.black),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildButtonLogin() {
//     return MaterialButton(
//       onPressed: () {
//         try {
//           testLogin();
//         } catch (e) {
//           print(e);
//           setState(() {
//             message = 'Login Failed';
//           });
//         }
//       },
//       color: Colors.blueAccent,
//       child: Text(
//         "LOGIN",
//         style: TextStyle(color: Colors.white, fontSize: 20),
//       ),
//     );
//   }

//   void testLogin() async {
//     if (formKey.currentState.validate()) {
//       formKey.currentState.save();
//       print("validate success");
//       var email = userTC.text;
//       print('Email :' + email);
//       var password = passTC.text;
//       print('Pass :' + password);
//       try {
//         var rsp = await loginUser(email, password);
//         print(rsp);
//         // get user data from API
//         await getUserInfo();

//         Get.offAll(() => LoadingScreen());
//       } catch (e) {
//         print(e);
//       }
//     } else {
//       print("validate unsuccess");
//       Get.to(LoginPage());
//     }
//   }
// }
