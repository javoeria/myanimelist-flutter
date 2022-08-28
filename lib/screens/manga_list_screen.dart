import 'package:flutter/material.dart';
import 'package:myanimelist/constants.dart';
import 'package:myanimelist/oauth.dart';
import 'package:myanimelist/screens/manga_screen.dart';
import 'package:myanimelist/widgets/profile/custom_filter_v2.dart';

class MangaListScreen extends StatelessWidget {
  const MangaListScreen(this.username, {this.title, this.order, this.sort});

  final String username;
  final String? title;
  final String? order;
  final String? sort;

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
            tabs: const <Tab>[
              Tab(text: 'All Manga'),
              Tab(text: 'Currently Reading'),
              Tab(text: 'Completed'),
              Tab(text: 'On Hold'),
              Tab(text: 'Dropped'),
              Tab(text: 'Plan to Read'),
            ],
          ),
          actions: <Widget>[CustomFilterV2(username, anime: false)],
        ),
        body: FutureBuilder(
          future: MalClient().getUserList(username, sort: sort, anime: false),
          builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return Center(child: CircularProgressIndicator());
            }

            List<dynamic> userList = snapshot.data!;
            List<dynamic> reading = userList.where((manga) => manga['list_status']['status'] == 'reading').toList();
            List<dynamic> completed = userList.where((manga) => manga['list_status']['status'] == 'completed').toList();
            List<dynamic> onHold = userList.where((manga) => manga['list_status']['status'] == 'on_hold').toList();
            List<dynamic> dropped = userList.where((manga) => manga['list_status']['status'] == 'dropped').toList();
            List<dynamic> planToRead =
                userList.where((manga) => manga['list_status']['status'] == 'plan_to_read').toList();
            return TabBarView(
              children: <Widget>[
                UserMangaList(userList),
                UserMangaList(reading),
                UserMangaList(completed),
                UserMangaList(onHold),
                UserMangaList(dropped),
                UserMangaList(planToRead),
              ],
            );
          },
        ),
      ),
    );
  }
}

class UserMangaList extends StatefulWidget {
  const UserMangaList(this.userList);

  final List<dynamic> userList;

  @override
  _UserMangaListState createState() => _UserMangaListState();
}

class _UserMangaListState extends State<UserMangaList> with AutomaticKeepAliveClientMixin<UserMangaList> {
  Color statusColor(String status) {
    switch (status) {
      case 'reading':
        return kWatchingColor;
      case 'completed':
        return kCompletedColor;
      case 'on_hold':
        return kOnHoldColor;
      case 'dropped':
        return kDroppedColor;
      case 'plan_to_read':
        return kPlantoWatchColor;
      default:
        throw 'MangaStatus Error';
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (widget.userList.isEmpty) {
      return ListTile(title: Text('No items found.'));
    }
    return Scrollbar(
      child: ListView.builder(
        padding: const EdgeInsets.all(12.0),
        itemCount: widget.userList.length,
        itemBuilder: (context, index) {
          Map<String, dynamic> item = widget.userList.elementAt(index);
          String score = item['list_status']['score'] == 0 ? '-' : item['list_status']['score'].toString();
          String read =
              item['list_status']['num_volumes_read'] == 0 ? '-' : item['list_status']['num_volumes_read'].toString();
          String total = item['node']['num_volumes'] == 0 ? '-' : item['node']['num_volumes'].toString();
          String progress = item['list_status']['status'] == 'completed' ? total : '$read / $total';
          String type = item['node']['media_type'][0].toUpperCase() + item['node']['media_type'].substring(1);
          return InkWell(
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        Container(color: statusColor(item['list_status']['status']), width: 5.0, height: kImageHeightS),
                        Image.network(
                          item['node']['main_picture']['large'],
                          width: kImageWidthS,
                          height: kImageHeightS,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(width: 8.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(item['node']['title'], style: Theme.of(context).textTheme.subtitle2),
                              Text(
                                '$type ($progress vols)',
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
                  builder: (context) => MangaScreen(item['node']['id'], item['node']['title']),
                  settings: RouteSettings(name: 'MangaScreen'),
                ),
              );
            },
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
