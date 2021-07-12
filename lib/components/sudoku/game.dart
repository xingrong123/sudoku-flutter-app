import 'package:flutter/material.dart';

class Game extends StatelessWidget {
  final int selectedSquare;
  final Function setSelectedSquare;
  final List puzzleArray;
  final List puzzleIndex;
  Game(
      {required this.selectedSquare,
      required this.setSelectedSquare,
      required this.puzzleArray,
      required this.puzzleIndex});

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;

    Widget _square(int index) {
      final _boxSize = _width / 9 - 5;
      final squareColor = puzzleIndex.contains(index)
          ? Colors.white30
          : selectedSquare == index
              ? Colors.yellow
              : Colors.white54;
      return GestureDetector(
        child: Container(
          width: _boxSize,
          height: _boxSize,
          child: Center(
            child: Text(
              puzzleArray[index] == null ? "" : puzzleArray[index].toString(),
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
            color: squareColor,
          ),
        ),
        onTap: () => setSelectedSquare(index),
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
