import 'package:flutter/material.dart';

import 'components/homePage.dart';
import 'components/sudoku/sudoku.dart';
import './components/startPage.dart';

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
      title: "Sudoku App",
      initialRoute: '/',
      routes: {
        StartPage.routeName: (context) => StartPage(),
        HomePage.routeName: (context) => HomePage(),
        Sudoku.routeName: (context) => Sudoku(),
      },
    );
  }
}
