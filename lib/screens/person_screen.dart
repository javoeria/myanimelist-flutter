import 'package:flutter/material.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:built_collection/built_collection.dart' show BuiltList;
import 'package:intl/intl.dart' show NumberFormat;
import 'package:myanimelist/widgets/profile/about_section.dart';
import 'package:myanimelist/widgets/profile/picture_list.dart';
import 'package:myanimelist/widgets/profile/role_list.dart';
import 'package:myanimelist/widgets/subtitle_anime.dart';
import 'package:firebase_performance/firebase_performance.dart';

const kExpandedHeight = 280.0;

class PersonScreen extends StatefulWidget {
  PersonScreen(this.id);

  final int id;

  @override
  _PersonScreenState createState() => _PersonScreenState();
}

class _PersonScreenState extends State<PersonScreen> {
  final Jikan jikan = Jikan();
  final NumberFormat f = NumberFormat.compact();

  ScrollController _scrollController;
  Person person;
  BuiltList<Picture> pictures;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    load();
    _scrollController = ScrollController()..addListener(() => setState(() {}));
  }

  void load() async {
    final Trace personTrace = FirebasePerformance.instance.newTrace('person_trace');
    personTrace.start();
    person = await jikan.getPersonInfo(widget.id);
    pictures = await jikan.getPersonPictures(widget.id);
    personTrace.stop();
    setState(() => loading = false);
  }

  bool get _showTitle {
    return _scrollController.hasClients && _scrollController.offset > kExpandedHeight - kToolbarHeight;
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Scaffold(appBar: AppBar(), body: Center(child: CircularProgressIndicator()));
    }

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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.network(person.imageUrl, width: 135.0, height: 210.0, fit: BoxFit.cover),
                      SizedBox(width: 24.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(person.name, style: Theme.of(context).textTheme.title.copyWith(color: Colors.white)),
                          Text((person.familyName ?? '') + (person.givenName ?? ''),
                              style: Theme.of(context).textTheme.subhead.copyWith(color: Colors.white)),
                          SizedBox(height: 24.0),
                          Row(
                            children: <Widget>[
                              Icon(Icons.person, color: Colors.white),
                              SizedBox(width: 4.0),
                              Text(f.format(person.memberFavorites),
                                  style: Theme.of(context).textTheme.title.copyWith(color: Colors.white)),
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
            AboutSection(person.about),
            person.voiceActingRoles.length > 0 ? RoleList(person.voiceActingRoles) : Container(),
            person.animeStaffPositions.length > 0 ? StaffList(person.animeStaffPositions) : Container(),
            person.publishedManga.length > 0 ? PublishList(person.publishedManga) : Container(),
            pictures.length > 0 ? PictureList(pictures) : Container(),
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
        Divider(height: 0.0),
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 12.0),
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
                child: SubtitleAnime(staff.anime.malId, staff.anime.name, staff.position, staff.anime.imageUrl,
                    type: TopType.anime),
              );
            },
          ),
        ),
        SizedBox(height: 12.0),
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
        Divider(height: 0.0),
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 12.0),
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
                child: SubtitleAnime(publish.manga.malId, publish.manga.name, publish.position, publish.manga.imageUrl,
                    type: TopType.manga),
              );
            },
          ),
        ),
        SizedBox(height: 12.0),
      ],
    );
  }
}
