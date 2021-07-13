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
  List allPuzzles = [];
  List puzzleProgress = [];
  late Future<JsonObj> futureAllPuzzles;
  bool _filtersIsExpanded = false;
  Map<String, bool> filters = {
    "easy": true,
    "medium": true,
    "hard": true,
    "expert": true,
    "unattempted": true,
    "in progress": true,
    "completed": true,
  };

  final TextStyle _font16White = TextStyle(color: Colors.white, fontSize: 16);

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

    Widget _okAndLogoutBtn(text, onPress) {
      return GestureDetector(
        onTap: () => onPress(),
        child: Container(
            decoration: BoxDecoration(
                color: Colors.black45,
                borderRadius: BorderRadius.all(Radius.circular(4))),
            child: Text(text,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                )),
            padding: EdgeInsets.all(12)),
      );
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
              _okAndLogoutBtn("NO", () => Navigator.of(context).pop(false)),
              SizedBox(width: 10),
              _okAndLogoutBtn("LOGOUT", () => _logout()),
            ],
            backgroundColor: Color(0xff272537),
          ),
        ) ??
        false;
  }

  Widget _buildFilterActionChip(content, enabled) {
    final bool selected = filters[content] as bool;
    return ActionChip(
      avatar: CircleAvatar(
        backgroundColor: Colors.grey,
        child: selected
            ? Icon(IconData(57686, fontFamily: 'MaterialIcons'))
            : Text(""),
      ),
      label: Text(content),
      onPressed: () {
        if (enabled) {
          _toggleFilter(content);
        }
      },
      backgroundColor:
          enabled ? (selected ? Colors.blue : Colors.red) : Colors.grey,
    );
  }

  _toggleFilter(content) {
    setState(() {
      filters[content] = !(filters[content] as bool);
    });
  }

  _puzzleOnPressed(puzzleId) {
    final props = {
      "puzzle_id": puzzleId,
    };
    Navigator.pushNamed(context, '/sudoku', arguments: ScreenArguments(props));
  }

  // can be improved by joining the query results of puzzleprogress and count
  // together in the server side
  // and loop through puzzle count to find puzzle id
  String _getProgress(id, bool withTime) {
    for (int i = 0; i < puzzleProgress.length; i++) {
      if (puzzleProgress[i]["puzzle_id"] == id) {
        if (puzzleProgress[i]["completed"]) {
          return "completed" + (withTime ? " in " + puzzleProgress[i]["time_spent"] : "");
        } else {
          return "in progress";
        }
      }
    }
    return "unattempted";
  }

  _puzzleFilter() {
    return allPuzzles
        .where((element) =>
            filters[element["difficulty"] as String] == true &&
            filters[_getProgress(element["puzzle_id"], false)] == true)
        .toList();
  }

  @override
  void initState() {
    super.initState();
    futureAllPuzzles = SudokuApi.getRequest("/puzzlesCount");
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: Authentication.isAuthenticated ? _onBackPressed : null,
      child: new Scaffold(
        appBar: MyAppBar(),
        endDrawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.black45,
                ),
                child: Center(
                    child: CircleAvatar(
                  child: Text(
                      MyCookie.getUsername() != null
                          ? MyCookie.getUsername()
                          : "no user",
                      style: TextStyle(color: Color(0xff272537), fontSize: 24)),
                  radius: 64,
                  backgroundColor: Colors.blueAccent,
                )),
              ),
              ListTile(
                leading: Icon(Icons.account_circle, color: Colors.white54),
                title: Text(
                  'Profile',
                  style: _font16White,
                ),
              ),
              ListTile(
                leading: Icon(Icons.settings, color: Colors.white54),
                title: Text(
                  'Settings',
                  style: _font16White,
                ),
              ),
              ExpansionPanelList(
                expansionCallback: (index, isExpanded) => setState(() {
                  _filtersIsExpanded = !isExpanded;
                }),
                children: [
                  ExpansionPanel(
                    body: Wrap(
                      children: [
                        _buildFilterActionChip("easy", true),
                        _buildFilterActionChip("medium", true),
                        _buildFilterActionChip("hard", true),
                        _buildFilterActionChip("expert", true),
                        _buildFilterActionChip(
                            "unattempted", Authentication.isAuthenticated),
                        _buildFilterActionChip(
                            "in progress", Authentication.isAuthenticated),
                        _buildFilterActionChip("completed", Authentication.isAuthenticated),
                      ],
                    ),
                    headerBuilder: (_, isExpanded) {
                      return Center(
                        child: Text(
                          "Filters",
                          style: _font16White,
                        ),
                      );
                    },
                    isExpanded: _filtersIsExpanded,
                    backgroundColor: Color(0xff272537),
                    canTapOnHeader: true,
                  )
                ],
              ),
            ],
          ),
        ),
        body: FutureBuilder<JsonObj>(
          future: futureAllPuzzles,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              allPuzzles = snapshot.data!.data["puzzles"];
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
                  Expanded(
                    child: PuzzleList(
                      puzzles: _puzzleFilter(),
                      onPressed: _puzzleOnPressed,
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
      ),
    );
  }
}

class PuzzleList extends StatelessWidget {
  final List puzzles;
  final Function onPressed;
  final puzzleProgress;
  final TextStyle bigFont = TextStyle(fontSize: 20, color: Colors.white);
  final TextStyle bigFont2 = TextStyle(fontSize: 16, color: Colors.white);

  PuzzleList({
    required this.puzzles,
    required this.onPressed,
    required this.puzzleProgress,
  });


  _getProgress(id) {
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
              _getProgress(puzzleDetails["puzzle_id"]),
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
      itemCount: puzzles.length * 2,
      itemBuilder: (context, i) {
        if (i.isOdd)
          return const Divider(
            thickness: 1,
            color: Colors.white10,
          );

        final index = i ~/ 2;
        return _buildRow(puzzles[index]);
      },
    );
  }
}
