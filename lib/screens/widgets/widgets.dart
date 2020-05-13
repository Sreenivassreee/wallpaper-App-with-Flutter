import 'package:flutter/material.dart';

Widget process() {
  return Center(
    child: SizedBox(
      height: 50,
      width: 50,
      child: CircularProgressIndicator(
        backgroundColor: Colors.red,
      ),
    ),
  );
}
