import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:steveHub/Widgets.dart';
import 'package:steveHub/models/trendWallMOdel.dart';
import 'package:steveHub/screens/Catagery.dart';
import 'package:steveHub/screens/widgets/widgets.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'Search.dart';
import 'SingleImage.dart';

class Home extends StatefulWidget {
  List<TrendWall> treng = [];
  Home(this.treng);
  @override
  _HomeState createState() => _HomeState(treng);
}

class _HomeState extends State<Home> {
  List<TrendWall> treng = [];
  _HomeState(this.treng);
//  Data data = Data();
//  TrendWall td = TrendWall();
//  List<TrendWall> treng2 = [];

  bool _isLoading = true;
//  bool _isLoading2 = true;

  int _page = 0;
  GlobalKey _bottomNavigationKey = GlobalKey();

  @override
  void setState(fn) {
    super.setState(fn);
  }

//  getDataMe() async {
//    print("Pease");
//
//    var ran;
//    if (treng2 == null) {
//      treng.clear();
//      for (var i = 1; i <= treng2.length; i++) {
//        setState(() {
//          treng[i] == treng2[i];
//          print(i);
//          print(treng2.length);
//        });
//      }
//
//      treng2.clear();
//    }
//    Random random = new Random();
//
//    ran = random.nextInt(10);
//    print(ran);
//
//    var responce = await http.get(
//      "https://picsum.photos/v2/list?page=$ran&limit=200",
////        headers: {
////      "Authorization":
////          "563492ad6f91700001000001817c8ad7a066468da102118102ef4dc0"
////    }
//    );
////    print(responce.body);
//    var result = jsonDecode(responce.body);
////    print(result["photos"][0]["src"]["portrait"]);
////    print(result["photos"].length);
//
//    if (result != null) {
//      setState(() {
//        _isLoading2 = false;
//      });
//    }
//    treng2.clear();
//
//    for (var i = 0; i < result.length; i++) {
////      myTrendData.add(result["photos"][i]["src"]["portrait"]);
//
//      setState(
//        () {
//          print("Adding");
//          treng2.add(
//            TrendWall(
//              result[i]['download_url'],
//            ),
//          );
//        },
//      );
//    }
////    treng = treng2;
////    return trend;
//    print(treng2);
//  }

  @override
  Widget build(BuildContext context) {
    if (treng != null) {
      setState(() {
        _isLoading = false;
      });
    }

    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        items: <Widget>[
          Icon(Icons.trending_up, size: 30),
          Icon(Icons.category, size: 30),
          Icon(Icons.search, size: 30),
        ],
        onTap: (index) {
          setState(() {
            _page = index;
          });
        },
        color: Colors.white,
        buttonBackgroundColor: Colors.white,
        backgroundColor: Colors.transparent,
        height: 50.0,
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 300),
      ),
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        title: Brand(),
        actions: [
          IconButton(
            onPressed: () {
              _launchURL("https://www.instagram.com/sreenivas__k/");
            },
            icon: Icon(
              Icons.person,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: () {
              _launchURL("https://www.instagram.com/stevebrains_official/");
            },
            icon: Icon(
              Icons.trending_up,
              color: Colors.white,
            ),
          ),
          SizedBox(
            width: 10.0,
          )
        ],
      ),
      body:
//      isLoading == false
//          ? wallPaper(finalUrl, context)
//          :
          _page == 0
              ? _isLoading == true
                  ? process()
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          wallPaper(treng, context),
                          Container(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.all(30.0),
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  "Each Time you load the Application You Get new Wallpapers",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
              : _page == 1 ? Catagery() : Search(),
    );
  }
}

_launchURL(url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

Widget wallPaper(List<TrendWall> listPhotos, BuildContext context) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 16),
    child: GridView.count(
      crossAxisCount: 2,
      childAspectRatio: 0.6,
      physics: ClampingScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.all(0),
      mainAxisSpacing: 8.0,
      crossAxisSpacing: 8.0,
      children: listPhotos.map(
        (TrendWall photoModel) {
          return GridTile(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SingleImage(photoModel.trendUrl),
                  ),
                );
              },
              child: Hero(
                tag: photoModel.trendUrl,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Color(0xffdeaeea),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: kIsWeb
                        ? Image.network(
                            photoModel.trendUrl,
                            height: 50,
                            width: 100,
                            fit: BoxFit.cover,
                          )
                        : CachedNetworkImage(
                            imageUrl: photoModel.trendUrl,
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
