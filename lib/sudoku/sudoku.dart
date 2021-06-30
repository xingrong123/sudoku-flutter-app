import 'package:flutter/material.dart';

import '../myAppBar.dart';
import 'game.dart';
import 'controls.dart';

class Sudoku extends StatefulWidget {
  const Sudoku({Key? key}) : super(key: key);

  @override
  _SudokuState createState() => _SudokuState();
}

class _SudokuState extends State<Sudoku> {
  var _puzzleArray = [9,null,null,null,null,null,null,null,1,null,null,7,8,3,1,6,4,9,6,1,null,5,4,null,8,null,null,null,null,null,1,null,null,null,null,6,7,4,5,null,9,6,2,null,null,null,null,6,null,null,4,7,5,null,3,7,null,4,null,null,9,null,2,4,null,null,null,6,null,null,8,5,5,null,1,null,null,8,null,null,null];
  int _selectedSquare = -1;
  _setSelectedSquare(i) {
    setState(() {
      _selectedSquare = i;
    });
  }

  _numberTap(value) {
    if (_selectedSquare == -1) return;
    setState(() {
      _puzzleArray[_selectedSquare] = value;
    });
  }

  _controlHandler(value) {
    switch (value) {
      case 1:
      case 2:
      case 3:
      case 4:
      case 5:
      case 6:
      case 7:
      case 8:
      case 9:
        _numberTap(value);
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar(),
        body: Column(
          children: [
            Text(
              "Puzzle 1",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            Game(
              selectedSquare: _selectedSquare,
              setSelectedSquare: _setSelectedSquare,
              puzzleArray: _puzzleArray,
            ),
            Text(
              "selected square is " + _selectedSquare.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24),
            ),
            Controls(
              controlHandler: _controlHandler,
            ),
          ],
        ));
  }
}
