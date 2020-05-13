import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:steveHub/Widgets.dart';
import 'package:steveHub/models/trendWallMOdel.dart';
import 'package:http/http.dart' as http;
import 'package:steveHub/screens/widgets/widgets.dart';
import 'Home.dart';

class start extends StatefulWidget {
  @override
  _startState createState() => _startState();
}

class _startState extends State<start> {
  List<TrendWall> _trend = [];
  bool _isLoading = true;

  getData() async {
    var ran;

    Random random = new Random();

    ran = random.nextInt(10);
    print(ran);

    var responce = await http.get(
      "https://picsum.photos/v2/list?page=$ran&limit=150",
//        headers: {
//      "Authorization":
//          "563492ad6f91700001000001817c8ad7a066468da102118102ef4dc0"
//    }
    );
//    print(responce.body);
    var result = jsonDecode(responce.body);
//    print(result["photos"][0]["src"]["portrait"]);
//    print(result["photos"].length);

    if (result != null) {
      setState(() {
        _isLoading = false;
      });
    }

    for (var i = 0; i < result.length; i++) {
//      myTrendData.add(result["photos"][i]["src"]["portrait"]);
      _trend.shuffle();
      setState(
        () {
          _trend.add(
            TrendWall(
              result[i]['download_url'],
            ),
          );
        },
      );
    }

//    return trend;
    print(_trend);
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (_isLoading == false) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (BuildContext) => Home(_trend),
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Stack(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height - 70,
              alignment: Alignment.center,
              //  decoration: new BoxDecoration(color: Colors.black),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 200),
                  StartBrand(),
                  Spacer(),
                  Container(
                    height: 30,
                    width: 30,
                    alignment: Alignment.center,
                    child: process(),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width - 60,
                    margin: EdgeInsets.only(
                        right: 85.0, left: 85.0, bottom: 10.0, top: 40.0),
                    child: Image.asset(
                      "images/steve.png",
                    ),
                  ),
                  Text(
                    "Made with 💖",
                    style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                        fontFamily: 'arial'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
