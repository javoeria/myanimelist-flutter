import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:myanimelist/constants.dart';
import 'package:myanimelist/screens/anime_screen.dart';
import 'package:myanimelist/screens/manga_screen.dart';
import 'package:myanimelist/screens/user_profile_screen.dart';

class ReviewScreen extends StatelessWidget {
  const ReviewScreen({this.anime = true});

  final bool anime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(anime ? 'Anime Reviews' : 'Manga Reviews')),
      body: FutureBuilder(
        future: anime ? jikan.getRecentAnimeReviews() : jikan.getRecentMangaReviews(),
        builder: (context, AsyncSnapshot<BuiltList<UserReview>> snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Center(child: CircularProgressIndicator());
          }

          BuiltList<UserReview> reviewList = snapshot.data!;
          return Scrollbar(
            child: ListView.separated(
              separatorBuilder: (context, index) => const Divider(height: 0.0),
              itemCount: reviewList.length,
              itemBuilder: (context, index) {
                UserReview review = reviewList.elementAt(index);
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      InkWell(
                        child: Text(review.entry.title, style: Theme.of(context).textTheme.titleSmall),
                        onTap: () {
                          if (anime) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AnimeScreen(review.entry.malId, review.entry.title),
                                settings: const RouteSettings(name: 'AnimeScreen'),
                              ),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MangaScreen(review.entry.malId, review.entry.title),
                                settings: const RouteSettings(name: 'MangaScreen'),
                              ),
                            );
                          }
                        },
                      ),
                      SizedBox(height: 12.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Row>[
                          Row(
                            children: <Widget>[
                              Ink.image(
                                image: NetworkImage(review.user.imageUrl!),
                                width: kImageWidthS,
                                height: kImageHeightS,
                                fit: BoxFit.cover,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => UserProfileScreen(review.user.username),
                                        settings: const RouteSettings(name: 'UserProfileScreen'),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(width: 8.0),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(review.user.username),
                                  SizedBox(height: 4.0),
                                  Text(review.tags[0], style: Theme.of(context).textTheme.bodySmall),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Text(review.date.formatDate()),
                                  SizedBox(height: 4.0),
                                  Text(
                                    review.isSpoiler ? 'Spoiler' : '',
                                    style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.red),
                                  ),
                                ],
                              ),
                              SizedBox(width: 8.0),
                              Ink.image(
                                image: NetworkImage(review.entry.imageUrl),
                                width: kImageWidthS,
                                height: kImageHeightS,
                                fit: BoxFit.cover,
                                child: InkWell(
                                  onTap: () {
                                    if (anime) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => AnimeScreen(review.entry.malId, review.entry.title),
                                          settings: const RouteSettings(name: 'AnimeScreen'),
                                        ),
                                      );
                                    } else {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => MangaScreen(review.entry.malId, review.entry.title),
                                          settings: const RouteSettings(name: 'MangaScreen'),
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
                          child: Text("Reviewer's Rating: ${review.score}"),
                        ),
                        collapsed: Text(review.review, softWrap: true, maxLines: 4, overflow: TextOverflow.ellipsis),
                        expanded: Text(review.review.replaceAll('\\n', ''), softWrap: true),
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
