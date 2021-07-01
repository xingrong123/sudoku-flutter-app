import 'package:flutter/material.dart';

class Controls extends StatelessWidget {
  Function _controlHandler = () {};

  // Constructor
  Controls({
    required Function controlHandler,
  }) {
    _controlHandler = controlHandler;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _buttonRows() {
      List<Widget> array1 = [];
      for (int i = 0; i < 3; i++) {
        List<Widget> array2 = [];
        for (int j = 0; j < 3; j++) {
          var value = i * 3 + j + 1;
          array2.add(ElevatedButton(
            onPressed: () => _controlHandler(value),
            child: Text(value.toString(),
                style: TextStyle(fontSize: 24)),
            style: ElevatedButton.styleFrom(
              primary: Colors.black38,
            ),
          ));
        }
        array1.add(Row(
          children: array2,
          mainAxisAlignment: MainAxisAlignment.center,
        ));
      }

      return array1;
    }

    return Container(
      child: Column(
        children: _buttonRows(),
      ),
    );
  }
}
