class SudokuLogic {
  static bool checkWin(List squares) {
    if (squares.contains(null)) return false;
    List<List> check = [];
    for (int i = 0; i < 9; i++) {
      check.add(squares.sublist(i * 9, i * 9 + 9));
    }
    for (int i = 0; i < 9; i++) {
      List array = [];
      for (int j = 0; j < 9; j++) {
        array.add(squares[j * 9 + i]);
      }
      check.add(array);
    }
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        List array = [];
        for (int k = 0; k < 3; k++) {
          for (int m = 0; m < 3; m++) {
            int index = (i * 3 + k) * 9 + (j * 3 + m);
            array.add(squares[index]);
          }
        }
        check.add(array);
      }
    }
    for (int i = 0; i < check.length; i++) {
      for (int j = 1; j <= 9; j++) {
        if (!check[i].contains(j)) return false;
      }
    }
    return true;
  }

  static int calculateTimeInSecondsFromStringFormat(String time) {
    final timeArray = time.split(":");
    int timeInSeconds = int.parse(timeArray[0]) * 3600 +
        int.parse(timeArray[1]) * 60 +
        int.parse(timeArray[2]);
    return timeInSeconds;
  }

  static String formatTime(int milliseconds, int startTimeInSeconds) {
    var secs = milliseconds ~/ 1000 + startTimeInSeconds;
    var hours = (secs ~/ 3600).toString().padLeft(2, '0');
    var minutes = ((secs % 3600) ~/ 60).toString().padLeft(2, '0');
    var seconds = (secs % 60).toString().padLeft(2, '0');
    return "$hours:$minutes:$seconds";
  }
}
