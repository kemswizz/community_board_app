import 'package:flutter/material.dart';
import 'package:flutter_board_app_firebase/pages/home.dart';
import 'package:firebase_core/firebase_core.dart';
void main()  async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(new MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primaryColor: Colors.amber
    ),
    home: BoardApp()
  ));
}
