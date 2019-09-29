import 'package:flutter/material.dart';
import 'package:jikan_dart/jikan_dart.dart';
import 'package:built_collection/built_collection.dart' show BuiltList;
import 'package:myanimelist/widgets/custom_filter.dart';

class MangaListScreen extends StatelessWidget {
  MangaListScreen({this.order});

  final String order;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Manga List'),
          bottom: TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'All Manga'),
              Tab(text: 'Currently Reading'),
              Tab(text: 'Completed'),
              Tab(text: 'On Hold'),
              Tab(text: 'Dropped'),
              Tab(text: 'Plan to Read'),
            ],
          ),
          actions: <Widget>[
            CustomFilter('manga'),
          ],
        ),
        body: TabBarView(
          children: [
            UserList(type: AllAnimeListType(), order: order),
            UserList(type: ReadingMangaListType(), order: order),
            UserList(type: CompletedAnimeListType(), order: order),
            UserList(type: OnHoldAnimeListType(), order: order),
            UserList(type: DroppedAnimeListType(), order: order),
            UserList(type: PlanToReadMangaListType(), order: order),
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
      future: JikanApi().getUserMangaList('javoeria', widget.type, order: widget.order),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Center(child: CircularProgressIndicator());
        }

        BuiltList<MangaItem> animeList = snapshot.data;
        return ListView.builder(
          padding: const EdgeInsets.all(12.0),
          itemCount: animeList.length,
          itemBuilder: (context, index) {
            MangaItem item = animeList.elementAt(index);
            String score = item.score == 0 ? '-' : item.score.toString();
            String read = item.readVolumes == 0 ? '-' : item.readVolumes.toString();
            String total = item.totalVolumes == 0 ? '-' : item.totalVolumes.toString();
            String progress = read == total ? total : '$read / $total';
            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        Container(color: statusColor(item.readingStatus), width: 5.0, height: 70.0),
                        Image.network(item.imageUrl, width: 50.0, height: 70.0, fit: BoxFit.cover),
                        SizedBox(width: 8.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(item.title, style: Theme.of(context).textTheme.subtitle),
                              Text(item.type + ' ($progress vols)', style: Theme.of(context).textTheme.caption),
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
