import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';

class ObjectActions extends StatefulWidget {
  ObjectActions({Key? key}) : super(key: key);

  @override
  _ObjectActionsState createState() {
    return _ObjectActionsState();
  }
}

class _ObjectActionsState extends State<ObjectActions> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListView(
      // Create a grid with 2 columns. If you change the scrollDirection to
      // horizontal, this produces 2 rows.
      scrollDirection: Axis.horizontal,
      // Generate 100 widgets that display their index in the List.
      children: [
        IconButton(
            iconSize: 35,
            color: Colors.white,
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.shop)),

      ],
    );
  }
}