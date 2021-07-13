import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:async';

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
  List<Map<String, dynamic>> _history = [
    {
      "square": null,
      "move": null,
      "previousState": null,
    }
  ];
  int _move = 0;
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
  int _startTimeInSeconds = 0;
  late Stopwatch _stopwatch;
  late Timer _timer;

  int _calculateTimeInSecondsFromStringFormat(String time) {
    print(time);
    final timeArray = time.split(":");
    int timeInSeconds = int.parse(timeArray[0]) * 3600 +
        int.parse(timeArray[1]) * 60 +
        int.parse(timeArray[2]);
    return timeInSeconds;
  }

  String formatTime(int milliseconds) {
    var secs = milliseconds ~/ 1000 + _startTimeInSeconds;
    var hours = (secs ~/ 3600).toString().padLeft(2, '0');
    var minutes = ((secs % 3600) ~/ 60).toString().padLeft(2, '0');
    var seconds = (secs % 60).toString().padLeft(2, '0');
    return "$hours:$minutes:$seconds";
  }

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

  _saveWinDetails() {
    final body = {
      "puzzle_id": _puzzleId,
      "time_spent": formatTime(_stopwatch.elapsedMilliseconds)
    };
    SudokuApi.postRequest("/win", body).then((res) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Saved win details'),
        duration: Duration(seconds: 5),
      ));
    }).catchError((error) {
      print(error.toString());
    });
  }

  _updateHistoryAndMoves(value) {
    _move++;
    _history = _history.sublist(0, _move);
    _history.add({
      "square": _selectedSquare,
      "move": value,
      "previousState": _squares[_selectedSquare]
    });
  }

  _numberTap(value) {
    if (_selectedSquare == -1) return;
    if (_squares[_selectedSquare] == value) return;
    _updateHistoryAndMoves(value);
    _squares[_selectedSquare] = value;
    _win = _checkWin();
    if (_win && _stopwatch.isRunning) {
      _stopwatch.stop();
      _saveWinDetails();
      _selectedSquare = -1;
    }
    setState(() {});
  }

  void _save() {
    final something = formatTime(_stopwatch.elapsedMilliseconds);
    print(something);
    final body = {
      "puzzle_id": _puzzleId,
      "moves": _move,
      "squares": [..._squares],
      "history": [..._history],
      "time_spent": something
    };
    SudokuApi.postRequest("/save", body).then((res) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Saved successfully'),
        duration: Duration(seconds: 5),
      ));
    }).catchError((error) {
      print(error.toString());
    });
  }

  void _load() {
    final body = {"puzzle_id": _puzzleId};
    SudokuApi.postRequest("/load", body).then((res) {
      List<Map<String, dynamic>> historyList =
          (jsonDecode(jsonEncode(res.data[0]["history"])) as List)
              .map((e) => e as Map<String, dynamic>)
              .toList();
      _squares = res.data[0]["squares"];
      _move = res.data[0]["moves"];
      _history = historyList;
      _startTimeInSeconds =
          _calculateTimeInSecondsFromStringFormat(res.data[0]["time_spent"]);

      _stopwatch.reset();
      _win = _checkWin();
      if (_win && _stopwatch.isRunning) {
        _stopwatch.stop();
      } else if (!_win && !_stopwatch.isRunning) {
        _stopwatch.start();
      }
      print("loaded successfully");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Loaded successfully'),
        duration: Duration(seconds: 3),
      ));
    }).catchError((error) {
      print(error.toString());
    });
    setState(() {});
  }

  _clearSquare() {
    // no point clearing an empty square
    if (_squares[_selectedSquare] == null) return;
    _updateHistoryAndMoves(null);
    _squares[_selectedSquare] = null;
    setState(() {});
  }

  _undo() {
    final moveDetails = _history[_move];
    _squares[moveDetails["square"]] = moveDetails["previousState"];
    _move--;
    if (!_squares.contains(null)) {
      _win = _checkWin();
    }
    setState(() {});
  }

  _redo() {
    _move++;
    final moveDetails = _history[_move];
    _squares[moveDetails["square"]] = moveDetails["move"];
    if (!_squares.contains(null)) {
      _win = _checkWin();
    }
    setState(() {});
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
      case "save":
        _save();
        break;
      case "load":
        _load();
        break;
      case "clear":
        _clearSquare();
        break;
      case "undo":
        _undo();
        break;
      case "redo":
        _redo();
        break;
      default:
        print("invalid button press");
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
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _stopwatch = Stopwatch()..start();
    // re-render every 30ms
    _timer = new Timer.periodic(new Duration(milliseconds: 30), (timer) {
      setState(() {});
    });
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
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      "Puzzle " + _puzzleId.toString(),
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    Text(
                      "Difficulty: " + _difficulty,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.white30),
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
                    SizedBox(height: 24),
                    Controls(
                      controlHandler: _controlHandler,
                      enableUndoBtn: (_move > 0),
                      enableRedoBtn: (_move < _history.length - 1),
                    ),
                    SizedBox(height: 24),
                    Container(
                      child: Column(
                        children: [
                          Text("time:", style: TextStyle(color: Colors.white30),),
                          Text(formatTime(_stopwatch.elapsedMilliseconds),
                              style: TextStyle(fontSize: 36, color: Colors.white30))
                        ],
                      ),
                    ),
                  ],
                ),
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
