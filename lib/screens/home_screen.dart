import 'package:flutter/material.dart';
import 'package:jikan_dart/jikan_dart.dart';
import 'package:built_collection/built_collection.dart' show BuiltList;

import 'package:myanimelist/widgets/season_anime.dart';
import 'package:myanimelist/widgets/top_anime.dart';
import 'package:myanimelist/screens/top_anime_screen.dart';
import 'package:myanimelist/screens/top_manga_screen.dart';
import 'package:myanimelist/screens/schedule_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen(this.profile, this.season, this.topAiring, this.topUpcoming);

  final ProfileResult profile;
  final Season season;
  final BuiltList<Top> topAiring;
  final BuiltList<Top> topUpcoming;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MyAnimeList'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          )
        ],
      ),
      body: ListView(
        children: <Widget>[
          SeasonAnime(season),
          Divider(),
          TopAnime(topAiring, label: 'Airing'),
          Divider(),
          TopAnime(topUpcoming, label: 'Upcoming'),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(profile.username),
              accountEmail: Text(profile.username),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(profile.imageUrl),
              ),
            ),
            ListTile(
              title: Text('Top Anime'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => TopAnimeScreen()));
              },
            ),
            ListTile(
              title: Text('Top Manga'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => TopMangaScreen()));
              },
            ),
            ListTile(
              title: Text('Schedule'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => ScheduleScreen()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
