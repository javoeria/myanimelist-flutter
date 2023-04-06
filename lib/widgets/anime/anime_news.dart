import 'package:flutter/material.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:myanimelist/constants.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AnimeNews extends StatefulWidget {
  const AnimeNews(this.id, {this.anime = true});

  final int id;
  final bool anime;

  @override
  _AnimeNewsState createState() => _AnimeNewsState();
}

class _AnimeNewsState extends State<AnimeNews> with AutomaticKeepAliveClientMixin<AnimeNews> {
  late Future<BuiltList<Article>> _future;

  @override
  void initState() {
    super.initState();
    _future = widget.anime ? jikan.getAnimeNews(widget.id) : jikan.getMangaNews(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
      future: _future,
      builder: (context, AsyncSnapshot<BuiltList<Article>> snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Center(child: CircularProgressIndicator());
        }

        BuiltList<Article> articleList = snapshot.data!;
        if (articleList.isEmpty) {
          return ListTile(title: Text('No items found.'));
        }
        return Scrollbar(
          child: ListView.separated(
            separatorBuilder: (context, index) => const Divider(height: 0.0),
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
                                Image.network(
                                  article.imageUrl!,
                                  width: kImageWidthS,
                                  height: kImageHeightS,
                                  fit: BoxFit.cover,
                                ),
                                SizedBox(width: 8.0),
                              ],
                            )
                          : Container(),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(article.title, style: Theme.of(context).textTheme.titleSmall),
                            SizedBox(height: 4.0),
                            Text(article.excerpt, maxLines: 2, overflow: TextOverflow.ellipsis),
                            SizedBox(height: 4.0),
                            Text(
                              '${article.date.formatDate(pattern: 'MMM d, yyyy h:mm a')} by ${article.authorUsername}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () async {
                  String url = article.url;
                  if (await canLaunchUrlString(url)) {
                    await launchUrlString(url);
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
