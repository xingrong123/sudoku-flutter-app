import 'package:flutter/material.dart';

class StartPage extends StatelessWidget {
  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    _onPressedRegister() {
      Navigator.pushNamed(
        context,
        '/register',
      );
    }

    _onPressedLogin() {
      Navigator.pushNamed(
        context,
        '/login',
      );
    }

    _onPressedSkip() {
      Navigator.pushNamed(
        context,
        '/homepage',
      );
    }

    Widget _button(text, onClick) {
      return ElevatedButton(
        onPressed: () => onClick(),
        child: Container(
          child: Center(
            child: Text(text,
                style: TextStyle(color: Colors.white, fontSize: 20),
                textAlign: TextAlign.center),
          ),
          height: 40,
          width: 80,
        ),
        style: ElevatedButton.styleFrom(
          primary: Colors.black45,
        ),
      );
    }

    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text("Welcome",
                style: TextStyle(color: Colors.white, fontSize: 32)),
            SizedBox(height: 30),
            _button("register", () => _onPressedRegister()),
            SizedBox(height: 30),
            _button("login", () => _onPressedLogin()),
            SizedBox(height: 30),
            _button("skip", () => _onPressedSkip()),
          ],
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
        ),
      ),
    );
  }
}
