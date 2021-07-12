import 'package:flutter/material.dart';

import '../../utils/authentication.dart';

class Controls extends StatelessWidget {
  final Function controlHandler;
  final bool enableUndoBtn;
  final bool enableRedoBtn;

  // Constructor
  Controls({
    required this.controlHandler,
    required this.enableUndoBtn,
    required this.enableRedoBtn,
  });

  @override
  Widget build(BuildContext context) {
    bool _isEnabled(value) {
      if ((value == "save" || value == "load") &&
          !Authentication.isAuthenticated) {
        return false;
      }
      if (value == "undo" && !enableUndoBtn) {
        return false;
      }
      if (value == "redo" && !enableRedoBtn) {
        return false;
      }
      return true;
    }

    Widget getBtn(value) {
      return (ElevatedButton(
        onPressed: _isEnabled(value) ? () => controlHandler(value) : null,
        child: Container(
          child: Center(
            child: Text(value.toString(), style: TextStyle(fontSize: 24)),
          ),
          width: 60,
          height: 50,
        ),
        style: ElevatedButton.styleFrom(
          primary: Colors.black38,
        ),
      ));
    }

    List<Widget> _buttonRows() {
      List<Widget> array1 = [];
      for (int i = 0; i < 3; i++) {
        List<Widget> array2 = [];
        for (int j = 0; j < 3; j++) {
          var value = i * 3 + j + 1;
          array2.add(getBtn(value));
          array2.add(SizedBox(width: 5));
        }
        array2.removeLast();
        array1.add(Row(
          children: array2,
          mainAxisAlignment: MainAxisAlignment.center,
        ));
        array1.add(SizedBox(height: 5));
      }
      List<Widget> undoRedoAndClearBtns = [
        getBtn("undo"),
        SizedBox(width: 5),
        getBtn("redo"),
        SizedBox(width: 5),
        getBtn("clear"),
      ];
      array1.add(Row(
        children: undoRedoAndClearBtns,
        mainAxisAlignment: MainAxisAlignment.center,
      ));
      array1.add(SizedBox(height: 5));
      List<Widget> saveAndLoadBtns = [
        getBtn("save"),
        SizedBox(width: 5),
        getBtn("load"),
      ];
      array1.add(Row(
        children: saveAndLoadBtns,
        mainAxisAlignment: MainAxisAlignment.center,
      ));
      return array1;
    }

    return Container(
      child: Column(
        children: _buttonRows(),
      ),
    );
  }
}
