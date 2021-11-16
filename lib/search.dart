import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:gift_shop_met/object-tile.dart';
import 'package:gift_shop_met/webservice.dart';

OutlineInputBorder myinputborder() {
  //return type is OutlineInputBorder
  return OutlineInputBorder(
      //Outline border type for TextField
      borderRadius: BorderRadius.all(Radius.circular(20)),
      borderSide: BorderSide(
        color: Colors.redAccent,
        width: 3,
      ));
}

OutlineInputBorder myfocusborder() {
  return OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(20)),
      borderSide: BorderSide(
        color: Colors.greenAccent,
        width: 3,
      ));
}

class SearchWidget extends StatefulWidget {
  SearchWidget({Key? key}) : super(key: key);

  @override
  _SearchWidgetState createState() {
    return _SearchWidgetState();
  }
}

class _SearchWidgetState extends State<SearchWidget> {
  TextEditingController _controller = TextEditingController();
  List objectIds = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void hideKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  @override
  Widget build(BuildContext context) {
    if(objectIds.isEmpty){
      search("Gogh");
    }
    // TODO: implement build
    Size s = MediaQuery.of(context).size;
    return Container(
        padding: EdgeInsets.all(5),
        child: ListView(
          shrinkWrap: false,
          scrollDirection: Axis.vertical,
          children: [
            TextField(
              controller: _controller,
              style: TextStyle(fontSize: 16.0),
              cursorColor: Colors.black,
              onChanged: (value) {
                //textUpdated(value);
              },
              decoration: InputDecoration(
                fillColor: Colors.white,
                focusColor: Colors.red,
                hintText: "Search: eg. Van Gogh or horse, pottery",
                focusedBorder: OutlineInputBorder(),
                //focused border
                suffixIcon: IconButton(
                    onPressed: () {
                      search(_controller.text);
                    },
                    icon: Icon(Icons.search)),
                border: OutlineInputBorder(),
              ),
            ),
            Container(
                padding: EdgeInsets.all(15),
                height: MediaQuery.of(context).size.height*0.80,
                width: MediaQuery.of(context).size.width,
                child: display(s)),
          ],
        ),
        color: Colors.white,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height
    );
  }

  Widget display(Size size) {
    if (size.width > 0) {
      return GridView.count(
        // Create a grid with 2 columns. If you change the scrollDirection to
        // horizontal, this produces 2 rows.
        crossAxisCount: Device.get().isPhone ?  2 : 4,
        // Generate 100 widgets that display their index in the List.
        children: List.generate(objectIds.length <= 150 ? objectIds.length : 150, (index) {
          String oid = objectIds[index].toString();
          return  ObjectTile(
              key: ValueKey(oid),
              objectID: oid,
          );
        }),
      );
    } else {
      return ListView.builder(
          physics: ClampingScrollPhysics(),
          shrinkWrap: false,
          scrollDirection: Axis.horizontal,
          itemCount: objectIds.length <= 80 ? objectIds.length : 80,
          itemBuilder: (BuildContext context, int index) {
            String oid = objectIds[index].toString();
            return Center(
              child:
              SingleChildScrollView(child:
              ObjectTile(
                key: ValueKey(oid),
                objectID: oid,
              )),
            );
          });
    }
  }

  search(String value) {
    if (value.length >= 3) {
      hideKeyboard(context);
      Webservice.search(value).then((response) {
        if (response.statusCode == 200) {
          Map resp = (json.decode(utf8.decode(response.bodyBytes)) as Map);
          print(resp.toString());
          if (resp['total'] > 0) {
            objectIds = resp['objectIDs'];
          } else {
            objectIds = [];
          }
        } else {
          objectIds = [];
        }
        setState(() {});
      });
    }
  }
}
