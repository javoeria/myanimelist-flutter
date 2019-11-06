import 'package:flutter/material.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:built_collection/built_collection.dart' show BuiltList;
import 'package:intl/intl.dart' show DateFormat;
import 'package:url_launcher/url_launcher.dart';

class AnimeNews extends StatefulWidget {
  AnimeNews(this.id, {this.anime = true});

  final int id;
  final bool anime;

  @override
  _AnimeNewsState createState() => _AnimeNewsState();
}

class _AnimeNewsState extends State<AnimeNews> with AutomaticKeepAliveClientMixin<AnimeNews> {
  final DateFormat f = DateFormat('MMM d, yyyy h:mm a');
  Future<BuiltList<Article>> _future;

  @override
  void initState() {
    super.initState();
    _future = widget.anime ? Jikan().getAnimeNews(widget.id) : Jikan().getMangaNews(widget.id);
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

        BuiltList<Article> articleList = snapshot.data;
        if (articleList.length == 0) {
          return ListTile(title: Text('No items found.'));
        }
        return Scrollbar(
          child: ListView.separated(
            separatorBuilder: (context, index) => Divider(height: 0.0),
            itemCount: articleList.length,
            itemBuilder: (context, index) {
              Article article = articleList.elementAt(index);
              return InkWell(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: <Widget>[
                      article.imageUrl != null
                          ? Row(
                              children: <Widget>[
                                Image.network(article.imageUrl, width: 50.0, height: 70.0, fit: BoxFit.cover),
                                SizedBox(width: 8.0),
                              ],
                            )
                          : Container(),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(article.title, style: Theme.of(context).textTheme.body2),
                            SizedBox(height: 4.0),
                            Text(article.intro, maxLines: 2, overflow: TextOverflow.ellipsis),
                            SizedBox(height: 4.0),
                            Text(f.format(DateTime.parse(article.date)) + ' by ${article.authorName}',
                                style: Theme.of(context).textTheme.caption),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () async {
                  String url = article.url;
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
              );
            },
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
