import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:myanimelist/constants.dart';
import 'package:myanimelist/screens/user_profile_screen.dart';

class AnimeReviews extends StatefulWidget {
  const AnimeReviews(this.id, {this.anime = true});

  final int id;
  final bool anime;

  @override
  State<AnimeReviews> createState() => _AnimeReviewsState();
}

class _AnimeReviewsState extends State<AnimeReviews> with AutomaticKeepAliveClientMixin<AnimeReviews> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scrollbar(
      child: PagewiseListView(
        pageSize: kReviewPageSize,
        itemBuilder: _itemBuilder,
        noItemsFoundBuilder: (context) => ListTile(title: Text('No items found.')),
        pageFuture: (pageIndex) => widget.anime
            ? jikan.getAnimeReviews(widget.id, page: pageIndex! + 1)
            : jikan.getMangaReviews(widget.id, page: pageIndex! + 1),
      ),
    );
  }

  Widget _itemBuilder(BuildContext context, Review review, int index) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
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
                          Row(
                            children: <Widget>[
                              reviewIcon(review.tags[0]),
                              Text(review.tags[0], style: Theme.of(context).textTheme.bodySmall),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Text>[
                      Text(review.date.formatDate()),
                      Text(
                        review.isSpoiler ? 'Spoiler' : '',
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.red),
                      ),
                    ],
                  ),
                ],
              ),
              ExpandablePanel(
                header: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text("Reviewer's Rating: ${review.score}"),
                ),
                collapsed: Text(review.review, softWrap: true, maxLines: 4, overflow: TextOverflow.ellipsis),
                expanded: Text(review.review.replaceAll('\\n', ''), softWrap: true),
                theme: ExpandableThemeData(iconColor: Colors.grey, tapHeaderToExpand: true, hasIcon: true),
              ),
            ],
          ),
        ),
        Divider(height: 0.0),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
