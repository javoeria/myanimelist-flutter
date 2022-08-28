import 'package:flutter/material.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:myanimelist/constants.dart';
import 'package:myanimelist/screens/anime_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class WatchScreen extends StatelessWidget {
  const WatchScreen({this.episodes = true});

  final bool episodes;

  @override
  Widget build(BuildContext context) {
    String type = episodes ? 'episodes' : 'promos';
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          title: Text(episodes ? 'Episode Videos' : 'Anime Trailers'),
          bottom: TabBar(
            isScrollable: false,
            tabs: const <Tab>[
              Tab(text: 'Just Added'),
              Tab(text: 'Most Popular'),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            AnimeVideos(type: type),
            AnimeVideos(type: type, subtype: 'popular'),
          ],
        ),
      ),
    );
  }
}

class AnimeVideos extends StatefulWidget {
  const AnimeVideos({required this.type, this.subtype = ''});

  final String type;
  final String subtype;

  @override
  _AnimeVideosState createState() => _AnimeVideosState();
}

class _AnimeVideosState extends State<AnimeVideos> with AutomaticKeepAliveClientMixin<AnimeVideos> {
  late Future<BuiltList<dynamic>> _future;

  @override
  void initState() {
    super.initState();
    _future = widget.type == 'episodes'
        ? Jikan().getWatchEpisodes(popular: widget.subtype == 'popular')
        : Jikan().getWatchPromos(popular: widget.subtype == 'popular');
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
      future: _future,
      builder: (context, AsyncSnapshot<BuiltList<dynamic>> snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Center(child: CircularProgressIndicator());
        }

        BuiltList<dynamic> promoList = snapshot.data!;
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
                children: promoList.map((promo) {
                  return Column(
                    children: <Widget>[
                      VideoImage(promo),
                      SizedBox(
                        width: kImageWidthL,
                        child: InkWell(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(promo.entry.title),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AnimeScreen(promo.entry.malId, promo.entry.title),
                                settings: RouteSettings(name: 'AnimeScreen'),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
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

  final dynamic promo;
  final double width = 160.0;
  final double height = 240.0;

  @override
  Widget build(BuildContext context) {
    return Ink.image(
      image: NetworkImage(promo.entry.imageUrl),
      width: width,
      height: height,
      fit: BoxFit.cover,
      child: InkWell(
        onTap: () async {
          String url = promo is WatchPromo ? promo.videoUrl : promo.episodes[0].url;
          if (await canLaunch(url)) {
            await launch(url);
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
                      promo is WatchPromo ? promo.title : promo.episodes[0].title,
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
