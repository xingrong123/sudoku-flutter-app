import 'package:flutter/material.dart';

class Controls extends StatelessWidget {
  final Function controlHandler;

  // Constructor
  Controls({
    required this.controlHandler,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> _buttonRows() {
      List<Widget> array1 = [];
      for (int i = 0; i < 3; i++) {
        List<Widget> array2 = [];
        for (int j = 0; j < 3; j++) {
          var value = i * 3 + j + 1;
          array2.add(ElevatedButton(
            onPressed: () => controlHandler(value),
            child: Container(
              child: Center(
                child: Text(value.toString(), style: TextStyle(fontSize: 24)),
              ),
              width: 50,
              height: 50,
            ),
            style: ElevatedButton.styleFrom(
              primary: Colors.black38,
            ),
          ));
          array2.add(SizedBox(width: 5));
        }
        array2.removeLast();
        array1.add(Row(
          children: array2,
          mainAxisAlignment: MainAxisAlignment.center,
        ));
        array1.add(SizedBox(height: 5));
      }
      array1.removeLast();
      return array1;
    }

    return Container(
      child: Column(
        children: _buttonRows(),
      ),
    );
  }
}
