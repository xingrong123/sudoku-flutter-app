import 'package:flutter/material.dart';

import 'components/homePage.dart';
import 'components/sudoku/sudoku.dart';
import 'components/startPage.dart';
import 'components/registerPage.dart';
import 'components/loginPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(canvasColor: Color(0xff272537)),
      title: "Sudoku App",
      initialRoute: '/',
      routes: {
        StartPage.routeName: (context) => StartPage(),
        LoginPage.routeName: (context) => LoginPage(),
        RegisterPage.routeName: (context) => RegisterPage(),
        HomePage.routeName: (context) => HomePage(),
        Sudoku.routeName: (context) => Sudoku(),
      },
    );
  }
}
