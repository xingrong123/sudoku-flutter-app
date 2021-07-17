import 'package:flutter/material.dart';

import '../../utils/authentication.dart';
import '../../utils/sudokuApi.dart';
import './commentSection.dart';

class CommentBox extends StatefulWidget {
  final comment;
  final puzzleId;
  final Function setComments;
  final parentUser;
  CommentBox({
    required this.comment,
    required this.puzzleId,
    required this.setComments,
    this.parentUser,
  });

  @override
  _CommentBoxState createState() => _CommentBoxState();
}

class _CommentBoxState extends State<CommentBox> {
  final _formKey = GlobalKey<FormState>();
  bool _replyIsExpanded = false;
  final myReplyController = TextEditingController();
  bool _enabled = true;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myReplyController.dispose();
    super.dispose();
  }

  _onPressHandler(context) {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() {
      _enabled = false;
    });
    final body = {
      'puzzle_id': widget.puzzleId,
      'reply_to': widget.comment["comment_id"],
      'comment': myReplyController.text,
    };
    SudokuApi.postRequest("/comment", body).then((res) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('reply posted'),
        duration: Duration(seconds: 3),
      ));
      FocusManager.instance.primaryFocus?.unfocus();
      SudokuApi.getRequest("/puzzle/" + widget.puzzleId.toString()).then((res) {
        print(res.data["comments"]);
        final commentsInTreeForm =
            CommentSection.buildCommentTree(res.data["comments"], null);
        widget.setComments(CommentSection.buildCommentWidgetList(
            commentsInTreeForm, widget.puzzleId, widget.setComments));
        myReplyController.clear();
        _replyIsExpanded = !_replyIsExpanded;
      }).catchError((err) {
        throw (err);
      });
    }).catchError((err) {
      print(err);
    });
    setState(() {
      _enabled = true;
    });
  }

  Widget replyButtonText() {
    if (Authentication.isAuthenticated) {
      return Row(
        children: [
          Icon(
            const IconData(58202, fontFamily: 'MaterialIcons'),
            size: 20,
          ),
          Text("reply", style: TextStyle(fontSize: 12.0)),
        ],
      );
    } else {
      return Align(
        alignment: Alignment.centerLeft,
        child: Text(
          "Login to reply",
          style: TextStyle(fontSize: 12.0),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: widget.parentUser == null
          ? EdgeInsets.fromLTRB(12, 8, 12, 0)
          : EdgeInsets.fromLTRB(24, 8, 12, 0),
      color: Colors.white38,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.comment["username"],
                      style: TextStyle(fontSize: 20.0),
                    ),
                    Text(
                      widget.comment["date_created"],
                      style: TextStyle(fontSize: 12.0),
                    )
                  ],
                ),
                Divider(
                  color: Colors.black45,
                ),
                widget.parentUser != null
                    ? Container(
                        margin: EdgeInsets.all(8),
                        child: Text(
                          "reply to " + widget.parentUser,
                          style: TextStyle(fontSize: 12.0),
                        ),
                      )
                    : SizedBox.shrink(),
                Container(
                  margin: EdgeInsets.all(8),
                  child: Text(
                    widget.comment["comment"],
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
              ],
            ),
          ),
          Theme(
            data: ThemeData(accentColor: Color(0xff272537)),
            child: IgnorePointer(
                ignoring: !Authentication.isAuthenticated,
                child: ExpansionPanelList(
                  expansionCallback: (index, isExpanded) => setState(() {
                    _replyIsExpanded = !isExpanded;
                  }),
                  children: [
                    ExpansionPanel(
                        backgroundColor: Colors.white38,
                        canTapOnHeader: true,
                        isExpanded: _replyIsExpanded,
                        headerBuilder: (_, isExpanded) {
                          return Container(
                            child: replyButtonText(),
                            padding: EdgeInsets.all(8),
                          );
                        },
                        body: ListTile(
                          title: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 12),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(4),
                                    ),
                                    color: Colors.black12,
                                  ),
                                  child: Form(
                                    key: _formKey,
                                    child: TextFormField(
                                      maxLines: null,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your reply';
                                        }
                                        return null;
                                      },
                                      controller: myReplyController,
                                      decoration: InputDecoration(
                                          hintText: "reply",
                                          hintStyle: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 20)),
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                      enabled: Authentication.isAuthenticated &&
                                          _enabled,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 4),
                              ElevatedButton(
                                onPressed:
                                    Authentication.isAuthenticated && _enabled
                                        ? () => _onPressHandler(context)
                                        : null,
                                child: Text('Reply'),
                              ),
                            ],
                          ),
                        )),
                  ],
                )),
          ),
        ],
      ),
    );
  }
}
