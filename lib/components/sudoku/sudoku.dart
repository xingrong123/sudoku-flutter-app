import 'package:flutter/material.dart';

import '../myAppBar.dart';
import 'game.dart';
import 'controls.dart';
import '../../utils/screenArguments.dart';
import '../../utils/sudokuApi.dart';
import '../../utils/jsonObj.dart';

class Sudoku extends StatefulWidget {
  static const routeName = '/sudoku';

  @override
  _SudokuState createState() => _SudokuState();
}

class _SudokuState extends State<Sudoku> {
  List _squares = [];
  int _selectedSquare = -1;
  List _puzzleIndex = [];
  bool _win = false;
  var history = [
    {
      "square": null,
      "move": null,
      "previousState": null,
    }
  ];
  int move = 0;
  var startTime = {
    "hours": 0,
    "minutes": 0,
    "seconds": 0,
  };
  var time = {
    "hours": 0,
    "minutes": 0,
    "seconds": 0,
  };

  bool _initialized = false;
  bool _initialized2 = false;
  int _puzzleId = 0;
  String _difficulty = "";
  late Future<JsonObj> futurePuzzleDetails;

  bool _checkWin() {
    List<List> check = [];
    for (int i = 0; i < 9; i++) {
      check.add(_squares.sublist(i * 9, i * 9 + 9));
    }
    for (int i = 0; i < 9; i++) {
      List array = [];
      for (int j = 0; j < 9; j++) {
        array.add(_squares[j * 9 + i]);
      }
      check.add(array);
    }
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        List array = [];
        for (int k = 0; k < 3; k++) {
          for (int m = 0; m < 3; m++) {
            int index = (i * 3 + k) * 9 + (j * 3 + m);
            array.add(_squares[index]);
          }
        }
        check.add(array);
      }
    }
    for (int i = 0; i < check.length; i++) {
      for (int j = 1; j <= 9; j++) {
        if (!check[i].contains(j)) return false;
      }
    }
    return true;
  }

  _deselectSquare() {
    setState(() {
      _selectedSquare = -1;
    });
  }

  _setSelectedSquare(i) {
    if (_puzzleIndex.contains(i) || _win) {
      _deselectSquare();
    } else {
      setState(() {
        _selectedSquare = i;
      });
    }
  }

  _numberTap(value) {
    if (_selectedSquare == -1) return;
    setState(() {
      _squares[_selectedSquare] = value;
    });
    bool winState = _checkWin();
    if (winState) {
      setState(() {
        _win = true;
        _selectedSquare = -1;
      });
    }
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

  _initalize(props) {
    setState(() {
      _initialized = true;
      _puzzleId = props['puzzleId'];
      futurePuzzleDetails =
          SudokuApi.getRequest("/puzzle/" + _puzzleId.toString());
    });
  }

  _setFetchedData(data) {
    final tempSquares = data["puzzle"];
    List<int> tempPuzzleIndex = [];
    for (int i = 0; i < 81; i++) {
      if (tempSquares[i] != null) {
        tempPuzzleIndex.add(i);
      }
    }
    _squares = tempSquares;
    _difficulty = data["difficulty"];
    _puzzleIndex = tempPuzzleIndex;
    _initialized2 = true;
  }

  _winStatement() {
    if (!_win) return SizedBox.shrink();
    return Text(
      "You Win!!",
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 24),
    );
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;
    if (_initialized == false) _initalize(args.props);

    return Scaffold(
        appBar: MyAppBar(),
        body: FutureBuilder<JsonObj>(
          future: futurePuzzleDetails,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final data = snapshot.data!.data;
              if (_initialized2 == false) {
                _setFetchedData(data);
              }
              return Column(
                children: [
                  Text(
                    "Puzzle " + _puzzleId.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Difficulty: " + _difficulty,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: (_win ? 10 : 0)),
                  _winStatement(),
                  SizedBox(height: 10),
                  Game(
                    selectedSquare: _selectedSquare,
                    setSelectedSquare: _setSelectedSquare,
                    puzzleArray: _squares,
                    puzzleIndex: _puzzleIndex,
                  ),
                  SizedBox(height: 30),
                  Controls(
                    controlHandler: _controlHandler,
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }

            // By default, show a loading spinner.
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ));
  }
}
