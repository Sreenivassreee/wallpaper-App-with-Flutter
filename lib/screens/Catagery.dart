import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:steveHub/Data/Catagery.dart';
import 'package:steveHub/models/Catagery.dart';
import 'cataImages.dart';

CatageryData cata = CatageryData();

class Catagery extends StatefulWidget {
  @override
  _CatageryState createState() => _CatageryState();
}

class _CatageryState extends State<Catagery> {
  List<CataModel> cataD;
  @override
  void initState() {
    cataD = cata.askCata();
    print(cataD);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            wallPaper(cataD, context),
            Padding(
              padding: const EdgeInsets.all(50.0),
              child: RichText(
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Photos provided by   ',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 16.0),
                    ),
                    TextSpan(
                      text: 'www.pexels.com',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                          fontSize: 16.0),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget wallPaper(List<CataModel> listPhotos, BuildContext context) {
  return Center(
    child: Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 1,
        physics: ClampingScrollPhysics(),
        shrinkWrap: true,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
        children: listPhotos.map(
          (CataModel cataModel) {
            return GridTile(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => cataImages(cataModel.cataName),
                    ),
                  );
                },
                child: Hero(
                  tag: cataModel.cataUrl,
                  child: Stack(
                    children: [
                      Container(
                        child: Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: kIsWeb
                                ? Image.network(
                                    cataModel.cataUrl,
                                    height: 150,
                                    width: 150,
                                    fit: BoxFit.cover,
                                  )
                                : CachedNetworkImage(
                                    imageUrl: cataModel.cataUrl,
                                    height: 150,
                                    width: 150,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                      ),
                      Container(color: Colors.black26),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 0.0),
                        child: Center(
                          child: Container(
                            height: 150,
                            width: 150,
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Text(
                                cataModel.cataName,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ).toList(),
      ),
    ),
  );
}
