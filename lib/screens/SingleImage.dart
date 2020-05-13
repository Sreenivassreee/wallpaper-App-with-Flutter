import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'dart:async';
import 'package:permission_handler/permission_handler.dart';
import 'package:percent_indicator/percent_indicator.dart';

class SingleImage extends StatefulWidget {
  final String imageUrl;
  SingleImage(this.imageUrl);
  @override
  _SingleImageState createState() => _SingleImageState();
}

class _SingleImageState extends State<SingleImage> {
  bool isDownload = false;
  String persentage = "0";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Hero(
        tag: widget.imageUrl,
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              color: Colors.black,
              child: kIsWeb
                  ? Image.network(widget.imageUrl, fit: BoxFit.cover)
                  : CachedNetworkImage(
                      imageUrl: widget.imageUrl,
                      fit: BoxFit.cover,
                    ),
            ),
            Center(
              child: isDownload == true
                  ? Container(
                      decoration: BoxDecoration(
                        color: Colors.black38,
                        borderRadius: BorderRadius.circular(
                          20.0,
                        ),
                      ),
                      height: 150,
                      width: 150,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          persentage != null
                              ? CircularPercentIndicator(
                                  radius: 100.0,
                                  lineWidth: 10.0,
                                  animation: true,
                                  backgroundColor: Colors.white,
                                  animationDuration: 5000,
                                  percent: 1,
                                  circularStrokeCap: CircularStrokeCap.round,
                                  center: Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 10.0),
                                    child: new Text(
                                      "${persentage}",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 17.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  progressColor: Colors.purple,
                                )
                              : null,
                          Text(
                            "Please Wait...",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12.0,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            "Downloading to Gallery",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12.0,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                    )
                  : null,
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        child: Icon(
          Icons.arrow_downward,
          color: Colors.white,
        ),
        onPressed: () {
          _save();
          setState(() {
            isDownload = true;
          });
//          print("Downloaded");
        },
      ),
    );
  }

  _save() async {
    await _askPermission();
    var response = await Dio().get(
      widget.imageUrl,
      onReceiveProgress: (rec, total) {
        setState(() {
          persentage = ((rec / total) * 100).toStringAsFixed(0);
        });
      },
      options: Options(
        responseType: ResponseType.bytes,
      ),
    );

    print("responce $response");
    print(widget.imageUrl);
    final result = await ImageGallerySaver.saveImage(
      Uint8List.fromList(
        response.data,
      ),
    );
    print(result);
    setState(() {
      isDownload = false;
    });

    Navigator.pop(context);
  }

  _askPermission() async {
    var status = await Permission.storage.status;

    print(status);

    if (status.isUndetermined) {
      requestPermission(Permission.storage);
    } else if (status.isDenied) {
      requestPermission(Permission.storage);
    }
  }

  Future<void> requestPermission(Permission permission) async {
    final status = await permission.request();
    print(status);
  }
}
