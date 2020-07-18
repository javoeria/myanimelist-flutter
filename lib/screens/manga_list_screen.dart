import 'package:flutter/material.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:myanimelist/constants.dart';
import 'package:myanimelist/models/user_list.dart';
import 'package:myanimelist/screens/manga_screen.dart';
import 'package:myanimelist/widgets/profile/custom_filter.dart';
import 'package:provider/provider.dart';

class MangaListScreen extends StatelessWidget {
  MangaListScreen(this.username, {this.title, this.order, this.sort});

  final String username;
  final String title;
  final String order;
  final String sort;

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => UserList(username, title, order, sort, 'manga'),
      // dispose: (context, value) => value.dispose(),
      child: DefaultTabController(
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
            actions: <Widget>[CustomFilter()],
          ),
          body: TabBarView(
            children: [
              UserMangaList(type: ListType.all),
              UserMangaList(type: ListType.reading),
              UserMangaList(type: ListType.completed),
              UserMangaList(type: ListType.onhold),
              UserMangaList(type: ListType.dropped),
              UserMangaList(type: ListType.plantoread),
            ],
          ),
        ),
      ),
    );
  }
}

class UserMangaList extends StatefulWidget {
  UserMangaList({this.type});

  final ListType type;

  @override
  _UserMangaListState createState() => _UserMangaListState();
}

class _UserMangaListState extends State<UserMangaList> with AutomaticKeepAliveClientMixin<UserMangaList> {
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
        throw 'MangaStatus Error';
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
        pageFuture: (pageIndex) => Jikan().getUserMangaList(
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
                  Image.network(
                    item.imageUrl,
                    width: kImageWidth,
                    height: kImageHeight,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(width: 8.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(item.title, style: Theme.of(context).textTheme.subtitle2),
                        Text(
                          '${item.type} ($progress vols)',
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
            builder: (context) => MangaScreen(item.malId, item.title),
            settings: RouteSettings(name: 'MangaScreen'),
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
