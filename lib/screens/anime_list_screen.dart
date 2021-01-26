import 'package:flutter/material.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:myanimelist/constants.dart';
import 'package:myanimelist/models/user_list.dart';
import 'package:myanimelist/screens/anime_screen.dart';
import 'package:myanimelist/widgets/profile/custom_filter.dart';
import 'package:provider/provider.dart';

class AnimeListScreen extends StatelessWidget {
  AnimeListScreen(this.username, {this.title, this.order, this.sort});

  final String username;
  final String title;
  final String order;
  final String sort;

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => UserList(username, title, order, sort, 'anime'),
      // dispose: (context, value) => value.dispose(),
      child: DefaultTabController(
        length: 6,
        initialIndex: 0,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Anime List'),
            bottom: TabBar(
              isScrollable: true,
              tabs: [
                Tab(text: 'All Anime'),
                Tab(text: 'Currently Watching'),
                Tab(text: 'Completed'),
                Tab(text: 'On Hold'),
                Tab(text: 'Dropped'),
                Tab(text: 'Plan to Watch'),
              ],
            ),
            actions: <Widget>[CustomFilter()],
          ),
          body: TabBarView(
            children: [
              UserAnimeList(type: ListType.all),
              UserAnimeList(type: ListType.watching),
              UserAnimeList(type: ListType.completed),
              UserAnimeList(type: ListType.onhold),
              UserAnimeList(type: ListType.dropped),
              UserAnimeList(type: ListType.plantowatch),
            ],
          ),
        ),
      ),
    );
  }
}

class UserAnimeList extends StatefulWidget {
  UserAnimeList({this.type});

  final ListType type;

  @override
  _UserAnimeListState createState() => _UserAnimeListState();
}

class _UserAnimeListState extends State<UserAnimeList> with AutomaticKeepAliveClientMixin<UserAnimeList> {
  Color statusColor(int status) {
    switch (status) {
      case 1:
        return kWatchingColor;
        break;
      case 2:
        return kCompletedColor;
        break;
      case 3:
        return kOnHoldColor;
        break;
      case 4:
        return kDroppedColor;
        break;
      case 6:
        return kPlantoWatchColor;
        break;
      default:
        throw 'AnimeStatus Error';
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final provider = Provider.of<UserList>(context);
    return Scrollbar(
      child: PagewiseListView(
        pageSize: kAnimePageSize,
        itemBuilder: _itemBuilder,
        padding: const EdgeInsets.all(12.0),
        noItemsFoundBuilder: (context) {
          return ListTile(title: Text('No items found.'));
        },
        pageFuture: (pageIndex) => Jikan().getUserAnimeList(
          provider.username,
          type: widget.type,
          query: provider.title,
          order: provider.order,
          sort: provider.sort,
          page: pageIndex + 1,
        ),
      ),
    );
  }

  Widget _itemBuilder(BuildContext context, UserItem item, int index) {
    String score = item.score == 0 ? '-' : item.score.toString();
    String watched = item.watchedEpisodes == 0 ? '-' : item.watchedEpisodes.toString();
    String total = item.totalEpisodes == 0 ? '-' : item.totalEpisodes.toString();
    String progress = watched == total ? total : '$watched / $total';
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  Container(color: statusColor(item.watchingStatus), width: 5.0, height: kImageHeightS),
                  Image.network(
                    item.imageUrl,
                    width: kImageWidthS,
                    height: kImageHeightS,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(width: 8.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(item.title, style: Theme.of(context).textTheme.subtitle2),
                        Text(
                          '${item.type} ($progress eps)',
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ],
                    ),
                  ),
                  Text(score, style: Theme.of(context).textTheme.subtitle1),
                ],
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AnimeScreen(item.malId, item.title),
            settings: RouteSettings(name: 'AnimeScreen'),
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
