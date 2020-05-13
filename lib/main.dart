import 'package:flutter/material.dart';
import 'package:steveHub/screens/start.dart';

void main() => runApp(app());

class app extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "SteveHub",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.black,fontFamily:'arial'),
      home: start(),
    );
  }
}
