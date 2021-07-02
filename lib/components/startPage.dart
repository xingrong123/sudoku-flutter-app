import 'package:flutter/material.dart';

class StartPage extends StatelessWidget {
  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    _onPressed() {
      Navigator.pushNamed(
        context,
        '/homepage',
      );
    }

    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text("Welcome", style: TextStyle(color: Colors.white, fontSize: 32)),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => _onPressed(),
              child: Container(
                child: Center(child: Text("skip", style: TextStyle(color: Colors.white, fontSize: 20), textAlign: TextAlign.center),), 
                height: 40,
                width: 60,
              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.black45,
              ),
            ),
          ],
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
        ),
      ),
      backgroundColor: Color(0xff272537),
    );
  }
}
