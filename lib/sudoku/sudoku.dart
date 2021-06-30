import 'package:flutter/material.dart';

import 'game.dart';

class Sudoku extends StatefulWidget {
  const Sudoku({Key? key}) : super(key: key);

  @override
  _SudokuState createState() => _SudokuState();
}

class _SudokuState extends State<Sudoku> {
  int _selectedSquare = -1;
  _setSelectedSquare(i) {
    setState(() {
      _selectedSquare = i;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Puzzle 1",textAlign: TextAlign.center, style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),),
        Game(_selectedSquare, _setSelectedSquare),
        Text("selected square is " + _selectedSquare.toString(), textAlign: TextAlign.center, style: TextStyle(fontSize: 24),),
      ],
    );
  }
}
