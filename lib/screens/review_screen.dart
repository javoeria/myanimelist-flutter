import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:myanimelist/constants.dart';
import 'package:myanimelist/jikan_v4.dart';
import 'package:myanimelist/screens/anime_screen.dart';
import 'package:myanimelist/screens/manga_screen.dart';
import 'package:myanimelist/screens/user_profile_screen.dart';

class ReviewScreen extends StatelessWidget {
  ReviewScreen({this.anime = true});

  final bool anime;
  final DateFormat f = DateFormat('MMM d, yyyy');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(anime ? 'Anime Reviews' : 'Manga Reviews'),
      ),
      body: FutureBuilder(
        future: JikanV4().getReviews(anime: anime),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Center(child: CircularProgressIndicator());
          }

          List<dynamic> items = snapshot.data!;
          return Scrollbar(
            child: ListView.separated(
              separatorBuilder: (context, index) => Divider(height: 0.0),
              itemCount: items.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> item = items.elementAt(index);
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      InkWell(
                        child: Text(item['entry']['title'], style: Theme.of(context).textTheme.bodyText1),
                        onTap: () {
                          if (anime) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AnimeScreen(item['entry']['mal_id'], item['entry']['title']),
                                settings: RouteSettings(name: 'AnimeScreen'),
                              ),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MangaScreen(item['entry']['mal_id'], item['entry']['title']),
                                settings: RouteSettings(name: 'MangaScreen'),
                              ),
                            );
                          }
                        },
                      ),
                      SizedBox(height: 12.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: <Widget>[
                              Ink.image(
                                image: NetworkImage(item['user']['images']['jpg']['image_url']),
                                width: kImageWidthS,
                                height: kImageHeightS,
                                fit: BoxFit.cover,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => UserProfileScreen(item['user']['username']),
                                        settings: RouteSettings(name: 'UserProfileScreen'),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(width: 8.0),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(item['user']['username']),
                                  SizedBox(height: 4.0),
                                  Text('${item['votes']} helpful review', style: Theme.of(context).textTheme.caption),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Text(f.format(DateTime.parse(item['date']))),
                                  SizedBox(height: 4.0),
                                  Text(
                                    anime
                                        ? '${item['episodes_watched']} episodes seen'
                                        : '${item['chapters_read']} chapters read',
                                    style: Theme.of(context).textTheme.caption,
                                  ),
                                ],
                              ),
                              SizedBox(width: 8.0),
                              Ink.image(
                                image: NetworkImage(item['entry']['images']['jpg']['large_image_url']),
                                width: kImageWidthS,
                                height: kImageHeightS,
                                fit: BoxFit.cover,
                                child: InkWell(
                                  onTap: () {
                                    if (anime) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              AnimeScreen(item['entry']['mal_id'], item['entry']['title']),
                                          settings: RouteSettings(name: 'AnimeScreen'),
                                        ),
                                      );
                                    } else {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              MangaScreen(item['entry']['mal_id'], item['entry']['title']),
                                          settings: RouteSettings(name: 'MangaScreen'),
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      ExpandablePanel(
                        header: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          child: Text('Overall Rating: ${item['scores']['overall']}'),
                        ),
                        collapsed: Text(item['review'], softWrap: true, maxLines: 4, overflow: TextOverflow.ellipsis),
                        expanded: Text(item['review'].replaceAll('\\n', ''), softWrap: true),
                        theme: ExpandableThemeData(iconColor: Colors.grey, tapHeaderToExpand: true, hasIcon: true),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
