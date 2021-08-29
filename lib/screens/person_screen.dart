import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:built_collection/built_collection.dart' show BuiltList;
import 'package:intl/intl.dart' show NumberFormat, DateFormat;
import 'package:myanimelist/constants.dart';
import 'package:myanimelist/widgets/profile/about_section.dart';
import 'package:myanimelist/widgets/profile/picture_list.dart';
import 'package:myanimelist/widgets/profile/role_list.dart';
import 'package:myanimelist/widgets/subtitle_anime.dart';
import 'package:firebase_performance/firebase_performance.dart';

class PersonScreen extends StatefulWidget {
  const PersonScreen(this.id);

  final int id;

  @override
  _PersonScreenState createState() => _PersonScreenState();
}

class _PersonScreenState extends State<PersonScreen> {
  final Jikan jikan = Jikan();
  final NumberFormat f = NumberFormat.decimalPattern();
  final DateFormat dateFormat = DateFormat('MMM d, yy');

  late ScrollController _scrollController;
  late Person person;
  late BuiltList<Picture> pictures;
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
              padding: kSliverAppBarPadding,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Image.network(
                          person.imageUrl,
                          width: kSliverAppBarWidth,
                          height: kSliverAppBarHeight,
                          fit: BoxFit.contain,
                          alignment: Alignment.centerRight,
                        ),
                      ),
                      SizedBox(width: 16.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            AutoSizeText(
                              person.name,
                              style: Theme.of(context).textTheme.headline6!.copyWith(color: Colors.white),
                              maxLines: 2,
                            ),
                            person.familyName != null && person.givenName != null
                                ? AutoSizeText(
                                    '${person.familyName} ${person.givenName}',
                                    style: Theme.of(context).textTheme.subtitle1!.copyWith(color: Colors.white),
                                    maxLines: 1,
                                  )
                                : Container(),
                            SizedBox(height: 24.0),
                            Row(
                              children: <Widget>[
                                Icon(Icons.person, color: Colors.white, size: 20.0),
                                SizedBox(width: 4.0),
                                Text(
                                  f.format(person.memberFavorites),
                                  style: Theme.of(context).textTheme.subtitle1!.copyWith(color: Colors.white),
                                ),
                              ],
                            ),
                            person.birthday != null
                                ? Row(
                                    children: <Widget>[
                                      Icon(Icons.cake, color: Colors.white, size: 20.0),
                                      SizedBox(width: 4.0),
                                      Text(
                                        dateFormat.format(DateTime.parse(person.birthday!)),
                                        style: Theme.of(context).textTheme.subtitle1!.copyWith(color: Colors.white),
                                      ),
                                    ],
                                  )
                                : Container(),
                          ],
                        ),
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
            person.voiceActingRoles.isNotEmpty ? RoleList(person.voiceActingRoles) : Container(),
            person.animeStaffPositions.isNotEmpty ? StaffList(person.animeStaffPositions) : Container(),
            person.publishedManga.isNotEmpty ? PublishList(person.publishedManga) : Container(),
            pictures.isNotEmpty ? PictureList(pictures) : Container(),
          ]),
        ),
      ]),
    );
  }
}

class StaffList extends StatelessWidget {
  const StaffList(this.list);

  final BuiltList<AnimeStaff> list;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Divider(height: 0.0),
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 12.0),
          child: Text('Anime Staff Positions', style: Theme.of(context).textTheme.headline6),
        ),
        SizedBox(
          height: kImageHeightM,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            itemCount: list.length,
            itemBuilder: (context, index) {
              AnimeStaff staff = list.elementAt(index);
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: SubtitleAnime(
                  staff.anime.malId,
                  staff.anime.name,
                  staff.position,
                  staff.anime.imageUrl!,
                  type: TopType.anime,
                ),
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
  const PublishList(this.list);

  final BuiltList<PublishedManga> list;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Divider(height: 0.0),
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 12.0),
          child: Text('Published Manga', style: Theme.of(context).textTheme.headline6),
        ),
        SizedBox(
          height: kImageHeightM,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            itemCount: list.length,
            itemBuilder: (context, index) {
              PublishedManga publish = list.elementAt(index);
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: SubtitleAnime(
                  publish.manga.malId,
                  publish.manga.name,
                  publish.position,
                  publish.manga.imageUrl!,
                  type: TopType.manga,
                ),
              );
            },
          ),
        ),
        SizedBox(height: 12.0),
      ],
    );
  }
}
