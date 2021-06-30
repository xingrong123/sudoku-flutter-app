import 'package:flutter/material.dart';

import 'myAppBar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List _puzzles = [1, 2, 3, 4, 5, 6];

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

  _onPressed() {
    Navigator.pushNamed(context, '/sudoku');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: Column(
        children: [
          Container(
            child: Text("Select puzzle", style: TextStyle(fontSize: 24)),
            margin: EdgeInsets.all(16),
          ),
          _createTable(),
          Expanded(
            child: PuzzleList(_puzzles, _onPressed),
          ),
        ],
      ),
    );
  }
}

class PuzzleList extends StatelessWidget {
  final List _puzzles;
  final Function _onPressed;
  final TextStyle bigFont = TextStyle(fontSize: 20);

  PuzzleList(this._puzzles, this._onPressed);

  Widget _buildRow(something) {
    return ListTile(
      leading: Text("id1", style: bigFont),
      title: Text("easy", style: bigFont),
      subtitle: Text(
        "something else",
        style: bigFont,
      ),
      dense: true,
      onTap: () {
        _onPressed();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _puzzles.length * 2,
      itemBuilder: (context, i) {
        if (i.isOdd)
          return const Divider(
            thickness: 1,
          );

        final index = i ~/ 2; /*3*/
        return _buildRow(_puzzles[index]);
      },
    );
  }
}
