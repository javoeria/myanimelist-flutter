import 'package:flutter/material.dart';
import 'package:jikan_dart/jikan_dart.dart';
import 'package:built_collection/built_collection.dart' show BuiltList;

class AnimePictures extends StatefulWidget {
  AnimePictures(this.id, {this.anime = true});

  final int id;
  final bool anime;

  @override
  _AnimePicturesState createState() => _AnimePicturesState();
}

class _AnimePicturesState extends State<AnimePictures> with AutomaticKeepAliveClientMixin<AnimePictures> {
  Future<BuiltList<Picture>> _future;

  @override
  void initState() {
    super.initState();
    _future = widget.anime ? JikanApi().getAnimePictures(widget.id) : JikanApi().getMangaPictures(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Center(child: CircularProgressIndicator());
        }

        BuiltList<Picture> pictureList = snapshot.data;
        if (pictureList.length == 0) {
          return ListTile(title: Text('No items found.'));
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Center(
            child: Wrap(
              spacing: 16.0,
              runSpacing: 16.0,
              children: pictureList.map((Picture picture) {
                return Image.network(picture.large, width: 160.0, height: 220.0, fit: BoxFit.cover);
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
