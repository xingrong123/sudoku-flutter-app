import 'package:flutter/material.dart';

class Game extends StatelessWidget {
  int _selectedSquare = -1;
  Function _setSelectedSquare = () {};
  List _puzzleArray = [];
  Game(
      {required int selectedSquare,
      required Function setSelectedSquare,
      required List puzzleArray}) {
    _selectedSquare = selectedSquare;
    _setSelectedSquare = setSelectedSquare;
    _puzzleArray = puzzleArray;
  }

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;

    Widget _square(int index) {
      final _boxSize = _width / 9 - 5;
      return GestureDetector(
        child: Container(
          width: _boxSize,
          height: _boxSize,
          child: Center(
            child: Text(
              _puzzleArray[index] == null ? "" : _puzzleArray[index].toString(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
              ),
            ),
          ),
          padding: const EdgeInsets.all(0),
          margin: const EdgeInsets.all(0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black12),
            color: _selectedSquare == index ? Colors.yellow : Colors.white,
          ),
        ),
        onTap: () => _setSelectedSquare(index),
      );
    }

    Widget _area(int col, int row) {
      List<Widget> _array1 = [];
      for (int i = 0; i < 3; i++) {
        List<Widget> _array2 = [];
        for (int j = 0; j < 3; j++) {
          int _index = (col * 3 + i) * 9 + (row * 3 + j);
          _array2.add(_square(_index));
        }
        _array1.add(ButtonBar(
          children: _array2,
          buttonHeight: 10,
          buttonPadding: const EdgeInsets.all(0),
        ));
      }

      return Container(
        child: Column(
          children: _array1,
        ),
        decoration: BoxDecoration(border: Border.all(color: Colors.black)),
        padding: const EdgeInsets.all(0),
      );
    }

    Widget _board() {
      List<Widget> _array1 = [];
      for (int i = 0; i < 3; i++) {
        List<Widget> _array2 = [];
        for (int j = 0; j < 3; j++) {
          _array2.add(_area(i, j));
        }
        _array1.add(Row(
          children: _array2,
          mainAxisAlignment: MainAxisAlignment.center,
        ));
      }
      return Container(
        child: Column(
          children: _array1,
        ),
        padding: const EdgeInsets.all(0),
        margin: const EdgeInsets.all(0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
        ),
        width: double.infinity,
      );
    }

    return _board();
  }
}
