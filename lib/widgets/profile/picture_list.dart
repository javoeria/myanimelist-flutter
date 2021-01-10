import 'package:flutter/material.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:built_collection/built_collection.dart' show BuiltList;
import 'package:myanimelist/constants.dart';

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
          child: Text('Pictures', style: Theme.of(context).textTheme.headline6),
        ),
        Container(
          height: kContainerHeight,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            itemCount: list.length,
            itemBuilder: (context, index) {
              Picture picture = list.elementAt(index);
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: GestureDetector(
                  child: Hero(
                    tag: 'imageHero$index',
                    child: Image.network(
                      picture.large,
                      width: kContainerWidth,
                      height: kContainerHeight,
                      fit: BoxFit.cover,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ImageScreen(index, picture.large),
                        settings: RouteSettings(name: 'ImageScreen'),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
        SizedBox(height: 12.0),
      ],
    );
  }
}

class ImageScreen extends StatelessWidget {
  ImageScreen(this.index, this.url);

  final int index;
  final String url;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Center(
          child: Hero(
            tag: 'imageHero$index',
            child: Image.network(url),
          ),
        ),
        onTap: () => Navigator.pop(context),
      ),
    );
  }
}
