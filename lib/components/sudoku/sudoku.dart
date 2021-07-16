import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sudoku_app/components/sudoku/commentSection.dart';
import 'package:sudoku_app/components/sudoku/starRatings.dart';
import 'dart:async';

import '../myAppBar.dart';
import 'game.dart';
import 'controls.dart';
import '../../utils/screenArguments.dart';
import '../../utils/sudokuApi.dart';
import '../../utils/jsonObj.dart';
import '../../logic/sudokuLogic.dart';

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

  bool _isInitializedPhaseOne = false;
  bool _isInitializedPhaseTwo = false;
  int _puzzleId = 0;
  String _difficulty = "";
  double _avgRating = 0;
  late Future<JsonObj> futurePuzzleDetails;
  int _startTimeInSeconds = 0;
  late Stopwatch _stopwatch;
  late Timer _timer;
  List _comments = [];

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
      "time_spent": SudokuLogic.formatTime(
          _stopwatch.elapsedMilliseconds, _startTimeInSeconds)
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

  void _updateHistoryAndMoves(value) {
    _move++;
    _history = _history.sublist(0, _move);
    _history.add({
      "square": _selectedSquare,
      "move": value,
      "previousState": _squares[_selectedSquare]
    });
  }

  void _setNumberOnSquareOnPress(value) {
    if (_selectedSquare == -1) return;
    if (_squares[_selectedSquare] == value) return;
    _updateHistoryAndMoves(value);
    _squares[_selectedSquare] = value;
    _win = SudokuLogic.checkWin(_squares);
    if (_win && _stopwatch.isRunning) {
      _stopwatch.stop();
      _saveWinDetails();
      _selectedSquare = -1;
    }
    setState(() {});
  }

  void _save() {
    final something = SudokuLogic.formatTime(
        _stopwatch.elapsedMilliseconds, _startTimeInSeconds);
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
      _startTimeInSeconds = SudokuLogic.calculateTimeInSecondsFromStringFormat(
          res.data[0]["time_spent"]);

      _stopwatch.reset();
      _win = SudokuLogic.checkWin(_squares);
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

  void _clearSquareOnPress() {
    // no point clearing an empty square
    if (_squares[_selectedSquare] == null) return;
    _updateHistoryAndMoves(null);
    _squares[_selectedSquare] = null;
    setState(() {});
  }

  void _undoOnPress() {
    final moveDetails = _history[_move];
    _squares[moveDetails["square"]] = moveDetails["previousState"];
    _move--;
    _win = SudokuLogic.checkWin(_squares);
    setState(() {});
  }

  void _redoOnPress() {
    _move++;
    final moveDetails = _history[_move];
    _squares[moveDetails["square"]] = moveDetails["move"];
    _win = SudokuLogic.checkWin(_squares);
    setState(() {});
  }

  void _controlHandler(value) {
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
        _setNumberOnSquareOnPress(value);
        break;
      case "save":
        _save();
        break;
      case "load":
        _load();
        break;
      case "clear":
        _clearSquareOnPress();
        break;
      case "undo":
        _undoOnPress();
        break;
      case "redo":
        _redoOnPress();
        break;
      default:
        print("invalid button press");
    }
  }

  _initalizePuzzleId(props) {
    setState(() {
      _isInitializedPhaseOne = true;
      _puzzleId = props['puzzle_id'];
      futurePuzzleDetails =
          SudokuApi.getRequest("/puzzle/" + _puzzleId.toString());
    });
  }

  void _setFetchedData(data) {
    print(data["puzzle"][0]);
    print(data["comments"]);
    final tempSquares = data["puzzle"][0]["puzzle"];
    List<int> tempPuzzleIndex = [];
    for (int i = 0; i < 81; i++) {
      if (tempSquares[i] != null) {
        tempPuzzleIndex.add(i);
      }
    }
    _squares = tempSquares;
    _difficulty = data["puzzle"][0]["difficulty"];
    _puzzleIndex = tempPuzzleIndex;
    _avgRating = (data["puzzle"][0]["avg_rating"] as int).toDouble();
    print(_avgRating.runtimeType);
    _comments = data["comments"];
    _isInitializedPhaseTwo = true;
  }

  Widget _getWinStatement() {
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
    if (_isInitializedPhaseOne == false) _initalizePuzzleId(args.props);

    return Scaffold(
        appBar: MyAppBar(),
        body: FutureBuilder<JsonObj>(
          future: futurePuzzleDetails,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final data = snapshot.data!.data;
              if (_isInitializedPhaseTwo == false) {
                _setFetchedData(data);
              }
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      "Puzzle " + _puzzleId.toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    Text(
                      "Difficulty: " + _difficulty,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.white30),
                    ),
                    SizedBox(height: (_win ? 10 : 0)),
                    _getWinStatement(),
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
                          Text(
                            "time:",
                            style: TextStyle(color: Colors.white30),
                          ),
                          Text(
                              SudokuLogic.formatTime(
                                  _stopwatch.elapsedMilliseconds,
                                  _startTimeInSeconds),
                              style: TextStyle(
                                  fontSize: 36, color: Colors.white30))
                        ],
                      ),
                    ),
                    SizedBox(height: 24),
                    StarRating(
                      avgRating: _avgRating,
                      puzzleId: _puzzleId,
                    ),
                    SizedBox(height: 24),
                    CommentSection(comments: _comments),
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
