import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:myanimelist/constants.dart';
import 'package:myanimelist/models/user_data.dart';
import 'package:myanimelist/oauth.dart';
import 'package:myanimelist/screens/anime_list_screen.dart';
import 'package:myanimelist/screens/anime_screen.dart';
import 'package:myanimelist/screens/feed_screen.dart';
import 'package:myanimelist/screens/genre_anime_screen.dart';
import 'package:myanimelist/screens/genre_manga_screen.dart';
import 'package:myanimelist/screens/home_screen.dart';
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
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerMenu extends StatelessWidget {
  const DrawerMenu(this.profile);

  final UserProfile? profile;

  String get _seasonName {
    int month = DateTime.now().month;
    if (month < 4) {
      return 'Winter';
    } else if (month >= 4 && month < 7) {
      return 'Spring';
    } else if (month >= 7 && month < 10) {
      return 'Summer';
    } else {
      return 'Fall';
    }
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;
    return Drawer(
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
                  decoration: const BoxDecoration(color: kMyAnimeListColor),
                ),
                profile == null
                    ? ListTile(
                        title: const Text('Login'),
                        leading: const Icon(FontAwesomeIcons.rightToBracket),
                        onTap: () async {
                          FirebaseAnalytics.instance.logLogin();
                          String? username = await MalClient().login();
                          if (username != null) {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => HomeScreen(username)),
                              (Route<dynamic> route) => false,
                            );
                          }
                        },
                      )
                    : ExpansionTile(
                        title: const Text('User'),
                        leading: const Icon(FontAwesomeIcons.userLarge),
                        children: <ListTile>[
                          ListTile(
                            title: const Text('Profile'),
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
                            title: const Text('Anime List'),
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
                            title: const Text('Manga List'),
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
                  title: const Text('Anime'),
                  leading: const Icon(FontAwesomeIcons.tv),
                  children: <ListTile>[
                    ListTile(
                      title: const Text('Anime Search'),
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
                      title: const Text('Top Anime'),
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
                      title: const Text('Seasonal Anime'),
                      onTap: () {
                        FirebaseAnalytics.instance.logSelectContent(contentType: 'anime', itemId: 'seasonal');
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SeasonalAnimeScreen(year: DateTime.now().year, season: _seasonName),
                            settings: const RouteSettings(name: 'SeasonalAnimeScreen'),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      title: const Text('Genres'),
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
                        title: const Text('Studios'),
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
                        title: const Text('Reviews'),
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
                        title: const Text('Recommendations'),
                        onTap: () {
                          FirebaseAnalytics.instance.logSelectContent(contentType: 'anime', itemId: 'recommendations');
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
                  title: const Text('Manga'),
                  leading: const Icon(FontAwesomeIcons.book),
                  children: <ListTile>[
                    ListTile(
                      title: const Text('Manga Search'),
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
                      title: const Text('Top Manga'),
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
                      title: const Text('Genres'),
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
                        title: const Text('Magazines'),
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
                        title: const Text('Reviews'),
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
                        title: const Text('Recommendations'),
                        onTap: () {
                          FirebaseAnalytics.instance.logSelectContent(contentType: 'manga', itemId: 'recommendations');
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
                  title: const Text('Industry'),
                  leading: const Icon(FontAwesomeIcons.briefcase),
                  children: <ListTile>[
                    ListTile(
                      title: const Text('News'),
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
                      title: const Text('Featured Articles'),
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
                      title: const Text('People'),
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
                      title: const Text('Characters'),
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
                    title: const Text('Watch'),
                    leading: const Icon(FontAwesomeIcons.youtube),
                    children: <ListTile>[
                      ListTile(
                        title: const Text('Episode Videos'),
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
                        title: const Text('Anime Trailers'),
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
          const Divider(height: 0.0),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <IconButton>[
                IconButton(
                  icon: const Icon(FontAwesomeIcons.gear),
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
                  icon: const Icon(FontAwesomeIcons.lightbulb),
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
    );
  }
}
