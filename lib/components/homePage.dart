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
            title: Text(MyCookie.getUsername(), style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        )),
            content: new Text('Do you want to logout', style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        )),
            actions: <Widget>[
              GestureDetector(
                onTap: () => Navigator.of(context).pop(false),
                child: Container(
                    child: Text("NO",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        )),
                    color: Colors.black45,
                    padding: EdgeInsets.all(5)),
              ),
              SizedBox(width: 10),
              new GestureDetector(
                onTap: () => _logout(),
                child: Container(
                    child: Text("LOGOUT", 
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        )),
                    color: Colors.black45,
                    padding: EdgeInsets.all(5)),
              ),
            ],
            backgroundColor: Color(0xff272537),
            
          ),
        ) ??
        false;
  }

  Widget _tableElementText(String value) {
    return (Container(
      child: Center(
        child: Text(
          value,
          style: TextStyle(fontSize: 20, color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ),
      height: 40,
    ));
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
              return Column(
                children: [
                  Container(
                    child: Text("Select puzzle",
                        style: TextStyle(fontSize: 24, color: Colors.white)),
                    margin: EdgeInsets.all(16),
                  ),
                  //_createTable(),
                  Expanded(
                    child: PuzzleList(puzzlesCount, _onPressed),
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
  final List _puzzlesCount;
  final Function _onPressed;
  final TextStyle bigFont = TextStyle(fontSize: 20, color: Colors.white);
  final TextStyle bigFont2 = TextStyle(fontSize: 16, color: Colors.white);

  PuzzleList(this._puzzlesCount, this._onPressed);

  Widget _buildRow(something) {
    return ListTile(
      leading: Text(something["puzzle_id"].toString(), style: bigFont),
      title: Text(something["difficulty"], style: bigFont),
      subtitle: Text(
        "something",
        style: bigFont2,
      ),
      dense: true,
      onTap: () {
        _onPressed(something["puzzle_id"]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _puzzlesCount.length * 2,
      itemBuilder: (context, i) {
        if (i.isOdd)
          return const Divider(
            thickness: 1,
            color: Colors.white10,
          );

        final index = i ~/ 2;
        return _buildRow(_puzzlesCount[index]);
      },
    );
  }
}
