import 'package:flutter/material.dart';

class MyTools{
  toPage(context,page,then){
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => page)).then(then);
  }
  hideSoftKeyboard(context){
    FocusScope.of(context).requestFocus(FocusNode());
  }
}