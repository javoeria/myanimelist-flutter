import 'package:flutter/material.dart';
import 'package:jikan_dart/jikan_dart.dart';
import 'package:built_collection/built_collection.dart' show BuiltList;
import 'package:intl/intl.dart' show DateFormat;
import 'package:url_launcher/url_launcher.dart';

class AnimeForum extends StatefulWidget {
  AnimeForum(this.id);

  final int id;

  @override
  _AnimeForumState createState() => _AnimeForumState();
}

class _AnimeForumState extends State<AnimeForum> with AutomaticKeepAliveClientMixin<AnimeForum> {
  final DateFormat f = DateFormat('MMM d, yyyy');
  Future<BuiltList<Forum>> _future;

  @override
  void initState() {
    super.initState();
    _future = JikanApi().getAnimeForum(widget.id);
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

        BuiltList<Forum> forumList = snapshot.data;
        return ListView.separated(
          separatorBuilder: (context, index) => Divider(height: 0.0),
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
                          Text(forum.title, style: Theme.of(context).textTheme.body2),
                          SizedBox(height: 4.0),
                          RichText(
                            text: TextSpan(
                              text: forum.authorName + ' - ',
                              style: DefaultTextStyle.of(context).style,
                              children: <TextSpan>[
                                TextSpan(
                                    text: f.format(DateTime.parse(forum.datePosted)),
                                    style: Theme.of(context).textTheme.caption),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Chip(label: Text(forum.replies.toString()), padding: EdgeInsets.zero),
                  ],
                ),
              ),
              onTap: () async {
                String url = forum.url;
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  throw 'Could not launch $url';
                }
              },
            );
          },
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
