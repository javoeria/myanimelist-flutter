import 'package:flutter/material.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:myanimelist/constants.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AnimeVideos extends StatefulWidget {
  const AnimeVideos(this.id);

  final int id;

  @override
  _AnimeVideosState createState() => _AnimeVideosState();
}

class _AnimeVideosState extends State<AnimeVideos> with AutomaticKeepAliveClientMixin<AnimeVideos> {
  late Future<BuiltList<Promo>> _future;

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
      builder: (context, AsyncSnapshot<BuiltList<Promo>> snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Center(child: CircularProgressIndicator());
        }

        BuiltList<Promo> promoList = snapshot.data!;
        if (promoList.isEmpty) {
          return ListTile(title: Text('No items found.'));
        }
        return Scrollbar(
          child: SingleChildScrollView(
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
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class VideoImage extends StatelessWidget {
  const VideoImage(this.promo);

  final Promo promo;
  final double width = 300.0;
  final double height = 170.0;

  @override
  Widget build(BuildContext context) {
    return Ink.image(
      image: NetworkImage(promo.imageUrl),
      width: width,
      height: height,
      fit: BoxFit.cover,
      child: InkWell(
        onTap: () async {
          String url = promo.videoUrl;
          if (await canLaunchUrlString(url)) {
            await launchUrlString(url);
          } else {
            throw 'Could not launch $url';
          }
        },
        child: SizedBox(
          width: width,
          height: height,
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
                    children: const <Widget>[
                      Icon(Icons.play_circle_outline, color: Colors.white),
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
                      style: kTextStyleShadow,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
