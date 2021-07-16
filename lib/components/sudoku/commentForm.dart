import 'package:flutter/material.dart';

import '../../utils/authentication.dart';
import '../../utils/sudokuApi.dart';
import 'commentSection.dart';

class CommentForm extends StatefulWidget {
  final puzzleId;
  final setComments;
  CommentForm({required this.puzzleId, required this.setComments});

  @override
  _CommentFormState createState() => _CommentFormState();
}

class _CommentFormState extends State<CommentForm> {
  final _formKey = GlobalKey<FormState>();
  final myCommentController = TextEditingController();
  bool _enabled = true;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myCommentController.dispose();
    super.dispose();
  }

  _onPressHandler() async {
    setState(() {
      _enabled = false;
    });

    final body = {
      'puzzle_id': widget.puzzleId,
      'reply_to': null,
      'comment': myCommentController.text,
    };

    SudokuApi.postRequest("/comment", body).then((res) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('comment posted'),
        duration: Duration(seconds: 3),
      ));
      SudokuApi.getRequest("/puzzle/" + widget.puzzleId.toString()).then((res) {
        print(res.data["comments"]);
        final commentsInTreeForm =
            CommentSection.buildCommentTree(res.data["comments"], null);
        widget.setComments(
            CommentSection.buildCommentWidgetList(commentsInTreeForm));
      }).catchError((err) {
        throw(err);
      });
    }).catchError((err) {
      print(err);
    });
    _formKey.currentState!.validate();
    setState(() {
      _enabled = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: 30),
                Text(
                  "Comments",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
                SizedBox(height: 16),
                Container(
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your comments';
                      }
                      return null;
                    },
                    controller: myCommentController,
                    decoration: InputDecoration(
                        hintText: "Join the discussion",
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 20)),
                    style: TextStyle(color: Colors.white, fontSize: 20),
                    enabled: Authentication.isAuthenticated && _enabled,
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
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: Authentication.isAuthenticated && _enabled ? () => _onPressHandler() : null,
                  child: Text('Post'),
                )
              ],
            ),
          ),
    );
  }
}
