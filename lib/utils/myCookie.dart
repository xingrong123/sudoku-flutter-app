import 'package:http/http.dart' as http;

class MyCookie {
  static Map<String, String> headers = {
    "content-type": "application/json; charset=UTF-8"
  };
  static Map<String, String> cookies = {};

  static update(http.Response response) {
    var allSetCookie = response.headers['set-cookie'];
    // set username;
    if (response.headers['username'] != null) {
      headers['username'] = response.headers['username'].toString();
    }

    if (allSetCookie != null) {
      var setCookies = allSetCookie.split(',');

      for (var setCookie in setCookies) {
        var cookies = setCookie.split(';');

        for (var cookie in cookies) {
          _setCookie(cookie);
        }
      }

      headers['cookie'] = _generateCookieHeader();
    }
  }

  static void _setCookie(String rawCookie) {
    if (rawCookie.length > 0) {
      var keyValue = rawCookie.split('=');
      if (keyValue.length == 2) {
        var key = keyValue[0].trim();
        var value = keyValue[1];

        // ignore keys that aren't cookies
        if (key == 'path' || key == 'expires') return;

        cookies[key] = value;
      }
    }
  }

  static String _generateCookieHeader() {
    String cookie = "";

    for (var key in cookies.keys) {
      if (cookie.length > 0) cookie += ";";
      cookie += key + "=" + cookies[key].toString();
    }
    print("cookie: " + cookie);

    return cookie;
  }

  static getUsername() {
    return headers["username"];
  }

  static logout() {
    headers.remove("cookie");
    headers.remove("username");
  }
}
