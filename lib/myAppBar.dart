import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget{
  @override
  Size get preferredSize => const Size.fromHeight(50);
  
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text("something"),
    );
  }
}
