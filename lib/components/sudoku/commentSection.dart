import 'package:flutter/material.dart';

class CommentSection extends StatelessWidget {
  final comments;
  CommentSection({required this.comments});

  List buildCommentTree(List comments, parentId) {
    var output = [];
    for (int i = 0; i < comments.length; i++) {
      var comment = comments[i];
      if (comment["reply_to"] == parentId) {
        comment["children"] = buildCommentTree(comments, comment["comment_id"]);
        output.add(comment);
      }
    }
    return output;
  }

  Widget buildFirstLayerComment(comment) {
    return Text(comment["username"] + "  " + comment["comment"]);
  }

  List<Widget> buildOtherLayerComment(comment, parentUser) {
    if ((comment.children as List).length == 0) {
    return [Text("something")];
    }
    List<Widget> output = [];
    if (parentUser != null) {
      output.add(
        Text("something")
      );
    }
    for (int i = 0; i < (comment["children"] as List).length; i++) {
      output.addAll(buildOtherLayerComment(comment["children"][i], comment["username"]));
    }
    return output;
  }

  List<Widget> buildCommentWidgetList(List commentTree) {
    List<Widget> output = [];
    for (int i = 0; i < commentTree.length; i++) {
      output.add(buildFirstLayerComment(commentTree[i]));
      if ((commentTree[i]["children"] as List).length != 0) {
        output.addAll(buildOtherLayerComment(commentTree[i], null));
      }
    }
    return output.reversed.toList();
  }

  @override
  Widget build(BuildContext context) {
    final commentsInTreeForm = buildCommentTree(comments, null);
    final commentsWidgetList = buildCommentWidgetList(commentsInTreeForm);

    return Container(
      child: Column(
        children: commentsWidgetList,
      ),
    );
  }
}
