import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:jikan_dart/jikan_dart.dart';
import 'package:built_collection/built_collection.dart' show BuiltList;
import 'package:intl/intl.dart' show DateFormat;

class AnimeReviews extends StatefulWidget {
  AnimeReviews(this.id, {this.anime = true});

  final int id;
  final bool anime;

  @override
  _AnimeReviewsState createState() => _AnimeReviewsState();
}

class _AnimeReviewsState extends State<AnimeReviews> with AutomaticKeepAliveClientMixin<AnimeReviews> {
  final DateFormat f = DateFormat('MMM d, yyyy');
  Future<BuiltList<Review>> _future;

  @override
  void initState() {
    super.initState();
    _future = widget.anime ? JikanApi().getAnimeReviews(widget.id) : JikanApi().getMangaReviews(widget.id);
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

        BuiltList<Review> reviewList = snapshot.data;
        return ListView.separated(
          separatorBuilder: (context, index) => Divider(height: 0.0),
          itemCount: reviewList.length,
          itemBuilder: (context, index) {
            Review review = reviewList.elementAt(index);
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: <Widget>[
                          Image.network(review.reviewer.imageUrl, width: 50.0, height: 70.0, fit: BoxFit.cover),
                          SizedBox(width: 8.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(review.reviewer.username),
                              SizedBox(height: 4.0),
                              Text('${review.helpfulCount} helpful review', style: Theme.of(context).textTheme.caption),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text(f.format(DateTime.parse(review.date))),
                          SizedBox(height: 4.0),
                          Text(widget.anime ? '${review.reviewer.episodesSeen} episodes seen' : '${review.reviewer.chaptersRead} chapters read',
                              style: Theme.of(context).textTheme.caption),
                        ],
                      ),
                    ],
                  ),
                  ExpandablePanel(
                    header: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Text('Overall Rating: ' + review.reviewer.scores.overall.toString()),
                    ),
                    collapsed: Text(review.content, softWrap: true, maxLines: 4, overflow: TextOverflow.ellipsis),
                    expanded: Text(review.content, softWrap: true),
                    tapHeaderToExpand: true,
                    hasIcon: true,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
