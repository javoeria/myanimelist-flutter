import 'package:flutter/material.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:myanimelist/constants.dart';
import 'package:myanimelist/screens/anime_screen.dart';
import 'package:url_launcher/url_launcher_string.dart';

class WatchScreen extends StatelessWidget {
  const WatchScreen({this.episodes = true});

  final bool episodes;

  @override
  Widget build(BuildContext context) {
    final String type = episodes ? 'episodes' : 'promos';
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          title: Text(episodes ? 'Episode Videos' : 'Anime Trailers'),
          bottom: const TabBar(
            isScrollable: false,
            tabs: <Tab>[
              Tab(text: 'Just Added'),
              Tab(text: 'Most Popular'),
            ],
          ),
        ),
        body: TabBarView(
          children: <AnimeVideos>[
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
  State<AnimeVideos> createState() => _AnimeVideosState();
}

class _AnimeVideosState extends State<AnimeVideos> with AutomaticKeepAliveClientMixin<AnimeVideos> {
  late Future<BuiltList<dynamic>> _future;

  @override
  void initState() {
    super.initState();
    _future = widget.type == 'episodes'
        ? jikan.getWatchEpisodes(popular: widget.subtype == 'popular')
        : jikan.getWatchPromos(popular: widget.subtype == 'popular');
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }

        final BuiltList<dynamic> promoList = snapshot.data!;
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
                      PortraitVideo(promo),
                      SizedBox(
                        width: kImageWidthL,
                        child: InkWell(
                          child: Text(promo.entry.title),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AnimeScreen(promo.entry.malId, promo.entry.title),
                                settings: const RouteSettings(name: 'AnimeScreen'),
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

class PortraitVideo extends StatelessWidget {
  const PortraitVideo(this.promo);

  final dynamic promo;
  final double width = kImageWidthL;
  final double height = kImageHeightXL;

  @override
  Widget build(BuildContext context) {
    return Ink.image(
      image: NetworkImage(promo.entry.imageUrl),
      width: width,
      height: height,
      fit: BoxFit.cover,
      child: InkWell(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const SizedBox(height: 30.0),
            promo is WatchPromo ? playButton() : Container(),
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
        onTap: () async {
          String url = promo is WatchPromo ? promo.videoUrl : promo.episodes[0].url;
          if (await canLaunchUrlString(url)) {
            await launchUrlString(url);
          } else {
            throw 'Could not launch $url';
          }
        },
      ),
    );
  }
}
