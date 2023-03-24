import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:jikan_api/jikan_api.dart';
import 'package:myanimelist/constants.dart';
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
        future: anime ? Jikan().getRecentAnimeReviews() : Jikan().getRecentMangaReviews(),
        builder: (context, AsyncSnapshot<BuiltList<UserReview>> snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Center(child: CircularProgressIndicator());
          }

          BuiltList<UserReview> items = snapshot.data!;
          return Scrollbar(
            child: ListView.separated(
              separatorBuilder: (context, index) => Divider(height: 0.0),
              itemCount: items.length,
              itemBuilder: (context, index) {
                UserReview item = items.elementAt(index);
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      InkWell(
                        child: Text(item.entry.title, style: Theme.of(context).textTheme.titleSmall),
                        onTap: () {
                          if (anime) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AnimeScreen(item.entry.malId, item.entry.title),
                                settings: RouteSettings(name: 'AnimeScreen'),
                              ),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MangaScreen(item.entry.malId, item.entry.title),
                                settings: RouteSettings(name: 'MangaScreen'),
                              ),
                            );
                          }
                        },
                      ),
                      SizedBox(height: 12.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Ink.image(
                                image: NetworkImage(item.user.imageUrl!),
                                width: kImageWidthS,
                                height: kImageHeightS,
                                fit: BoxFit.cover,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => UserProfileScreen(item.user.username),
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
                                  Text(item.user.username),
                                  SizedBox(height: 4.0),
                                  Text(item.tags[0], style: Theme.of(context).textTheme.bodySmall),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Text(f.format(DateTime.parse(item.date))),
                                  SizedBox(height: 4.0),
                                  Text(
                                    item.isSpoiler ? 'Spoiler' : '',
                                    style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.red),
                                  ),
                                ],
                              ),
                              SizedBox(width: 8.0),
                              Ink.image(
                                image: NetworkImage(item.entry.imageUrl),
                                width: kImageWidthS,
                                height: kImageHeightS,
                                fit: BoxFit.cover,
                                child: InkWell(
                                  onTap: () {
                                    if (anime) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => AnimeScreen(item.entry.malId, item.entry.title),
                                          settings: RouteSettings(name: 'AnimeScreen'),
                                        ),
                                      );
                                    } else {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => MangaScreen(item.entry.malId, item.entry.title),
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
                          child: Text("Reviewer's Rating: ${item.score}"),
                        ),
                        collapsed: Text(item.review, softWrap: true, maxLines: 4, overflow: TextOverflow.ellipsis),
                        expanded: Text(item.review.replaceAll('\\n', ''), softWrap: true),
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
