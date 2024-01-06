import 'package:flutter/material.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:myanimelist/constants.dart';
import 'package:myanimelist/screens/anime_screen.dart';
import 'package:myanimelist/screens/recommendation_screen.dart';

class RecommendationList extends StatelessWidget {
  const RecommendationList(this.recommendations);

  final BuiltList<UserRecommendation> recommendations;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Divider(height: 0.0),
        Padding(
          padding: kHomePadding,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Latest Anime Recommendations', style: Theme.of(context).textTheme.titleMedium),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                key: const Key('recommendations_icon'),
                tooltip: 'View all',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RecommendationScreen(),
                      settings: const RouteSettings(name: 'RecommendationAnimeScreen'),
                    ),
                  );
                },
              )
            ],
          ),
        ),
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          shrinkWrap: true,
          itemCount: 5,
          itemBuilder: (context, index) {
            UserRecommendation rec = recommendations.elementAt(index);
            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Ink.image(
                        image: NetworkImage(rec.entry[0].imageUrl),
                        width: kImageWidthS,
                        height: kImageHeightS,
                        fit: BoxFit.cover,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AnimeScreen(rec.entry[0].malId, rec.entry[0].title),
                                settings: const RouteSettings(name: 'AnimeScreen'),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Text>[
                            Text('If you liked', style: Theme.of(context).textTheme.bodySmall),
                            Text(rec.entry[0].title, maxLines: 2),
                          ],
                        ),
                      ),
                      Ink.image(
                        image: NetworkImage(rec.entry[1].imageUrl),
                        width: kImageWidthS,
                        height: kImageHeightS,
                        fit: BoxFit.cover,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AnimeScreen(rec.entry[1].malId, rec.entry[1].title),
                                settings: const RouteSettings(name: 'AnimeScreen'),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Text>[
                            Text('...then you might like', style: Theme.of(context).textTheme.bodySmall),
                            Text(rec.entry[1].title, maxLines: 2),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    rec.content,
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 12.0),
      ],
    );
  }
}
