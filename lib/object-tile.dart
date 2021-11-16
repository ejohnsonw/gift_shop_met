import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gift_shop_met/fade-route.dart';
import 'package:gift_shop_met/object-detail.dart';
import 'package:gift_shop_met/webservice.dart';

class ObjectTile extends StatefulWidget {
  String objectID;

  ObjectTile({Key? key, required this.objectID}) : super(key: key);

  @override
  _ObjectTileState createState() {
    return _ObjectTileState();
  }
}

class _ObjectTileState extends State<ObjectTile> {
  Map object = Map();

  @override
  void initState() {
    super.initState();
    retrieveObject();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size s = MediaQuery.of(context).size;
    double ww = s.width;
    double hh = s.height * 0.50;

    if (object['objectName'] != null) {
      return InkWell(
          onTap: () {
            Navigator.push(
                context,
                FadeRoute(
                    page: ObjectDetail(
                  object: object,
                )));
          },
          child: Container(
            margin: EdgeInsets.all(10),
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                      child: CachedNetworkImage(
                    fit: BoxFit.fitWidth,
                    imageUrl: object['primaryImageSmall'],
                    placeholder: (context, url) => Center(
                        child: Container(
                      child: Text("loading..."),
                      width: 100,
                      height: 30,
                    )),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  )),
                )
              ],
            ),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black,
                width: 1,
              ),
            ),
          ));
    } else {
      return Container(
        child: Center(),
      );
    }
  }

  retrieveObject() {
    Webservice.retrieveObject(widget.objectID).then((response) {
      if (response.statusCode == 200) {
        if (mounted) {
          setState(() {
            object = (json.decode(utf8.decode(response.bodyBytes)) as Map);
          });
        }
      } else {
        object = Map();
      }
    });
  }
}
