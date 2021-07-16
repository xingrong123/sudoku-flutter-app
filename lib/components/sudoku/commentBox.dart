import 'package:flutter/material.dart';

class CommentBox extends StatelessWidget {
  final comment;
  CommentBox({
    required this.comment,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: () {
          print('Card tapped.');
        },
        child: SizedBox(
          width: 300,
          height: 80,
          child: Text(comment["username"] + " " + comment["comment"]),
        ),
      ),
    );
  }
}
