import 'package:flutter/material.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:myanimelist/constants.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AnimeForum extends StatefulWidget {
  const AnimeForum(this.id, {this.anime = true});

  final int id;
  final bool anime;

  @override
  _AnimeForumState createState() => _AnimeForumState();
}

class _AnimeForumState extends State<AnimeForum> with AutomaticKeepAliveClientMixin<AnimeForum> {
  late Future<BuiltList<Forum>> _future;

  @override
  void initState() {
    super.initState();
    _future = widget.anime ? jikan.getAnimeForum(widget.id) : jikan.getMangaForum(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
      future: _future,
      builder: (context, AsyncSnapshot<BuiltList<Forum>> snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Center(child: CircularProgressIndicator());
        }

        BuiltList<Forum> forumList = snapshot.data!;
        if (forumList.isEmpty) {
          return ListTile(title: Text('No items found.'));
        }
        return Scrollbar(
          child: ListView.separated(
            separatorBuilder: (context, index) => const Divider(height: 0.0),
            itemCount: forumList.length,
            itemBuilder: (context, index) {
              Forum forum = forumList.elementAt(index);
              return InkWell(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(forum.title, style: Theme.of(context).textTheme.titleSmall),
                            SizedBox(height: 4.0),
                            RichText(
                              text: TextSpan(
                                text: '${forum.authorUsername} - ',
                                style: DefaultTextStyle.of(context).style,
                                children: <TextSpan>[
                                  TextSpan(text: forum.date.formatDate(), style: Theme.of(context).textTheme.bodySmall),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Chip(label: Text(forum.comments.toString()), padding: EdgeInsets.zero),
                    ],
                  ),
                ),
                onTap: () async {
                  String url = forum.url;
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
