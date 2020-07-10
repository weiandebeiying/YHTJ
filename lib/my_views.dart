import 'package:flutter/material.dart';

class MyViews{
  PreferredSizeWidget returnAndMoreAppBar(String title, BuildContext context,List<Widget> ws) {
    return PreferredSize(
        child: AppBar(
          backgroundColor: Colors.white,
          brightness: Brightness.light,
          elevation: 1,
          title: Text(
            title,
            style: TextStyle(color: Colors.black, fontSize: 20),
          ),
          titleSpacing: 0,
          leading: IconButton(
              icon: Image.asset('assets/img/back.png'),
              onPressed: () {
                Navigator.pop(context, true);
              }),
          actions: ws,
        ),
        preferredSize: Size.fromHeight(44));
  }
}