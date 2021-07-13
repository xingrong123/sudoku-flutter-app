import 'package:flutter/material.dart';

import 'myAppBar.dart';
import '../utils/authApi.dart';
import '../utils/authentication.dart';

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
  bool _invalidLoginCredentials = false;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myUsernameController.dispose();
    myPasswordController.dispose();
    super.dispose();
  }

  _onPressHandler() async {
    setState(() {
      _enabled = false;
    });
    // If the form is valid, display a snackbar. In the real world,
    // you'd often call a server or save the information in a database.
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Processing Data'),
      duration: Duration(minutes: 1),
    ));
    final body = {
      'username': myUsernameController.text,
      'password': myPasswordController.text
    };

    try {
      final response = await AuthApi.postRequest("/login", body);
      print(response.data);
      _invalidLoginCredentials = false;
      Authentication.isAuthenticated = true;
      Navigator.pop(context);
      Navigator.pushNamed(
        context,
        '/homepage',
      );
    } catch (e) {
      print(e.toString());
      setState(() {
        _invalidLoginCredentials = true;
      });
    }

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    _formKey.currentState!.validate();
    setState(() {
      _enabled = true;
    });
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
                SizedBox(height: 30),
                Text("Login", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 24),),
                SizedBox(height: 30),
                Container(
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter username';
                      } else if (_invalidLoginCredentials) {
                        return 'Invalid username or password';
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
                  margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  padding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(4),
                    ),
                    color: Colors.black26,
                  ),
                ),
                SizedBox(height: 30),
                Container(
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter password';
                      } else if (_invalidLoginCredentials) {
                        return 'Invalid username or password';
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
                  margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
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
                  onPressed: _enabled ? () => _onPressHandler() : null,
                  child: Text('Submit'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
