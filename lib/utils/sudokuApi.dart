import 'package:http/http.dart' as http;
import 'dart:convert';
import 'jsonObj.dart';

class SudokuApi {
  static String baseUrl = 'http://sudoku-react-application.herokuapp.com/api';

  static Future<JsonObj> getRequest(string) async {
    final res = await http.get(Uri.parse(baseUrl + string));

    if (res.statusCode == 200) {
      var body = JsonObj(data: jsonDecode(res.body));
      return body;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load');
    }
  }
}
