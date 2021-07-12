import 'package:flutter/material.dart';
import 'package:sudoku_app/utils/myCookie.dart';
import 'package:sudoku_app/utils/screenArguments.dart';

import 'myAppBar.dart';
import '../utils/sudokuApi.dart';
import '../utils/jsonObj.dart';
import '../utils/authentication.dart';
import '../utils/authApi.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/homepage';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List puzzlesCount = [];
  List puzzleProgress = [];
  late Future<JsonObj> futurePuzzlesCount;

  Future<bool> _onBackPressed() async {
    _logout() {
      () async {
        try {
          await AuthApi.deleteRequest("/logout");
        } catch (e) {
          print("error: " + e.toString());
        }
      }();
      Authentication.isAuthenticated = false;
      Navigator.of(context).pop(true);
    }

    return await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: Text(MyCookie.getUsername(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                )),
            content: new Text('Do you want to logout?',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 16,
                )),
            actions: <Widget>[
              GestureDetector(
                onTap: () => Navigator.of(context).pop(false),
                child: Container(
                    decoration: BoxDecoration(
                        color: Colors.black45,
                        borderRadius: BorderRadius.all(Radius.circular(4))),
                    child: Text("NO",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        )),
                    padding: EdgeInsets.all(12)),
              ),
              SizedBox(width: 10),
              new GestureDetector(
                onTap: () => _logout(),
                child: Container(
                  decoration: BoxDecoration(
                        color: Colors.black45,
                        borderRadius: BorderRadius.all(Radius.circular(4))),
                    child: Text("LOGOUT",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        )),
                    padding: EdgeInsets.all(12)),
              ),
            ],
            backgroundColor: Color(0xff272537),
          ),
        ) ??
        false;
  }

  _onPressed(puzzleId) {
    final props = {
      "puzzleId": puzzleId,
    };
    Navigator.pushNamed(context, '/sudoku', arguments: ScreenArguments(props));
  }

  @override
  void initState() {
    super.initState();
    futurePuzzlesCount = SudokuApi.getRequest("/puzzlesCount");
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: Authentication.isAuthenticated ? _onBackPressed : null,
      child: new Scaffold(
        appBar: MyAppBar(),
        body: FutureBuilder<JsonObj>(
          future: futurePuzzlesCount,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              puzzlesCount = snapshot.data!.data["puzzles"];
              if (snapshot.data!.data["wins"] != null) {
                puzzleProgress = snapshot.data!.data["wins"];
              }
              return Column(
                children: [
                  Container(
                    child: Text("Select puzzle",
                        style: TextStyle(fontSize: 24, color: Colors.white)),
                    margin: EdgeInsets.all(16),
                  ),
                  //_createTable(),
                  Expanded(
                    child: PuzzleList(
                      puzzlesCount: puzzlesCount,
                      onPressed: _onPressed,
                      puzzleProgress: puzzleProgress,
                    ),
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
        ),
        backgroundColor: Color(0xff272537),
      ),
    );
  }
}

class PuzzleList extends StatelessWidget {
  final List puzzlesCount;
  final Function onPressed;
  final puzzleProgress;
  final TextStyle bigFont = TextStyle(fontSize: 20, color: Colors.white);
  final TextStyle bigFont2 = TextStyle(fontSize: 16, color: Colors.white);

  PuzzleList({
    required this.puzzlesCount,
    required this.onPressed,
    required this.puzzleProgress,
  });

  // can be improved by joining the query results of puzzleprogress and count
  // together in the server side
  // and loop through puzzle count to find puzzle id
  getProgress(id) {
    for (int i = 0; i < puzzleProgress.length; i++) {
      if (puzzleProgress[i]["puzzle_id"] == id) {
        if (puzzleProgress[i]["completed"]) {
          return "completed in " + puzzleProgress[i]["time_spent"];
        } else {
          return "in progress";
        }
      }
    }
    return "unattempted";
  }

  Widget _buildRow(puzzleDetails) {
    return ListTile(
      leading: Text(puzzleDetails["puzzle_id"].toString(), style: bigFont),
      title: Text(puzzleDetails["difficulty"], style: bigFont),
      subtitle: puzzleProgress.length != 0
          ? Text(
              getProgress(puzzleDetails["puzzle_id"]),
              style: bigFont2,
            )
          : null,
      dense: true,
      onTap: () {
        onPressed(puzzleDetails["puzzle_id"]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: puzzlesCount.length * 2,
      itemBuilder: (context, i) {
        if (i.isOdd)
          return const Divider(
            thickness: 1,
            color: Colors.white10,
          );

        final index = i ~/ 2;
        return _buildRow(puzzlesCount[index]);
      },
    );
  }
}
