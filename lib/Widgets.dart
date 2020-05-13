import 'package:flutter/material.dart';

Widget Brand() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Text(
        "Wall",
        style: TextStyle(color: Colors.white,fontFamily: 'arial'),
      ),
      Text(
        "Hub",
        style: TextStyle(color: Colors.red,fontFamily: 'arial'),
      ),
    ],
  );
}

Widget StartBrand() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Text(
        "Wall",
        style: TextStyle(color: Colors.white, fontSize: 70.0),
      ),
      Text(
        "Hub",
        style: TextStyle(color: Colors.red, fontSize: 70.0),
      ),
    ],
  );
}
