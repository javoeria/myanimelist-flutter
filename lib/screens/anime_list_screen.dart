import 'package:flutter/material.dart';
import 'package:jikan_dart/jikan_dart.dart';
import 'package:built_collection/built_collection.dart' show BuiltList;
import 'package:myanimelist/widgets/custom_filter.dart';

class AnimeListScreen extends StatelessWidget {
  AnimeListScreen({this.order});

  final String order;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
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
          actions: <Widget>[
            CustomFilter('anime'),
          ],
        ),
        body: TabBarView(
          children: [
            UserList(type: AllAnimeListType(), order: order),
            UserList(type: WatchingAnimeListType(), order: order),
            UserList(type: CompletedAnimeListType(), order: order),
            UserList(type: OnHoldAnimeListType(), order: order),
            UserList(type: DroppedAnimeListType(), order: order),
            UserList(type: PlanToWatchAnimeListType(), order: order),
          ],
        ),
      ),
    );
  }
}

class UserList extends StatefulWidget {
  UserList({this.type, this.order});

  final MangaAnimeListType type;
  final String order;

  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> with AutomaticKeepAliveClientMixin<UserList> {
  Color statusColor(int status) {
    switch (status) {
      case 1:
        return Colors.green[600];
        break;
      case 2:
        return Colors.blue[900];
        break;
      case 3:
        return Colors.yellow[700];
        break;
      case 4:
        return Colors.red[900];
        break;
      case 6:
        return Colors.grey[400];
        break;
      default:
        throw 'Status Error';
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
      future: JikanApi().getUserAnimeList('javoeria', widget.type, order: widget.order),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Center(child: CircularProgressIndicator());
        }

        BuiltList<AnimeItem> animeList = snapshot.data;
        return ListView.builder(
          padding: const EdgeInsets.all(12.0),
          itemCount: animeList.length,
          itemBuilder: (context, index) {
            AnimeItem item = animeList.elementAt(index);
            String score = item.score == 0 ? '-' : item.score.toString();
            String watched = item.watchedEpisodes == 0 ? '-' : item.watchedEpisodes.toString();
            String total = item.totalEpisodes == 0 ? '-' : item.totalEpisodes.toString();
            String progress = watched == total ? total : '$watched / $total';
            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        Container(color: statusColor(item.watchingStatus), width: 5.0, height: 70.0),
                        Image.network(item.imageUrl, width: 50.0, height: 70.0, fit: BoxFit.cover),
                        SizedBox(width: 8.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(item.title, style: Theme.of(context).textTheme.subtitle),
                              Text(item.type + ' ($progress eps)', style: Theme.of(context).textTheme.caption),
                            ],
                          ),
                        ),
                        Text(score, style: Theme.of(context).textTheme.subhead),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
