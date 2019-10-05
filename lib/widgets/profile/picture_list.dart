import 'package:flutter/material.dart';
import 'package:jikan_dart/jikan_dart.dart';
import 'package:built_collection/built_collection.dart' show BuiltList;

class PictureList extends StatefulWidget {
  PictureList(this.id, {this.type});

  final int id;
  final TopType type;

  @override
  _PictureListState createState() => _PictureListState();
}

class _PictureListState extends State<PictureList> with AutomaticKeepAliveClientMixin<PictureList> {
  Future _future;

  @override
  void initState() {
    super.initState();
    switch (widget.type) {
      case TopType.anime:
        _future = JikanApi().getAnimePictures(widget.id);
        break;
      case TopType.manga:
        _future = JikanApi().getMangaPictures(widget.id);
        break;
      case TopType.characters:
        _future = JikanApi().getCharactersPictures(widget.id);
        break;
      case TopType.people:
        _future = JikanApi().getPersonPictures(widget.id);
        break;
      default:
    }
  }

  Widget picturesTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Text('Pictures', style: Theme.of(context).textTheme.title),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              picturesTitle(),
              Container(height: 175.0, child: Center(child: CircularProgressIndicator())),
            ],
          );
        }

        BuiltList<Picture> pictures = snapshot.data;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            picturesTitle(),
            Container(
              height: 163.0,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                itemCount: pictures.length,
                itemBuilder: (context, index) {
                  Picture picture = pictures.elementAt(index);
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
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
