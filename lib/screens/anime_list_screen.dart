import 'package:flutter/material.dart';
import 'package:myanimelist/constants.dart';
import 'package:myanimelist/oauth.dart';
import 'package:myanimelist/screens/anime_screen.dart';
import 'package:myanimelist/widgets/profile/custom_filter_v2.dart';

class AnimeListScreen extends StatelessWidget {
  const AnimeListScreen(this.username, {this.title, this.order, this.sort});

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
          title: const Text('Anime List'),
          bottom: const TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.center,
            tabs: <Tab>[
              Tab(text: 'All Anime'),
              Tab(text: 'Currently Watching'),
              Tab(text: 'Completed'),
              Tab(text: 'On Hold'),
              Tab(text: 'Dropped'),
              Tab(text: 'Plan to Watch'),
            ],
          ),
          actions: [CustomFilterV2(username)],
        ),
        body: FutureBuilder(
          future: MalClient().getUserList(username, sort: sort),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }

            final List<dynamic> userList = snapshot.data!;
            return TabBarView(
              children: <UserAnimeList>[
                UserAnimeList(userList),
                UserAnimeList(userList.where((anime) => anime['list_status']['status'] == 'watching').toList()),
                UserAnimeList(userList.where((anime) => anime['list_status']['status'] == 'completed').toList()),
                UserAnimeList(userList.where((anime) => anime['list_status']['status'] == 'on_hold').toList()),
                UserAnimeList(userList.where((anime) => anime['list_status']['status'] == 'dropped').toList()),
                UserAnimeList(userList.where((anime) => anime['list_status']['status'] == 'plan_to_watch').toList()),
              ],
            );
          },
        ),
      ),
    );
  }
}

class UserAnimeList extends StatelessWidget {
  const UserAnimeList(this.userList);

  final List<dynamic> userList;

  @override
  Widget build(BuildContext context) {
    if (userList.isEmpty) {
      return const ListTile(title: Text('No items found.'));
    }

    return Scrollbar(
      child: ListView.builder(
        padding: const EdgeInsets.all(12.0),
        itemCount: userList.length,
        itemBuilder: (context, index) {
          Map<String, dynamic> item = userList.elementAt(index);
          String type = ['tv', 'ova', 'ona'].contains(item['node']['media_type'])
              ? item['node']['media_type'].toString().toUpperCase()
              : item['node']['media_type'].toString().toTitleCase();
          String watched = item['list_status']['num_episodes_watched'] == 0
              ? '-'
              : item['list_status']['num_episodes_watched'].toString();
          String total = item['node']['num_episodes'] == 0 ? '-' : item['node']['num_episodes'].toString();
          String progress = item['list_status']['status'] == 'completed' ? total : '$watched / $total';
          String score = item['list_status']['score'] == 0 ? '-' : item['list_status']['score'].toString();
          return InkWell(
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                children: <Widget>[
                  Container(color: statusColor(item['list_status']['status']), width: 6.0, height: kImageHeightS),
                  Image.network(
                    item['node']['main_picture']['large'],
                    width: kImageWidthS,
                    height: kImageHeightS,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Text>[
                        Text(item['node']['title'], style: Theme.of(context).textTheme.titleSmall),
                        Text('$type ($progress eps)', style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ),
                  ),
                  Text(score, style: Theme.of(context).textTheme.bodyLarge),
                ],
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      AnimeScreen(item['node']['id'], item['node']['title'], episodes: item['node']['num_episodes']),
                  settings: const RouteSettings(name: 'AnimeScreen'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
