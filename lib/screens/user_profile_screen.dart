import 'package:flutter/material.dart';
import 'package:jikan_dart/jikan_dart.dart';
import 'package:myanimelist/widgets/friend_list.dart';
import 'package:myanimelist/widgets/item_anime.dart';
import 'package:intl/intl.dart' show NumberFormat, DateFormat;

final NumberFormat f = NumberFormat.compact();
final DateFormat date1 = DateFormat('MMM d, yy');
const kExpandedHeight = 280.0;

class UserProfileScreen extends StatefulWidget {
  UserProfileScreen(this.username);

  final String username;

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  ScrollController _scrollController;
  ProfileResult profile;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    load();
    _scrollController = ScrollController()..addListener(() => setState(() {}));
  }

  void load() async {
    profile = await JikanApi().getUserProfile(widget.username);
    setState(() => loading = false);
  }

  bool get _showTitle {
    return _scrollController.hasClients && _scrollController.offset > kExpandedHeight - kToolbarHeight;
  }

  @override
  Widget build(BuildContext context) {
    if (loading) return Scaffold(body: Center(child: CircularProgressIndicator()));

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
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Image.network(profile.imageUrl, width: 135.0, height: 210.0, fit: BoxFit.cover),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(profile.username, style: Theme.of(context).textTheme.title.copyWith(color: Colors.white)),
                          SizedBox(height: 24.0),
                          Row(
                            children: <Widget>[
                              Icon(Icons.person, color: Colors.white),
                              Text(profile.gender, style: Theme.of(context).textTheme.subhead.copyWith(color: Colors.white)),
                            ],
                          ),
                          profile.location != null ? Row(
                            children: <Widget>[
                              Icon(Icons.place, color: Colors.white),
                              Text(profile.location, style: Theme.of(context).textTheme.subhead.copyWith(color: Colors.white)),
                            ],
                          ) : Container(),
                          profile.birthday!= null ? Row(
                            children: <Widget>[
                              Icon(Icons.cake, color: Colors.white),
                              Text(date1.format(DateTime.parse(profile.birthday)), style: Theme.of(context).textTheme.subhead.copyWith(color: Colors.white)),
                            ],
                          ) : Container(),
                          Row(
                            children: <Widget>[
                              Icon(Icons.access_time, color: Colors.white),
                              Text(date1.format(DateTime.parse(profile.lastOnline)), style: Theme.of(context).textTheme.subhead.copyWith(color: Colors.white)),
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
              child: Text('About', style: Theme.of(context).textTheme.title),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
              child: Text(profile.about.toString(), softWrap: true),
            ),
            Divider(),
            // TODO: Stats
            FavoritesList(profile.favorites),
            FriendList(profile.username),
          ]),
        ),
      ]),
    );
  }
}

class FavoritesList extends StatelessWidget {
  FavoritesList(this.favorites);

  final Favorites favorites;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text('Favorites', style: Theme.of(context).textTheme.title),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text('Anime', style: Theme.of(context).textTheme.subhead),
        ),
        Container(
          height: 163.0,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            itemCount: favorites.anime.length,
            itemBuilder: (context, index) {
              FavoriteItem fav = favorites.anime.elementAt(index);
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: ItemAnime(fav.malId, fav.name, fav.imageUrl, width: 108.0, height: 163.0, type: TopType.anime),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text('Manga', style: Theme.of(context).textTheme.subhead),
        ),
        Container(
          height: 163.0,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            itemCount: favorites.manga.length,
            itemBuilder: (context, index) {
              FavoriteItem fav = favorites.manga.elementAt(index);
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: ItemAnime(fav.malId, fav.name, fav.imageUrl, width: 108.0, height: 163.0, type: TopType.manga),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text('Characters', style: Theme.of(context).textTheme.subhead),
        ),
        Container(
          height: 163.0,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            itemCount: favorites.characters.length,
            itemBuilder: (context, index) {
              FavoriteItem fav = favorites.characters.elementAt(index);
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: ItemAnime(fav.malId, fav.name, fav.imageUrl, width: 108.0, height: 163.0, type: TopType.characters),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text('People', style: Theme.of(context).textTheme.subhead),
        ),
        Container(
          height: 163.0,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            itemCount: favorites.people.length,
            itemBuilder: (context, index) {
              FavoriteItem fav = favorites.people.elementAt(index);
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: ItemAnime(fav.malId, fav.name, fav.imageUrl, width: 108.0, height: 163.0, type: TopType.people),
              );
            },
          ),
        ),
        Divider(),
      ],
    );
  }
}
