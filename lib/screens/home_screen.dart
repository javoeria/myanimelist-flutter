import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:built_collection/built_collection.dart' show BuiltList;
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:myanimelist/constants.dart';
import 'package:myanimelist/main.dart';
import 'package:myanimelist/oauth.dart';
import 'package:myanimelist/screens/anime_screen.dart';
import 'package:myanimelist/screens/genre_anime_screen.dart';
import 'package:myanimelist/screens/genre_manga_screen.dart';
import 'package:myanimelist/screens/manga_screen.dart';
import 'package:myanimelist/screens/producer_screen.dart';
import 'package:myanimelist/screens/recommendation_screen.dart';
import 'package:myanimelist/screens/review_screen.dart';
import 'package:myanimelist/screens/settings_screen.dart';
import 'package:myanimelist/screens/watch_screen.dart';
import 'package:myanimelist/widgets/home/search_button.dart';
import 'package:myanimelist/widgets/home/season_horizontal.dart';
import 'package:myanimelist/widgets/home/suggestion_horizontal.dart';
import 'package:myanimelist/widgets/home/top_horizontal.dart';
import 'package:myanimelist/screens/top_anime_screen.dart';
import 'package:myanimelist/screens/top_manga_screen.dart';
import 'package:myanimelist/screens/top_people_screen.dart';
import 'package:myanimelist/screens/top_characters_screen.dart';
import 'package:myanimelist/screens/seasonal_anime_screen.dart';
import 'package:myanimelist/screens/anime_list_screen.dart';
import 'package:myanimelist/screens/manga_list_screen.dart';
import 'package:myanimelist/screens/user_profile_screen.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen(this.profile, this.season, this.topAiring, this.topUpcoming, this.suggestions, this.remoteConfig);

  final UserProfile profile;
  final Season season;
  final BuiltList<Top> topAiring;
  final BuiltList<Top> topUpcoming;
  final List<dynamic> suggestions;
  final RemoteConfig remoteConfig;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AnimeDB'),
        actions: <Widget>[SearchButton()],
      ),
      body: ListView(
        children: <Widget>[
          SeasonHorizontal(season),
          TopHorizontal(topAiring, label: 'Airing'),
          TopHorizontal(topUpcoming, label: 'Upcoming'),
          if (suggestions != null && suggestions.isNotEmpty) SuggestionHorizontal(suggestions),
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
                    currentAccountPicture: profile == null
                        ? Container()
                        : CircleAvatar(backgroundImage: NetworkImage(profile.imageUrl ?? kDefaultImage)),
                  ),
                  profile == null
                      ? ListTile(
                          title: Text('Login'),
                          leading: Icon(FontAwesomeIcons.signInAlt, color: Theme.of(context).unselectedWidgetColor),
                          onTap: () async {
                            FirebaseAnalytics().logLogin();
                            String username = await MalClient().login();
                            if (username != null) {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (context) => LoadingScreen()),
                                (Route<dynamic> route) => false,
                              );
                            }
                          },
                        )
                      : ExpansionTile(
                          title: Text('User'),
                          leading: Icon(FontAwesomeIcons.userAlt),
                          children: <Widget>[
                            ListTile(
                              title: Text('Profile'),
                              onTap: () {
                                FirebaseAnalytics().logSelectContent(contentType: 'user', itemId: 'profile');
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
                                FirebaseAnalytics().logSelectContent(contentType: 'user', itemId: 'anime_list');
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
                                FirebaseAnalytics().logSelectContent(contentType: 'user', itemId: 'manga_list');
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
                          FirebaseAnalytics().logSelectContent(contentType: 'anime', itemId: 'search');
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
                          FirebaseAnalytics().logSelectContent(contentType: 'anime', itemId: 'top');
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
                          FirebaseAnalytics().logSelectContent(contentType: 'anime', itemId: 'seasonal');
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
                      ListTile(
                        title: Text('Genres'),
                        onTap: () {
                          FirebaseAnalytics().logSelectContent(contentType: 'anime', itemId: 'genres');
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GenreAnimeScreen(showCount: remoteConfig.getBool('v4_genres')),
                              settings: RouteSettings(name: 'GenreAnimeScreen'),
                            ),
                          );
                        },
                      ),
                      if (remoteConfig.getBool('v4_producers'))
                        ListTile(
                          title: Text('Studios'),
                          onTap: () {
                            FirebaseAnalytics().logSelectContent(contentType: 'anime', itemId: 'studios');
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProducerScreen(),
                                settings: RouteSettings(name: 'StudioScreen'),
                              ),
                            );
                          },
                        ),
                      if (remoteConfig.getBool('v4_reviews'))
                        ListTile(
                          title: Text('Reviews'),
                          onTap: () {
                            FirebaseAnalytics().logSelectContent(contentType: 'anime', itemId: 'reviews');
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ReviewScreen(),
                                settings: RouteSettings(name: 'ReviewAnimeScreen'),
                              ),
                            );
                          },
                        ),
                      if (remoteConfig.getBool('v4_recommendations'))
                        ListTile(
                          title: Text('Recommendations'),
                          onTap: () {
                            FirebaseAnalytics().logSelectContent(contentType: 'anime', itemId: 'recommendations');
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RecommendationScreen(),
                                settings: RouteSettings(name: 'RecommendationAnimeScreen'),
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
                          FirebaseAnalytics().logSelectContent(contentType: 'manga', itemId: 'search');
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
                          FirebaseAnalytics().logSelectContent(contentType: 'manga', itemId: 'top');
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
                      ListTile(
                        title: Text('Genres'),
                        onTap: () {
                          FirebaseAnalytics().logSelectContent(contentType: 'manga', itemId: 'genres');
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GenreMangaScreen(showCount: remoteConfig.getBool('v4_genres')),
                              settings: RouteSettings(name: 'GenreMangaScreen'),
                            ),
                          );
                        },
                      ),
                      if (remoteConfig.getBool('v4_magazines'))
                        ListTile(
                          title: Text('Magazines'),
                          onTap: () {
                            FirebaseAnalytics().logSelectContent(contentType: 'manga', itemId: 'magazines');
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProducerScreen(anime: false),
                                settings: RouteSettings(name: 'MagazineScreen'),
                              ),
                            );
                          },
                        ),
                      if (remoteConfig.getBool('v4_reviews'))
                        ListTile(
                          title: Text('Reviews'),
                          onTap: () {
                            FirebaseAnalytics().logSelectContent(contentType: 'manga', itemId: 'reviews');
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ReviewScreen(anime: false),
                                settings: RouteSettings(name: 'ReviewMangaScreen'),
                              ),
                            );
                          },
                        ),
                      if (remoteConfig.getBool('v4_recommendations'))
                        ListTile(
                          title: Text('Recommendations'),
                          onTap: () {
                            FirebaseAnalytics().logSelectContent(contentType: 'manga', itemId: 'recommendations');
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RecommendationScreen(anime: false),
                                settings: RouteSettings(name: 'RecommendationMangaScreen'),
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
                          FirebaseAnalytics().logSelectContent(contentType: 'industry', itemId: 'people');
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
                          FirebaseAnalytics().logSelectContent(contentType: 'industry', itemId: 'characters');
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
                  if (remoteConfig.getBool('v4_watch'))
                    ExpansionTile(
                      title: Text('Watch'),
                      leading: Icon(FontAwesomeIcons.youtube),
                      children: <Widget>[
                        ListTile(
                          title: Text('Episode Videos'),
                          onTap: () {
                            FirebaseAnalytics().logSelectContent(contentType: 'watch', itemId: 'episode');
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => WatchScreen(),
                                settings: RouteSettings(name: 'EpisodeVideosScreen'),
                              ),
                            );
                          },
                        ),
                        ListTile(
                          title: Text('Promotional Videos'),
                          onTap: () {
                            FirebaseAnalytics().logSelectContent(contentType: 'watch', itemId: 'promotional');
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => WatchScreen(episodes: false),
                                settings: RouteSettings(name: 'PromotionalVideosScreen'),
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
                      FirebaseAnalytics().logEvent(name: 'settings');
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
                      FirebaseAnalytics().logEvent(name: 'theme');
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
