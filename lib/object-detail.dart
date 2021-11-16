import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:network_image_safe_provider/network_image_safe_provider.dart';
import 'package:photo_view/photo_view.dart';

class ObjectDetail extends StatefulWidget {
  Map object;

  ObjectDetail({Key? key, required this.object}) : super(key: key);

  @override
  _ObjectDetailState createState() {
    return _ObjectDetailState();
  }
}

class _ObjectDetailState extends State<ObjectDetail> {
  bool showMenu = true;
  late String currentImage;
  late List additionals;

  @override
  void initState() {
    super.initState();
    additionals = json.decode(json.encode(widget.object['additionalImages']));
    additionals.add(widget.object['primaryImage']);
    currentImage = widget.object['primaryImage'];
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size s = MediaQuery.of(context).size;
    double ww = s.width;
    double hh = s.height;
    return Scaffold(
        body: Stack(
      children: [
        Positioned(
            top: 0,
            left: 0,
            bottom: 0,
            right: 0,
            child: InkWell(
                onTap: () {
                  setState(() {
                    showMenu = !showMenu;
                  });
                },
                child: Container(
                  height: hh,
                  width: ww,
                  child: PhotoView(
                      // minScale: 0.30,
                      maxScale: 2.0,
                      imageProvider: NetworkImageSafeProvider(currentImage, placeholder: 'assets/images/dots.png')),
                ))),
        showMenu && additionals.length > 1
            ? Positioned(
                bottom: 0,
                left: 0,
                width: ww,
                height: hh * 0.15,
                child: Container(
                  // width: ww,
                  // height: hh * 0.2,
                  color: Colors.black,
                  child: additionals.length > 1 ? ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: additionals.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                            onTap: () {
                              setState(() {
                                currentImage = additionals[index];
                              });
                            },
                            child:
                                Container(width: ww / 3, height: hh / 6, padding: EdgeInsets.all(5), child:
                                CachedNetworkImage(
                                  fit: BoxFit.fitWidth,
                                  imageUrl: additionals[index],
                                  placeholder: (context, url) => Center(
                                      child: Container(
                                        child: Text("loading..."),
                                        width: 30,
                                        height: 30,
                                      )),
                                  errorWidget: (context, url, error) => Icon(Icons.error),
                                )
                                )
                        );
                      }) : Container(),
                ),
              )
            : Container(),
        showMenu
            ? AnimatedPositioned(
                duration: Duration(seconds: 1),
                top: 0,
                left: 0,
                width: ww,
                // height: hh * 0.2,
                child: Container(
                  // width: ww,
                  // height: hh * 0.2,
                  color: Colors.white54,
                  padding: EdgeInsets.all(5),
                  child: Column(
                    children: [
                      Row(children: [
                        IconButton(
                            iconSize: 35,
                            color: Colors.black,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(Icons.chevron_left)),
                        Flexible(
                          // width: ww,
                          // height: hh * 0.2,
                          child: widget.object['title'] != null
                              ? Text(widget.object['title'] + " " + widget.object['objectID'].toString())
                              : widget.object['description'] + " " + widget.object['objectID'].toString(),
                        ),
                      ]),
                      widget.object['artistDisplayName'] != null ? Text(widget.object['medium']+" | "+widget.object['objectDate']+" | "+widget.object['artistDisplayName']+"") : Container(),
                    ],
                  ),
                ),
              )
            : Container()
      ],
    ));
  }
}
