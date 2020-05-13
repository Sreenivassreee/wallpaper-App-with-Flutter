import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:steveHub/Widgets.dart';
import 'package:steveHub/models/cataPics.dart';
import 'package:steveHub/screens/Catagery.dart';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:steveHub/screens/widgets/widgets.dart';
import 'SingleImage.dart';

class cataImages extends StatefulWidget {
  final String cataName;
  cataImages(this.cataName);
  @override
  _cataImagesState createState() => _cataImagesState();
}

class _cataImagesState extends State<cataImages> {
  List<CataPics> mycataData = new List();
  List<CataPics> cataImages = [];
  bool _isLoading = true;
  var finalUrl;

  getDataCataData() async {
    var ran;
    print("hi");
    Random random = new Random();

    if (widget.cataName == "Coding") {
      setState(() {
        ran = 1 + random.nextInt(6 - 1);
//        print("aaaaaaaaaaa :: $ran");
      });
    } else if (widget.cataName == "Skills") {
      setState(() {
        ran = 1 + random.nextInt(25 - 1);
//        print("aaaaaaaaaaa :: $ran");
      });
    } else if (widget.cataName == "Bikes") {
      setState(() {
        ran = 1 + random.nextInt(15 - 1);
//        print("aaaaaaaaaaa :: $ran");
      });
    } else if (widget.cataName == "Enginer") {
      setState(() {
        ran = 1 + random.nextInt(15 - 1);
//        print("aaaaaaaaaaa :: $ran");
      });
    } else {
      setState(() {
        ran = 1 + random.nextInt(60 - 1);
//        print("aaaaaaaaaaa :: $ran");
      });
    }
    var responce = await http.get(
      "https://api.pexels.com/v1/search?query=${widget.cataName}&per_page=30&page=${ran}",
      headers: {
        "Authorization":
            "563492ad6f917000010000011dec1dbfa49d4e31b0e4bc41e4a77dfd",
      },
    );

//    print(responce.body);
    var result = jsonDecode(responce.body);
//    print(result["photos"][0]["src"]["portrait"]);
    if (result != null) {
      setState(() {
        _isLoading = false;
      });
    }

    print(result["photos"].length);

    for (var i = 0; i < result['photos'].length; i++) {
      cataImages.shuffle();
      cataImages.shuffle();

      //      myTrendData.add(result["photos"][i]["src"]["portrait"]);
      setState(
        () {
          cataImages.add(
            CataPics(
              result["photos"][i]["src"]["portrait"],
            ),
          );
        },
      );
    }
    print(cataImages);
    setState(() {
      cataImages.shuffle();
    });
//    return trend;
  }

  @override
  void initState() {
    getDataCataData();
    super.initState();
  }

//  @override
//  void setState(fn) {
//    finalUrl = cataImages;
//  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: Text(widget.cataName)),
      body: _isLoading == false
          ? SingleChildScrollView(
              child: Column(
                children: [
                  wallPaper(cataImages, context, widget.cataName),
                  Container(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          "Each Time you load the Page You Get new Wallpapers",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : process(),
    );
  }

  Widget wallPaper(
      List<CataPics> listPhotos, BuildContext context, String cataName) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 0.6,
        physics: ClampingScrollPhysics(),
        shrinkWrap: true,
        padding: const EdgeInsets.all(0.0),
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
        children: listPhotos.map(
          (CataPics cataPics) {
            return GridTile(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SingleImage(cataPics.cataPicUrl),
                    ),
                  );
                },
                child: Hero(
                  tag: cataPics.cataPicUrl,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xffd69ae5),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: kIsWeb
                          ? Image.network(
                              cataPics.cataPicUrl,
                              height: 50,
                              width: 100,
                              fit: BoxFit.cover,
                            )
                          : CachedNetworkImage(
                              imageUrl: cataPics.cataPicUrl,
                              height: 50,
                              width: 100,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                ),
              ),
            );
          },
        ).toList(),
      ),
    );
  }
}
