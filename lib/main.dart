import 'package:flutter/material.dart';

import 'myAppBar.dart';
import 'homePage.dart';
import 'sudoku/sudoku.dart';

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
        '/': (context) => HomePage(),
        '/sudoku': (context) => Sudoku(),
      },
    );
  }
}
