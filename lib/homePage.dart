import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: Text("Select puzzle", style: TextStyle(fontSize: 24)),
          margin: EdgeInsets.all(16),
        ),
        Table(
          border: TableBorder.all(color: Colors.black),
          children: [
            TableRow(
              children: [
                Container(
                  child: Text(
                    "ID",
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                  height: 32,
                ),
                Container(
                  child: Text(
                    "Difficulty",
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                  height: 32,
                ),
                Container(
                  child: Text(
                    "Play",
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                  height: 32,
                ),
              ],
            ),
            TableRow(children: [
              Container(
                child: Text(
                  "ID",
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
                height: 32,
              ),
              Container(
                child: Text(
                  "Difficulty",
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
                height: 32,
              ),
              Container(
                child: Text(
                  "Play",
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
                height: 32,
              ),
            ])
          ],
        )
      ],
    );
  }
}
