import 'package:flutter/material.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:built_collection/built_collection.dart' show BuiltList;
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:myanimelist/screens/anime_screen.dart';
import 'package:myanimelist/screens/manga_screen.dart';
import 'package:myanimelist/screens/settings_screen.dart';
import 'package:myanimelist/widgets/home/search_button.dart';
import 'package:myanimelist/widgets/home/season_horizontal.dart';
import 'package:myanimelist/widgets/home/top_horizontal.dart';
import 'package:myanimelist/screens/top_anime_screen.dart';
import 'package:myanimelist/screens/top_manga_screen.dart';
import 'package:myanimelist/screens/top_people_screen.dart';
import 'package:myanimelist/screens/top_characters_screen.dart';
import 'package:myanimelist/screens/seasonal_anime_screen.dart';
import 'package:myanimelist/screens/anime_list_screen.dart';
import 'package:myanimelist/screens/manga_list_screen.dart';
import 'package:myanimelist/screens/user_profile_screen.dart';
import 'package:myanimelist/widgets/profile/user_dialog.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen(this.profile, this.season, this.topAiring, this.topUpcoming);

  final UserProfile profile;
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
          SeasonHorizontal(season),
          TopHorizontal(topAiring, label: 'Airing'),
          TopHorizontal(topUpcoming, label: 'Upcoming'),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  UserAccountsDrawerHeader(
                    accountName: Text(profile == null ? '' : profile.username),
                    accountEmail: null,
                    currentAccountPicture:
                        profile == null ? Container() : CircleAvatar(backgroundImage: NetworkImage(profile.imageUrl)),
                  ),
                  profile == null
                      ? ListTile(
                          title: Text('Login'),
                          leading: Icon(FontAwesomeIcons.signInAlt, color: Theme.of(context).unselectedWidgetColor),
                          onTap: () {
                            showDialog<void>(
                              context: context,
                              builder: (context) => UserDialog(),
                            );
                          },
                        )
                      : ExpansionTile(
                          title: Text('User'),
                          leading: Icon(FontAwesomeIcons.userAlt),
                          children: <Widget>[
                            ListTile(
                              title: Text('Profile'),
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UserProfileScreen(profile.username),
                                    settings: RouteSettings(name: 'UserProfileScreen'),
                                  ),
                                );
                              },
                            ),
                            ListTile(
                              title: Text('Anime List'),
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AnimeListScreen(profile.username),
                                    settings: RouteSettings(name: 'AnimeListScreen'),
                                  ),
                                );
                              },
                            ),
                            ListTile(
                              title: Text('Manga List'),
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MangaListScreen(profile.username),
                                    settings: RouteSettings(name: 'MangaListScreen'),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                  ExpansionTile(
                    title: Text('Anime'),
                    leading: Icon(FontAwesomeIcons.tv),
                    children: <Widget>[
                      ListTile(
                        title: Text('Anime Search'),
                        onTap: () async {
                          Navigator.pop(context);
                          final Search selected = await showSearch<Search>(
                            context: context,
                            delegate: CustomSearchDelegate(type: SearchType.anime),
                          );
                          if (selected != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AnimeScreen(selected.malId, selected.title),
                                settings: RouteSettings(name: 'AnimeScreen'),
                              ),
                            );
                          }
                        },
                      ),
                      ListTile(
                        title: Text('Top Anime'),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TopAnimeScreen(),
                              settings: RouteSettings(name: 'TopAnimeScreen'),
                            ),
                          );
                        },
                      ),
                      ListTile(
                        title: Text('Seasonal Anime'),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  SeasonalAnimeScreen(year: season.seasonYear, type: season.seasonName),
                              settings: RouteSettings(name: 'SeasonalAnimeScreen'),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  ExpansionTile(
                    title: Text('Manga'),
                    leading: Icon(FontAwesomeIcons.book),
                    children: <Widget>[
                      ListTile(
                        title: Text('Manga Search'),
                        onTap: () async {
                          Navigator.pop(context);
                          final Search selected = await showSearch<Search>(
                            context: context,
                            delegate: CustomSearchDelegate(type: SearchType.manga),
                          );
                          if (selected != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MangaScreen(selected.malId, selected.title),
                                settings: RouteSettings(name: 'MangaScreen'),
                              ),
                            );
                          }
                        },
                      ),
                      ListTile(
                        title: Text('Top Manga'),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TopMangaScreen(),
                              settings: RouteSettings(name: 'TopMangaScreen'),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  ExpansionTile(
                    title: Text('Industry'),
                    leading: Icon(FontAwesomeIcons.briefcase),
                    children: <Widget>[
                      ListTile(
                        title: Text('People'),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TopPeopleScreen(),
                              settings: RouteSettings(name: 'TopPeopleScreen'),
                            ),
                          );
                        },
                      ),
                      ListTile(
                        title: Text('Characters'),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TopCharactersScreen(),
                              settings: RouteSettings(name: 'TopCharactersScreen'),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Divider(height: 0.0),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                    icon: Icon(FontAwesomeIcons.cog, color: Theme.of(context).unselectedWidgetColor),
                    tooltip: 'Settings',
                    onPressed: () async {
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      PackageInfo packageInfo = await PackageInfo.fromPlatform();
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SettingsScreen(prefs, packageInfo),
                          settings: RouteSettings(name: 'SettingsScreen'),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(FontAwesomeIcons.lightbulb, color: Theme.of(context).unselectedWidgetColor),
                    tooltip: 'Theme',
                    onPressed: () {
                      Navigator.pop(context);
                      DynamicTheme.of(context).setBrightness(
                          Theme.of(context).brightness == Brightness.dark ? Brightness.light : Brightness.dark);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
