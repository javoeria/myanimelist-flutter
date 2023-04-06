import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/material.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:myanimelist/constants.dart';
import 'package:myanimelist/screens/anime_list_screen.dart';
import 'package:myanimelist/screens/manga_list_screen.dart';
import 'package:myanimelist/widgets/profile/about_section.dart';
import 'package:myanimelist/widgets/profile/anime_stats_section.dart';
import 'package:myanimelist/widgets/profile/favorite_list.dart';
import 'package:myanimelist/widgets/profile/friend_list.dart';
import 'package:myanimelist/widgets/profile/manga_stats_section.dart';
import 'package:page_indicator/page_indicator.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen(this.username);

  final String username;

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  late ScrollController _scrollController;
  late UserProfile profile;
  late BuiltList<Friend> friends;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    load();
    _scrollController = ScrollController()..addListener(() => setState(() {}));
  }

  void load() async {
    final Trace userTrace = FirebasePerformance.instance.newTrace('user_trace');
    userTrace.start();
    profile = await jikan.getUserProfile(widget.username);
    friends = await jikan.getUserFriends(widget.username);
    userTrace.stop();
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
      body: CustomScrollView(
        controller: _scrollController,
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            expandedHeight: kExpandedHeight,
            title: _showTitle ? Text(profile.username) : null,
            flexibleSpace: FlexibleSpaceBar(
              background: Padding(
                padding: kSliverAppBarPadding,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Expanded(
                      child: profile.imageUrl != null
                          ? Image.network(
                              profile.imageUrl!,
                              width: kSliverAppBarWidth,
                              height: kSliverAppBarHeight,
                              fit: BoxFit.contain,
                              alignment: Alignment.centerRight,
                            )
                          : Align(
                              alignment: Alignment.bottomRight,
                              child: Container(
                                width: 200.0,
                                height: 200.0,
                                color: Colors.grey,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(Icons.camera_alt, size: 48.0, color: Colors.grey[700]),
                                    Text('No Picture', style: TextStyle(color: Colors.grey[700])),
                                  ],
                                ),
                              ),
                            ),
                    ),
                    SizedBox(width: 24.0),
                    Expanded(
                      child: SizedBox(
                        height: kSliverAppBarHeight,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            AutoSizeText(
                              profile.username,
                              style: Theme.of(context).textTheme.titleLarge,
                              maxLines: 2,
                            ),
                            SizedBox(height: 24.0),
                            Row(
                              children: <Widget>[
                                Icon(Icons.access_time, size: 20.0),
                                SizedBox(width: 4.0),
                                Text(
                                  profile.lastOnline!.formatDate(pattern: 'MMM d, yy'),
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                              ],
                            ),
                            profile.gender != null
                                ? Row(
                                    children: <Widget>[
                                      Icon(profile.gender! == 'Male' ? Icons.male : Icons.female, size: 20.0),
                                      SizedBox(width: 4.0),
                                      Text(
                                        profile.gender!,
                                        style: Theme.of(context).textTheme.bodyLarge,
                                      ),
                                    ],
                                  )
                                : Container(),
                            profile.birthday != null
                                ? Row(
                                    children: <Widget>[
                                      Icon(Icons.cake, size: 20.0),
                                      SizedBox(width: 4.0),
                                      Text(
                                        profile.birthday!.formatDate(pattern: 'MMM d, yy'),
                                        style: Theme.of(context).textTheme.bodyLarge,
                                      ),
                                    ],
                                  )
                                : Container(),
                            profile.location != null
                                ? Row(
                                    children: <Widget>[
                                      Icon(Icons.place, size: 20.0),
                                      SizedBox(width: 4.0),
                                      Expanded(
                                        child: Text(
                                          profile.location!,
                                          style: Theme.of(context).textTheme.bodyLarge,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              profile.about != null ? AboutSection(profile.about) : Container(),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
                        child: Text(
                          'Anime List',
                          style: Theme.of(context).textTheme.labelLarge!.copyWith(color: Colors.white),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AnimeListScreen(profile.username),
                              settings: const RouteSettings(name: 'AnimeListScreen'),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(width: 16.0),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
                        child: Text(
                          'Manga List',
                          style: Theme.of(context).textTheme.labelLarge!.copyWith(color: Colors.white),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MangaListScreen(profile.username),
                              settings: const RouteSettings(name: 'MangaListScreen'),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Divider(height: 0.0),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Statistics', style: Theme.of(context).textTheme.titleMedium),
              ),
              SizedBox(
                height: kExpandedHeight,
                child: PageIndicatorContainer(
                  length: 2,
                  indicatorColor: Colors.grey.shade300,
                  indicatorSelectorColor: Colors.indigo,
                  shape: IndicatorShape.circle(size: 6.0),
                  child: PageView(
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      AnimeStatsSection(profile.animeStats),
                      MangaStatsSection(profile.mangaStats),
                    ],
                  ),
                ),
              ),
              _favoriteCount > 0 ? FavoriteList(profile.favorites) : Container(),
              friends.isNotEmpty ? FriendList(friends) : Container(),
            ]),
          ),
        ],
      ),
    );
  }
}
