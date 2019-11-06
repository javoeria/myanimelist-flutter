import 'package:flutter/material.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:built_collection/built_collection.dart' show BuiltList;
import 'package:url_launcher/url_launcher.dart';

class AnimeVideos extends StatefulWidget {
  AnimeVideos(this.id);

  final int id;

  @override
  _AnimeVideosState createState() => _AnimeVideosState();
}

class _AnimeVideosState extends State<AnimeVideos> with AutomaticKeepAliveClientMixin<AnimeVideos> {
  Future<BuiltList<Promo>> _future;

  @override
  void initState() {
    super.initState();
    _future = Jikan().getAnimeVideos(widget.id);
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

        BuiltList<Promo> promoList = snapshot.data;
        if (promoList.length == 0) {
          return ListTile(title: Text('No items found.'));
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Center(
            child: Wrap(
              spacing: 16.0,
              runSpacing: 16.0,
              children: promoList.map((Promo promo) {
                return VideoImage(promo);
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

class VideoImage extends StatelessWidget {
  VideoImage(this.promo);

  final Promo promo;
  final double width = 320.0;
  final double height = 180.0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Ink.image(
          image: NetworkImage(promo.imageUrl),
          width: width,
          height: height,
          fit: BoxFit.cover,
          child: InkWell(
            onTap: () async {
              String url = promo.videoUrl;
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw 'Could not launch $url';
              }
            },
          ),
        ),
        Container(
          height: height,
          width: width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(),
              Align(
                alignment: Alignment.center,
                child: Container(
                  padding: const EdgeInsets.all(4.0),
                  color: Colors.black54,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(Icons.play_circle_outline),
                      Text(' Play', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              ),
              Stack(
                alignment: AlignmentDirectional.bottomStart,
                children: <Widget>[
                  Image.asset('images/box_shadow.png', width: width, height: 30.0, fit: BoxFit.cover),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      promo.title,
                      maxLines: 3,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.0,
                        shadows: <Shadow>[
                          Shadow(
                            offset: Offset(0.0, 0.0),
                            blurRadius: 3.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
