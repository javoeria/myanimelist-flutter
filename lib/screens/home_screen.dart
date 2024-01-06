import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/foundation.dart' show kReleaseMode;
import 'package:flutter/material.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:myanimelist/constants.dart';
import 'package:myanimelist/oauth.dart';
import 'package:myanimelist/screens/anime_screen.dart';
import 'package:myanimelist/screens/feed_screen.dart';
import 'package:myanimelist/widgets/home/drawer_menu.dart';
import 'package:myanimelist/widgets/home/favorite_horizontal.dart';
import 'package:myanimelist/widgets/home/feed_list.dart';
import 'package:myanimelist/widgets/home/recommendation_list.dart';
import 'package:myanimelist/widgets/home/review_list.dart';
import 'package:myanimelist/widgets/home/search_button.dart';
import 'package:myanimelist/widgets/home/season_horizontal.dart';
import 'package:myanimelist/widgets/home/suggestion_horizontal.dart';
import 'package:myanimelist/widgets/home/top_horizontal.dart';
import 'package:myanimelist/widgets/home/user_update_list.dart';
import 'package:myanimelist/widgets/home/watch_horizontal.dart';
import 'package:slack_notifier/slack_notifier.dart';
import 'package:xml/xml.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen(this.username);

  final String? username;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool loading = true;
  int currentPageIndex = 0;

  // Home Page
  BuiltList<Anime>? season;
  BuiltList<WatchPromo>? trailers;
  List<XmlElement>? news;
  UserProfile? profile;
  List<dynamic>? suggestions;

  // Trending Page
  BuiltList<Anime>? topAiring;
  BuiltList<Anime>? topUpcoming;
  BuiltList<Anime>? mostPopular;

  // Feed Page
  List<XmlElement>? articles;
  BuiltList<UserReview>? reviews;
  BuiltList<UserRecommendation>? recommendations;

  @override
  void initState() {
    super.initState();
    load(0);
    FirebaseAnalytics.instance.logAppOpen();
    if (kReleaseMode && widget.username != null) {
      SlackNotifier(kSlackToken).send('Main https://myanimelist.net/profile/${widget.username}', channel: 'jikan');
    }
  }

  void load(int index) async {
    setState(() {
      currentPageIndex = index;
      loading = true;
    });

    final Trace mainTrace = FirebasePerformance.instance.newTrace('main_trace_$index');
    mainTrace.start();
    if (index == 0) {
      season ??= await jikan.getSeason();
      trailers ??= await jikan.getWatchPromos();
      news ??= await getXmlData('news');
      if (widget.username != null) {
        profile ??= await jikan.getUserProfile(widget.username!);
        suggestions ??= await MalClient().getSuggestions();
      }
    } else if (index == 1) {
      topAiring ??= await jikan.getTopAnime(filter: TopFilter.airing);
      topUpcoming ??= await jikan.getTopAnime(filter: TopFilter.upcoming);
      mostPopular ??= await jikan.getTopAnime(filter: TopFilter.bypopularity);
    } else {
      articles ??= await getXmlData('featured');
      reviews ??= await jikan.getRecentAnimeReviews();
      recommendations ??= await jikan.getRecentAnimeRecommendations();
    }
    mainTrace.stop();
    setState(() => loading = false);
  }

  BuiltList<Favorite> get _profileFavorites => profile!.favorites.anime + profile!.favorites.manga;
  BuiltList<EntryUpdate> get _profileUpdates => profile!.animeUpdates + profile!.mangaUpdates;
  Widget _buildBody() {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (currentPageIndex == 0) {
      return ListView(
        key: const Key('home_page'),
        children: <Widget>[
          SeasonHorizontal(season!),
          if (suggestions != null && suggestions!.isNotEmpty) SuggestionHorizontal(suggestions!),
          WatchHorizontal(trailers!),
          FeedList(news!),
        ],
      );
    } else if (currentPageIndex == 1) {
      return ListView(
        key: const Key('trending_page'),
        children: <Widget>[
          TopHorizontal(topAiring!, label: 'Top Airing'),
          TopHorizontal(topUpcoming!, label: 'Top Upcoming'),
          TopHorizontal(mostPopular!, label: 'Most Popular'),
          if (profile != null && _profileFavorites.isNotEmpty) FavoriteHorizontal(_profileFavorites),
        ],
      );
    } else if (currentPageIndex == 2) {
      return ListView(
        key: const Key('feed_page'),
        children: <Widget>[
          FeedList(articles!, news: false),
          ReviewList(reviews!),
          RecommendationList(recommendations!),
          if (profile != null && _profileUpdates.isNotEmpty) UserUpdateList(_profileUpdates),
        ],
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AnimeDB'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shuffle),
            tooltip: 'Random anime',
            onPressed: () async {
              FirebaseAnalytics.instance.logEvent(name: 'random');
              final Anime random = await jikan.getAnime(0);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AnimeScreen(random.malId, random.title, episodes: random.episodes),
                  settings: const RouteSettings(name: 'AnimeScreen'),
                ),
              );
            },
          ),
          SearchButton(),
        ],
      ),
      body: _buildBody(),
      drawer: DrawerMenu(profile),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: load,
        selectedIndex: currentPageIndex,
        height: kImageHeightS,
        destinations: const <NavigationDestination>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.local_fire_department),
            icon: Icon(Icons.local_fire_department_outlined),
            label: 'Trending',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.feed),
            icon: Icon(Icons.feed_outlined),
            label: 'Feed',
          ),
        ],
      ),
    );
  }
}
