import 'package:http/http.dart' as http;
import 'dart:convert';

import 'jsonObj.dart';
import 'myCookie.dart';

class SudokuApi {
  static final String _baseUrl =
      'http://sudoku-react-application.herokuapp.com/api';

  static Future<JsonObj> getRequest(String string) async {
    final res =
        await http.get(Uri.parse(_baseUrl + string), headers: MyCookie.headers);
    MyCookie.update(res);

    if (res.statusCode == 200) {
      var body = JsonObj(data: jsonDecode(res.body));
      return body;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load');
    }
  }

  static Future<JsonObj> postRequest(String string, dynamic body) async {
    final res = await http.post(Uri.parse(_baseUrl + string),
        headers: MyCookie.headers, body: jsonEncode(body));
    MyCookie.update(res);

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
