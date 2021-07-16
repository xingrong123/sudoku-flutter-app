import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:sudoku_app/utils/authentication.dart';
import 'package:sudoku_app/utils/sudokuApi.dart';

class StarRating extends StatelessWidget {
  final double avgRating;
  final puzzleId;
  StarRating({required this.avgRating, required this.puzzleId});

  Widget myText(String text) {
    return Text(
      text,
      style: TextStyle(color: Colors.white54),
    );
  }

  void updateRating(int rating, context) {
    final body = {
      "puzzle_id": puzzleId,
      "rating": rating,
    };
    SudokuApi.postRequest("/rate", body).then((res) {
      print("rate success. " + res.data.toString());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('rated successfully'),
        duration: Duration(seconds: 3),
      ));
    }).catchError((err) {
      print(err);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        myText("Ratings"),
        RatingBar(
          initialRating: avgRating,
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemCount: 5,
          ratingWidget: RatingWidget(
            full: Icon(IconData(62432, fontFamily: 'MaterialIcons')),
            half: Icon(IconData(62430,
                fontFamily: 'MaterialIcons', matchTextDirection: true)),
            empty: Icon(IconData(62428, fontFamily: 'MaterialIcons')),
          ),
          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
          onRatingUpdate: (rating) {
            if (Authentication.isAuthenticated) {
              updateRating(rating.toInt(), context);
            }
          },
          ignoreGestures: !Authentication.isAuthenticated,
        ),
        myText(Authentication.isAuthenticated
            ? "Click to rate puzzle"
            : "login to rate"),
      ],
    ));
  }
}
