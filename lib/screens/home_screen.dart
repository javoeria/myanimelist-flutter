import 'package:flutter/material.dart';
import 'package:jikan_dart/jikan_dart.dart';
import 'package:built_collection/built_collection.dart' show BuiltList;
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:myanimelist/widgets/home/search_button.dart';
import 'package:myanimelist/widgets/home/season_horizontal.dart';
import 'package:myanimelist/widgets/home/top_horizontal.dart';
import 'package:myanimelist/screens/top_anime_screen.dart';
import 'package:myanimelist/screens/top_manga_screen.dart';
import 'package:myanimelist/screens/top_people_screen.dart';
import 'package:myanimelist/screens/top_characters_screen.dart';
import 'package:myanimelist/screens/later_screen.dart';
import 'package:myanimelist/screens/schedule_screen.dart';
import 'package:myanimelist/screens/seasonal_anime_screen.dart';
import 'package:myanimelist/screens/anime_list_screen.dart';
import 'package:myanimelist/screens/manga_list_screen.dart';
import 'package:myanimelist/screens/user_profile_screen.dart';

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
        actions: <Widget>[SearchButton()],
      ),
      body: ListView(
        children: <Widget>[
          SizedBox(height: 8.0),
          SeasonHorizontal(season),
          Divider(),
          TopHorizontal(topAiring, label: 'Airing'),
          Divider(),
          TopHorizontal(topUpcoming, label: 'Upcoming'),
          SizedBox(height: 8.0),
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
              title: Text('Top People'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => TopPeopleScreen()));
              },
            ),
            ListTile(
              title: Text('Top Characters'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => TopCharactersScreen()));
              },
            ),
            ListTile(
              title: Text('Seasonal Anime'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => SeasonalAnimeScreen(year: 2019, type: Fall())));
              },
            ),
            ListTile(
              title: Text('Schedule'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => ScheduleScreen()));
              },
            ),
            ListTile(
              title: Text('Later'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => LaterScreen()));
              },
            ),
            ListTile(
              title: Text('Anime List'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => AnimeListScreen(profile.username)));
              },
            ),
            ListTile(
              title: Text('Manga List'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => MangaListScreen(profile.username)));
              },
            ),
            ListTile(
              title: Text('My Profile'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => UserProfileScreen(profile.username)));
              },
            ),
            ListTile(
              title: Text('Brightness'),
              trailing: Switch(
                value: Theme.of(context).brightness == Brightness.dark,
                onChanged: (value) {
                  DynamicTheme.of(context).setBrightness(
                      Theme.of(context).brightness == Brightness.dark ? Brightness.light : Brightness.dark);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
