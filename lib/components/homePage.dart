import 'package:flutter/material.dart';
import 'package:sudoku_app/utils/screenArguments.dart';

import 'myAppBar.dart';
import '../utils/sudokuApi.dart';
import '../utils/jsonObj.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  static const routeName = '/';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List puzzlesCount = [];
  late Future<JsonObj> futurePuzzlesCount;

  Widget _tableElementText(String value) {
    return (Container(
      child: Center(
        child: Text(
          value,
          style: TextStyle(fontSize: 20),
          textAlign: TextAlign.center,
        ),
      ),
      height: 40,
    ));
  }

  Widget _createTable() {
    List<Widget> array2 = [];
    array2.add(_tableElementText("ID"));
    array2.add(_tableElementText("Difficulty"));
    array2.add(_tableElementText("Play"));

    return (Table(border: TableBorder.all(color: Colors.black38), children: [
      TableRow(children: array2),
    ]));
  }

  _onPressed(puzzleId) {
    final props = {"puzzleId": puzzleId,};
    Navigator.pushNamed(context, '/sudoku', arguments: ScreenArguments(props));
  }

  @override
  void initState() {
    super.initState();
    futurePuzzlesCount = SudokuApi.getRequest("/puzzlesCount");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar(),
        body: FutureBuilder<JsonObj>(
          future: futurePuzzlesCount,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              puzzlesCount = snapshot.data!.data["puzzles"];
              return Column(
                children: [
                  Container(
                    child:
                        Text("Select puzzle", style: TextStyle(fontSize: 24)),
                    margin: EdgeInsets.all(16),
                  ),
                  _createTable(),
                  Expanded(
                    child: PuzzleList(puzzlesCount, _onPressed),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            // By default, show a loading spinner.
            return Center(child: CircularProgressIndicator(),);
          },
        ));
  }
}

class PuzzleList extends StatelessWidget {
  final List _puzzlesCount;
  final Function _onPressed;
  final TextStyle bigFont = TextStyle(fontSize: 20);

  PuzzleList(this._puzzlesCount, this._onPressed);

  Widget _buildRow(something) {
    return ListTile(
      leading: Text(something["puzzle_id"].toString(), style: bigFont),
      title: Text(something["difficulty"], style: bigFont),
      subtitle: Text(
        "something else",
        style: bigFont,
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
          );

        final index = i ~/ 2;
        return _buildRow(_puzzlesCount[index]);
      },
    );
  }
}
