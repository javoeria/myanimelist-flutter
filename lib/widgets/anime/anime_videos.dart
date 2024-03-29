import 'package:flutter/material.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:myanimelist/constants.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AnimeVideos extends StatefulWidget {
  const AnimeVideos(this.id);

  final int id;

  @override
  State<AnimeVideos> createState() => _AnimeVideosState();
}

class _AnimeVideosState extends State<AnimeVideos> with AutomaticKeepAliveClientMixin<AnimeVideos> {
  late Future<BuiltList<Promo>> _future;

  @override
  void initState() {
    super.initState();
    _future = jikan.getAnimeVideos(widget.id);
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

        final BuiltList<Promo> promoList = snapshot.data!;
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
                children: promoList.map((promo) => LandscapeVideo(promo)).toList(),
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

class LandscapeVideo extends StatelessWidget {
  const LandscapeVideo(this.promo);

  final dynamic promo;

  @override
  Widget build(BuildContext context) {
    final double width = promo is Promo ? 320.0 : 220.0;
    final double height = promo is Promo ? 180.0 : 120.0;
    return Ink.image(
      image: NetworkImage(promo.imageUrl.replaceFirst('/maxresdefault.jpg', '/hqdefault.jpg')),
      width: width,
      height: height,
      fit: BoxFit.cover,
      child: InkWell(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            SizedBox(height: 30.0),
            playButton(),
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
        onTap: () async {
          String url = promo.videoUrl;
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
