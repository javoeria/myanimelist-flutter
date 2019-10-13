import 'package:flutter/material.dart';
import 'package:jikan_dart/jikan_dart.dart';
import 'package:built_collection/built_collection.dart' show BuiltList;
import 'package:myanimelist/screens/manga_screen.dart';
import 'package:myanimelist/widgets/profile/custom_filter.dart';

class MangaListScreen extends StatelessWidget {
  MangaListScreen(this.username, {this.order});

  final String username;
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
          actions: <Widget>[CustomFilter(username, 'manga')],
        ),
        body: TabBarView(
          children: [
            UserMangaList(username, type: AllAnimeListType(), order: order),
            UserMangaList(username, type: ReadingMangaListType(), order: order),
            UserMangaList(username, type: CompletedAnimeListType(), order: order),
            UserMangaList(username, type: OnHoldAnimeListType(), order: order),
            UserMangaList(username, type: DroppedAnimeListType(), order: order),
            UserMangaList(username, type: PlanToReadMangaListType(), order: order),
          ],
        ),
      ),
    );
  }
}

class UserMangaList extends StatefulWidget {
  UserMangaList(this.username, {this.type, this.order});

  final String username;
  final MangaAnimeListType type;
  final String order;

  @override
  _UserMangaListState createState() => _UserMangaListState();
}

class _UserMangaListState extends State<UserMangaList> with AutomaticKeepAliveClientMixin<UserMangaList> {
  Future<BuiltList<MangaItem>> _future;

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
        throw 'MangaStatus Error';
    }
  }

  @override
  void initState() {
    super.initState();
    _future = JikanApi().getUserMangaList(widget.username, widget.type, order: widget.order);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Center(child: CircularProgressIndicator());
        }

        BuiltList<MangaItem> mangaList = snapshot.data;
        if (mangaList.length == 0) {
          return ListTile(title: Text('No items found.'));
        }
        return Scrollbar(
          child: ListView.builder(
            padding: const EdgeInsets.all(12.0),
            itemCount: mangaList.length,
            itemBuilder: (context, index) {
              MangaItem item = mangaList.elementAt(index);
              String score = item.score == 0 ? '-' : item.score.toString();
              String read = item.readVolumes == 0 ? '-' : item.readVolumes.toString();
              String total = item.totalVolumes == 0 ? '-' : item.totalVolumes.toString();
              String progress = read == total ? total : '$read / $total';
              return InkWell(
                child: Padding(
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
                ),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => MangaScreen(item.malId, item.title)));
                },
              );
            },
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
