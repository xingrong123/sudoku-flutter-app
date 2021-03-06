import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {

  @override
  Size get preferredSize => const Size.fromHeight(50);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        "Sudoku",
        style: TextStyle(
          fontSize: 24,
          fontFamily: "Times New Roman",
        ),
      ),
      leading: (ModalRoute.of(context)?.canPop ?? false) ? BackButton() : null,
      centerTitle: true,
      backgroundColor: Colors.black45,
    );
  }
}
