import 'package:flutter/material.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:myanimelist/constants.dart';
import 'package:myanimelist/screens/anime_screen.dart';
import 'package:myanimelist/screens/review_screen.dart';

class ReviewList extends StatelessWidget {
  const ReviewList(this.reviews);

  final BuiltList<UserReview> reviews;

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
              Text('Latest Anime Reviews', style: Theme.of(context).textTheme.titleMedium),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                key: const Key('reviews_icon'),
                tooltip: 'View all',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReviewScreen(),
                      settings: const RouteSettings(name: 'ReviewAnimeScreen'),
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
            UserReview review = reviews.elementAt(index);
            return InkWell(
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  children: <Widget>[
                    Image.network(review.entry.imageUrl, width: kImageWidthS, height: kImageHeightS, fit: BoxFit.cover),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Text>[
                          Text(review.entry.title),
                          Text(
                            review.review,
                            style: Theme.of(context).textTheme.bodySmall,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text('Overall Rating: ${review.score}', style: Theme.of(context).textTheme.bodySmall),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AnimeScreen(review.entry.malId, review.entry.title),
                    settings: const RouteSettings(name: 'AnimeScreen'),
                  ),
                );
              },
            );
          },
        ),
        const SizedBox(height: 12.0),
      ],
    );
  }
}
