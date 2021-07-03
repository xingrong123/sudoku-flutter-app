import 'package:flutter/material.dart';
import 'package:sudoku_app/main.dart';

import 'myAppBar.dart';
import '../utils/authApi.dart';

class LoginPage extends StatefulWidget {
  static const routeName = '/login';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final myUsernameController = TextEditingController();
  final myPasswordController = TextEditingController();
  bool _enabled = true;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myUsernameController.dispose();
    myPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: Center(
        child: Container(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter username';
                      }
                      return null;
                    },
                    controller: myUsernameController,
                    decoration: InputDecoration(
                        hintText: "Username",
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 20)),
                    style: TextStyle(color: Colors.white, fontSize: 20),
                    enabled: _enabled,
                  ),
                  margin: EdgeInsets.fromLTRB(20, 30, 20, 0),
                  padding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(4),
                    ),
                    color: Colors.black26,
                  ),
                ),
                Container(
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter password';
                      }
                      return null;
                    },
                    controller: myPasswordController,
                    decoration: InputDecoration(
                        hintText: "Password",
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 20)),
                    style: TextStyle(color: Colors.white, fontSize: 20),
                    obscureText: true,
                    enabled: _enabled,
                  ),
                  margin: EdgeInsets.fromLTRB(20, 30, 20, 0),
                  padding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(4),
                    ),
                    color: Colors.black26,
                  ),
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    // Validate returns true if the form is valid, or false otherwise.
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        _enabled = false;
                      });
                      // If the form is valid, display a snackbar. In the real world,
                      // you'd often call a server or save the information in a database.
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Processing Data')));
                      final body = {
                        "username": myUsernameController.text,
                        "password": myPasswordController.text
                      };
                      AuthApi.postRequest("/login", body);
                    }
                  },
                  child: Text('Submit'),
                )
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Color(0xff272537),
    );
  }
}
