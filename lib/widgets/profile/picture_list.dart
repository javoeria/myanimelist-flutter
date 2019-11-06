import 'package:flutter/material.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:built_collection/built_collection.dart' show BuiltList;

class PictureList extends StatelessWidget {
  PictureList(this.list);

  final BuiltList<Picture> list;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Divider(height: 0.0),
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 12.0),
          child: Text('Pictures', style: Theme.of(context).textTheme.title),
        ),
        Container(
          height: 163.0,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            itemCount: list.length,
            itemBuilder: (context, index) {
              Picture picture = list.elementAt(index);
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: Image.network(picture.large, width: 108.0, height: 163.0, fit: BoxFit.cover),
              );
            },
          ),
        ),
        SizedBox(height: 12.0),
      ],
    );
  }
}
