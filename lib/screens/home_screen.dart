import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:myanimelist/constants.dart';
import 'package:myanimelist/main.dart';
import 'package:myanimelist/models/user_data.dart';
import 'package:myanimelist/oauth.dart';
import 'package:myanimelist/screens/anime_list_screen.dart';
import 'package:myanimelist/screens/anime_screen.dart';
import 'package:myanimelist/screens/feed_screen.dart';
import 'package:myanimelist/screens/genre_anime_screen.dart';
import 'package:myanimelist/screens/genre_manga_screen.dart';
import 'package:myanimelist/screens/manga_list_screen.dart';
import 'package:myanimelist/screens/manga_screen.dart';
import 'package:myanimelist/screens/producer_screen.dart';
import 'package:myanimelist/screens/recommendation_screen.dart';
import 'package:myanimelist/screens/review_screen.dart';
import 'package:myanimelist/screens/seasonal_anime_screen.dart';
import 'package:myanimelist/screens/settings_screen.dart';
import 'package:myanimelist/screens/top_anime_screen.dart';
import 'package:myanimelist/screens/top_characters_screen.dart';
import 'package:myanimelist/screens/top_manga_screen.dart';
import 'package:myanimelist/screens/top_people_screen.dart';
import 'package:myanimelist/screens/user_profile_screen.dart';
import 'package:myanimelist/screens/watch_screen.dart';
import 'package:myanimelist/widgets/home/search_button.dart';
import 'package:myanimelist/widgets/home/season_horizontal.dart';
import 'package:myanimelist/widgets/home/suggestion_horizontal.dart';
import 'package:myanimelist/widgets/home/top_horizontal.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen(this.profile, this.season, this.topAiring, this.topUpcoming, this.suggestions);

  final UserProfile? profile;
  final BuiltList<Anime> season;
  final BuiltList<Anime> topAiring;
  final BuiltList<Anime> topUpcoming;
  final List<dynamic>? suggestions;

  @override
  Widget build(BuildContext context) {
    final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;
    return Scaffold(
      appBar: AppBar(
        title: Text('AnimeDB'),
        actions: [SearchButton()],
      ),
      body: ListView(
        children: <Widget>[
          SeasonHorizontal(season),
          TopHorizontal(topAiring, label: 'Airing'),
          TopHorizontal(topUpcoming, label: 'Upcoming'),
          if (suggestions != null && suggestions!.isNotEmpty) SuggestionHorizontal(suggestions!),
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
                    accountName: Text(profile == null ? '' : profile!.username),
                    accountEmail: null,
                    currentAccountPicture: profile == null
                        ? Container()
                        : CircleAvatar(foregroundImage: NetworkImage(profile!.imageUrl ?? kDefaultImage)),
                    decoration: BoxDecoration(color: Colors.indigo),
                  ),
                  profile == null
                      ? ListTile(
                          title: Text('Login'),
                          leading:
                              Icon(FontAwesomeIcons.rightToBracket, color: Theme.of(context).unselectedWidgetColor),
                          onTap: () async {
                            FirebaseAnalytics.instance.logLogin();
                            String? username = await MalClient().login();
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
                          leading: Icon(FontAwesomeIcons.userLarge),
                          children: <ListTile>[
                            ListTile(
                              title: Text('Profile'),
                              onTap: () {
                                FirebaseAnalytics.instance.logSelectContent(contentType: 'user', itemId: 'profile');
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UserProfileScreen(profile!.username),
                                    settings: const RouteSettings(name: 'UserProfileScreen'),
                                  ),
                                );
                              },
                            ),
                            ListTile(
                              title: Text('Anime List'),
                              onTap: () {
                                FirebaseAnalytics.instance.logSelectContent(contentType: 'user', itemId: 'anime_list');
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AnimeListScreen(profile!.username),
                                    settings: const RouteSettings(name: 'AnimeListScreen'),
                                  ),
                                );
                              },
                            ),
                            ListTile(
                              title: Text('Manga List'),
                              onTap: () {
                                FirebaseAnalytics.instance.logSelectContent(contentType: 'user', itemId: 'manga_list');
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MangaListScreen(profile!.username),
                                    settings: const RouteSettings(name: 'MangaListScreen'),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                  ExpansionTile(
                    title: Text('Anime'),
                    leading: Icon(FontAwesomeIcons.tv),
                    children: <ListTile>[
                      ListTile(
                        title: Text('Anime Search'),
                        onTap: () async {
                          FirebaseAnalytics.instance.logSelectContent(contentType: 'anime', itemId: 'search');
                          Navigator.pop(context);
                          final Anime? selected = await showSearch<dynamic>(
                            context: context,
                            delegate: CustomSearchDelegate(type: ItemType.anime),
                          );
                          if (selected != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    AnimeScreen(selected.malId, selected.title, episodes: selected.episodes),
                                settings: const RouteSettings(name: 'AnimeScreen'),
                              ),
                            );
                          }
                        },
                      ),
                      ListTile(
                        title: Text('Top Anime'),
                        onTap: () {
                          FirebaseAnalytics.instance.logSelectContent(contentType: 'anime', itemId: 'top');
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TopAnimeScreen(),
                              settings: const RouteSettings(name: 'TopAnimeScreen'),
                            ),
                          );
                        },
                      ),
                      ListTile(
                        title: Text('Seasonal Anime'),
                        onTap: () {
                          String seasonName = season.first.season!.toTitleCase();
                          FirebaseAnalytics.instance.logSelectContent(contentType: 'anime', itemId: 'seasonal');
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SeasonalAnimeScreen(year: season.first.year!, season: seasonName),
                              settings: const RouteSettings(name: 'SeasonalAnimeScreen'),
                            ),
                          );
                        },
                      ),
                      ListTile(
                        title: Text('Genres'),
                        onTap: () {
                          FirebaseAnalytics.instance.logSelectContent(contentType: 'anime', itemId: 'genres');
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GenreAnimeScreen(showCount: remoteConfig.getBool('v4_genres')),
                              settings: const RouteSettings(name: 'GenreAnimeScreen'),
                            ),
                          );
                        },
                      ),
                      if (remoteConfig.getBool('v4_producers'))
                        ListTile(
                          title: Text('Studios'),
                          onTap: () {
                            FirebaseAnalytics.instance.logSelectContent(contentType: 'anime', itemId: 'studios');
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProducerScreen(),
                                settings: const RouteSettings(name: 'StudioScreen'),
                              ),
                            );
                          },
                        ),
                      if (remoteConfig.getBool('v4_reviews'))
                        ListTile(
                          title: Text('Reviews'),
                          onTap: () {
                            FirebaseAnalytics.instance.logSelectContent(contentType: 'anime', itemId: 'reviews');
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ReviewScreen(),
                                settings: const RouteSettings(name: 'ReviewAnimeScreen'),
                              ),
                            );
                          },
                        ),
                      if (remoteConfig.getBool('v4_recommendations'))
                        ListTile(
                          title: Text('Recommendations'),
                          onTap: () {
                            FirebaseAnalytics.instance
                                .logSelectContent(contentType: 'anime', itemId: 'recommendations');
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RecommendationScreen(),
                                settings: const RouteSettings(name: 'RecommendationAnimeScreen'),
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                  ExpansionTile(
                    title: Text('Manga'),
                    leading: Icon(FontAwesomeIcons.book),
                    children: <ListTile>[
                      ListTile(
                        title: Text('Manga Search'),
                        onTap: () async {
                          FirebaseAnalytics.instance.logSelectContent(contentType: 'manga', itemId: 'search');
                          Navigator.pop(context);
                          final Manga? selected = await showSearch<dynamic>(
                            context: context,
                            delegate: CustomSearchDelegate(type: ItemType.manga),
                          );
                          if (selected != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MangaScreen(selected.malId, selected.title),
                                settings: const RouteSettings(name: 'MangaScreen'),
                              ),
                            );
                          }
                        },
                      ),
                      ListTile(
                        title: Text('Top Manga'),
                        onTap: () {
                          FirebaseAnalytics.instance.logSelectContent(contentType: 'manga', itemId: 'top');
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TopMangaScreen(),
                              settings: const RouteSettings(name: 'TopMangaScreen'),
                            ),
                          );
                        },
                      ),
                      ListTile(
                        title: Text('Genres'),
                        onTap: () {
                          FirebaseAnalytics.instance.logSelectContent(contentType: 'manga', itemId: 'genres');
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GenreMangaScreen(showCount: remoteConfig.getBool('v4_genres')),
                              settings: const RouteSettings(name: 'GenreMangaScreen'),
                            ),
                          );
                        },
                      ),
                      if (remoteConfig.getBool('v4_magazines'))
                        ListTile(
                          title: Text('Magazines'),
                          onTap: () {
                            FirebaseAnalytics.instance.logSelectContent(contentType: 'manga', itemId: 'magazines');
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProducerScreen(anime: false),
                                settings: const RouteSettings(name: 'MagazineScreen'),
                              ),
                            );
                          },
                        ),
                      if (remoteConfig.getBool('v4_reviews'))
                        ListTile(
                          title: Text('Reviews'),
                          onTap: () {
                            FirebaseAnalytics.instance.logSelectContent(contentType: 'manga', itemId: 'reviews');
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ReviewScreen(anime: false),
                                settings: const RouteSettings(name: 'ReviewMangaScreen'),
                              ),
                            );
                          },
                        ),
                      if (remoteConfig.getBool('v4_recommendations'))
                        ListTile(
                          title: Text('Recommendations'),
                          onTap: () {
                            FirebaseAnalytics.instance
                                .logSelectContent(contentType: 'manga', itemId: 'recommendations');
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RecommendationScreen(anime: false),
                                settings: const RouteSettings(name: 'RecommendationMangaScreen'),
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                  ExpansionTile(
                    title: Text('Industry'),
                    leading: Icon(FontAwesomeIcons.briefcase),
                    children: <ListTile>[
                      ListTile(
                        title: Text('News'),
                        onTap: () {
                          FirebaseAnalytics.instance.logSelectContent(contentType: 'industry', itemId: 'news');
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FeedScreen(),
                              settings: const RouteSettings(name: 'NewsScreen'),
                            ),
                          );
                        },
                      ),
                      ListTile(
                        title: Text('Featured Articles'),
                        onTap: () {
                          FirebaseAnalytics.instance.logSelectContent(contentType: 'industry', itemId: 'articles');
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FeedScreen(news: false),
                              settings: const RouteSettings(name: 'FeaturedArticlesScreen'),
                            ),
                          );
                        },
                      ),
                      ListTile(
                        title: Text('People'),
                        onTap: () {
                          FirebaseAnalytics.instance.logSelectContent(contentType: 'industry', itemId: 'people');
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TopPeopleScreen(),
                              settings: const RouteSettings(name: 'TopPeopleScreen'),
                            ),
                          );
                        },
                      ),
                      ListTile(
                        title: Text('Characters'),
                        onTap: () {
                          FirebaseAnalytics.instance.logSelectContent(contentType: 'industry', itemId: 'characters');
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TopCharactersScreen(),
                              settings: const RouteSettings(name: 'TopCharactersScreen'),
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
                      children: <ListTile>[
                        ListTile(
                          title: Text('Episode Videos'),
                          onTap: () {
                            FirebaseAnalytics.instance.logSelectContent(contentType: 'watch', itemId: 'episode');
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => WatchScreen(),
                                settings: const RouteSettings(name: 'EpisodeVideosScreen'),
                              ),
                            );
                          },
                        ),
                        ListTile(
                          title: Text('Anime Trailers'),
                          onTap: () {
                            FirebaseAnalytics.instance.logSelectContent(contentType: 'watch', itemId: 'promotional');
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => WatchScreen(episodes: false),
                                settings: const RouteSettings(name: 'PromotionalVideosScreen'),
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
                children: <IconButton>[
                  IconButton(
                    icon: Icon(FontAwesomeIcons.gear, color: Theme.of(context).unselectedWidgetColor),
                    tooltip: 'Settings',
                    onPressed: () async {
                      FirebaseAnalytics.instance.logEvent(name: 'settings');
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      PackageInfo packageInfo = await PackageInfo.fromPlatform();
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SettingsScreen(prefs, packageInfo),
                          settings: const RouteSettings(name: 'SettingsScreen'),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(FontAwesomeIcons.lightbulb, color: Theme.of(context).unselectedWidgetColor),
                    tooltip: 'Theme',
                    onPressed: () {
                      FirebaseAnalytics.instance.logEvent(name: 'theme');
                      Navigator.pop(context);
                      Provider.of<UserData>(context, listen: false).toggleBrightness();
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
