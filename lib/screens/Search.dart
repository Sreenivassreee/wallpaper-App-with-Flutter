import 'dart:convert';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:steveHub/models/cataPics.dart';
import 'package:http/http.dart' as http;
import 'package:steveHub/screens/widgets/widgets.dart';
import 'SingleImage.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController SearchText = TextEditingController();

  String SearchT = "";
  List<CataPics> myTrendData = new List();
  List<CataPics> searchA = [];
  bool _isLoading = false;
  var finalUrl;

  @override
  Widget build(BuildContext context) {
    print(SearchT);
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SearchW(),
            SizedBox(
              height: 20.0,
            ),
            _isLoading == false
                ? wallPaper(
                    searchA,
                    context,
                  )
                : process(),
          ],
        ),
      ),
    );
  }

  getDataSearch(SearchT) async {
    var ran;

    Random random = new Random();

    print("hi");
    setState(() {
      ran = 1 + random.nextInt(5 - 1);
      print(ran);
    });

    var responce = await http.get(
        "https://api.pexels.com/v1/search?query=${SearchT}&per_page=15&page=${ran}",
        headers: {
          "Authorization":
              "563492ad6f91700001000001817c8ad7a066468da102118102ef4dc0"
        });
//    print(responce.body);

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
      searchA.shuffle();

      //      myTrendData.add(result["photos"][i]["src"]["portrait"]);
      setState(
        () {
          searchA.add(
            CataPics(
              result["photos"][i]["src"]["portrait"],
            ),
          );
        },
      );
    }

    print(searchA);
    setState(() {
      searchA.shuffle();
    });
//    return trend;
  }

  Widget SearchW() {
    TextEditingController SearchText = TextEditingController();

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Color(0xfff5f8fd),
            borderRadius: BorderRadius.circular(30.0),
          ),
          margin: EdgeInsets.only(left: 20.0, right: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: TextField(
                      onSubmitted: (value) {
                        setState(() {
                          SearchT = SearchText.text;
                          _isLoading = true;
                        });
                        getDataSearch(SearchT);
                      },
                      controller: SearchText,
                      cursorColor: Colors.red,
                      autocorrect: true,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                      decoration: InputDecoration(
                        hintText: "Search",
                        fillColor: Colors.red,
                        hoverColor: Colors.red,
                        focusColor: Colors.red,
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.search,
                ),
                onPressed: () {
                  setState(() {
                    SearchT = SearchText.text;
                    _isLoading = true;
                  });
                  getDataSearch(SearchT);
                },
              )
            ],
          ),
        )
      ],
    );
  }

  searchFunction() {
    setState(() {
      SearchT = SearchText.text;
      _isLoading = true;
    });
    getDataSearch(SearchT);
  }

  Widget wallPaper(List<CataPics> listPhotos, BuildContext context) {
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
          (CataPics photoModel) {
            return GridTile(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SingleImage(photoModel.cataPicUrl),
                    ),
                  );
                },
                child: Hero(
                  tag: photoModel.cataPicUrl,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Color(0xffdeaeea),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: kIsWeb
                          ? Image.network(
                              photoModel.cataPicUrl,
                              height: 50,
                              width: 100,
                              fit: BoxFit.cover,
                            )
                          : CachedNetworkImage(
                              imageUrl: photoModel.cataPicUrl,
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
