import 'package:flutter/material.dart';
import 'package:jikan_dart/jikan_dart.dart';
import 'package:myanimelist/widgets/item_anime.dart';
import 'package:built_collection/built_collection.dart' show BuiltList;
import 'package:intl/intl.dart' show NumberFormat;
import 'package:myanimelist/widgets/profile/picture_list.dart';

final NumberFormat f = NumberFormat.compact();
const kExpandedHeight = 280.0;

class PersonScreen extends StatefulWidget {
  PersonScreen(this.id);

  final int id;

  @override
  _PersonScreenState createState() => _PersonScreenState();
}

class _PersonScreenState extends State<PersonScreen> {
  ScrollController _scrollController;
  PersonInfo person;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    load();
    _scrollController = ScrollController()..addListener(() => setState(() {}));
  }

  void load() async {
    person = await JikanApi().getPersonInfo(widget.id);
    setState(() => loading = false);
  }

  bool get _showTitle {
    return _scrollController.hasClients && _scrollController.offset > kExpandedHeight - kToolbarHeight;
  }

  @override
  Widget build(BuildContext context) {
    if (loading) return Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      body: CustomScrollView(controller: _scrollController, slivers: <Widget>[
        SliverAppBar(
          pinned: true,
          expandedHeight: kExpandedHeight,
          title: _showTitle ? Text(person.name) : null,
          flexibleSpace: FlexibleSpaceBar(
            background: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Image.network(person.imageUrl, width: 135.0, height: 210.0, fit: BoxFit.cover),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(person.name, style: Theme.of(context).textTheme.title.copyWith(color: Colors.white)),
                          Text((person.familyName ?? '') + (person.givenName ?? ''), style: Theme.of(context).textTheme.subhead.copyWith(color: Colors.white)),
                          SizedBox(height: 24.0),
                          Row(
                            children: <Widget>[
                              Icon(Icons.person, color: Colors.white),
                              Text(f.format(person.memberFavorites), style: Theme.of(context).textTheme.title.copyWith(color: Colors.white)),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate(<Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('About', style: Theme.of(context).textTheme.title),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
              child: Text(person.about, softWrap: true),
            ),
            Divider(),
            // TODO: Voice Acting Roles
            person.animeStaffPositions.length > 0 ? StaffList(person.animeStaffPositions) : Container(),
            person.publishedManga.length > 0 ? PublishList(person.publishedManga) : Container(),
            PictureList(person.malId, type: TopType.people),
          ]),
        ),
      ]),
    );
  }
}

class StaffList extends StatelessWidget {
  StaffList(this.list);

  final BuiltList<AnimeStaff> list;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text('Anime Staff Positions', style: Theme.of(context).textTheme.title),
        ),
        Container(
          height: 163.0,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            itemCount: list.length,
            itemBuilder: (context, index) {
              AnimeStaff staff = list.elementAt(index);
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: ItemAnime(staff.anime.malId, staff.anime.name, staff.anime.imageUrl, width: 108.0, height: 163.0, type: TopType.anime),
              );
            },
          ),
        ),
        Divider(),
      ],
    );
  }
}

class PublishList extends StatelessWidget {
  PublishList(this.list);

  final BuiltList<PublishedManga> list;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text('Published Manga', style: Theme.of(context).textTheme.title),
        ),
        Container(
          height: 163.0,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            itemCount: list.length,
            itemBuilder: (context, index) {
              PublishedManga publish = list.elementAt(index);
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: ItemAnime(publish.manga.malId, publish.manga.name, publish.manga.imageUrl, width: 108.0, height: 163.0, type: TopType.manga),
              );
            },
          ),
        ),
        Divider(),
      ],
    );
  }
}
