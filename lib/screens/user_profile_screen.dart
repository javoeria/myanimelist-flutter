import 'package:flutter/material.dart';
import 'package:jikan_dart/jikan_dart.dart';
import 'package:intl/intl.dart' show NumberFormat, DateFormat;
import 'package:built_collection/built_collection.dart' show BuiltList;
import 'package:myanimelist/screens/anime_list_screen.dart';
import 'package:myanimelist/screens/manga_list_screen.dart';
import 'package:myanimelist/widgets/profile/about_section.dart';
import 'package:myanimelist/widgets/profile/favorite_list.dart';
import 'package:myanimelist/widgets/profile/friend_list.dart';

const kExpandedHeight = 280.0;

class UserProfileScreen extends StatefulWidget {
  UserProfileScreen(this.username);

  final String username;

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final JikanApi jikanApi = JikanApi();
  final NumberFormat f = NumberFormat.compact();
  final DateFormat dateFormat = DateFormat('MMM d, yy');

  ScrollController _scrollController;
  ProfileResult profile;
  BuiltList<FriendResult> friends;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    load();
    _scrollController = ScrollController()..addListener(() => setState(() {}));
  }

  void load() async {
    profile = await jikanApi.getUserProfile(widget.username);
    try {
      friends = await jikanApi.getUserFriends(widget.username);
    } catch (e) {
      print(e);
      friends = BuiltList<FriendResult>([]);
    }
    setState(() => loading = false);
  }

  bool get _showTitle {
    return _scrollController.hasClients && _scrollController.offset > kExpandedHeight - kToolbarHeight;
  }

  int get _favoriteCount {
    return profile.favorites.anime.length +
        profile.favorites.manga.length +
        profile.favorites.characters.length +
        profile.favorites.people.length;
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Scaffold(appBar: AppBar(), body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: CustomScrollView(controller: _scrollController, slivers: <Widget>[
        SliverAppBar(
          pinned: true,
          expandedHeight: kExpandedHeight,
          title: _showTitle ? Text(profile.username) : null,
          flexibleSpace: FlexibleSpaceBar(
            background: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      profile.imageUrl != null
                          ? Image.network(profile.imageUrl, width: 135.0, height: 210.0, fit: BoxFit.cover)
                          : Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(Icons.camera_alt),
                                  Text('No Picture'),
                                ],
                              ),
                              width: 135.0,
                              height: 210.0,
                              color: Colors.grey),
                      SizedBox(width: 24.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(profile.username,
                              style: Theme.of(context).textTheme.title.copyWith(color: Colors.white)),
                          SizedBox(height: 24.0),
                          profile.gender != null
                              ? Row(
                                  children: <Widget>[
                                    Icon(Icons.person, color: Colors.white, size: 20.0),
                                    SizedBox(width: 4.0),
                                    Text(profile.gender,
                                        style: Theme.of(context).textTheme.subhead.copyWith(color: Colors.white)),
                                  ],
                                )
                              : Container(),
                          profile.location != null
                              ? Row(
                                  children: <Widget>[
                                    Icon(Icons.place, color: Colors.white, size: 20.0),
                                    SizedBox(width: 4.0),
                                    Text(profile.location,
                                        style: Theme.of(context).textTheme.subhead.copyWith(color: Colors.white)),
                                  ],
                                )
                              : Container(),
                          profile.birthday != null
                              ? Row(
                                  children: <Widget>[
                                    Icon(Icons.cake, color: Colors.white, size: 20.0),
                                    SizedBox(width: 4.0),
                                    Text(dateFormat.format(DateTime.parse(profile.birthday)),
                                        style: Theme.of(context).textTheme.subhead.copyWith(color: Colors.white)),
                                  ],
                                )
                              : Container(),
                          Row(
                            children: <Widget>[
                              Icon(Icons.access_time, color: Colors.white, size: 20.0),
                              SizedBox(width: 4.0),
                              Text(dateFormat.format(DateTime.parse(profile.lastOnline)),
                                  style: Theme.of(context).textTheme.subhead.copyWith(color: Colors.white)),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate(<Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: RaisedButton(
                      color: Colors.indigo[600],
                      child:
                          Text('Anime List', style: Theme.of(context).textTheme.button.copyWith(color: Colors.white)),
                      onPressed: () {
                        Navigator.push(
                            context, MaterialPageRoute(builder: (context) => AnimeListScreen(profile.username)));
                      },
                    ),
                  ),
                  SizedBox(width: 16.0),
                  Expanded(
                    child: RaisedButton(
                      color: Colors.indigo[600],
                      child:
                          Text('Manga List', style: Theme.of(context).textTheme.button.copyWith(color: Colors.white)),
                      onPressed: () {
                        Navigator.push(
                            context, MaterialPageRoute(builder: (context) => MangaListScreen(profile.username)));
                      },
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: 0.0),
            AboutSection(profile.about),
            // TODO: Stats
            _favoriteCount > 0 ? FavoriteList(profile.favorites) : Container(),
            friends.length > 0 ? FriendList(friends) : Container(),
          ]),
        ),
      ]),
    );
  }
}
