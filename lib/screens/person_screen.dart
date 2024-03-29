import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/material.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:myanimelist/constants.dart';
import 'package:myanimelist/widgets/profile/about_section.dart';
import 'package:myanimelist/widgets/profile/picture_list.dart';
import 'package:myanimelist/widgets/profile/role_list.dart';
import 'package:myanimelist/widgets/subtitle_anime.dart';

class PersonScreen extends StatefulWidget {
  const PersonScreen(this.id);

  final int id;

  @override
  State<PersonScreen> createState() => _PersonScreenState();
}

class _PersonScreenState extends State<PersonScreen> {
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
    person = await jikan.getPerson(widget.id);
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
      return Scaffold(appBar: AppBar(), body: const Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            expandedHeight: kExpandedHeight,
            title: _showTitle ? Text(person.name) : null,
            flexibleSpace: FlexibleSpaceBar(
              background: Padding(
                padding: kSliverAppBarPadding,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
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
                    const SizedBox(width: 24.0),
                    Expanded(
                      child: SizedBox(
                        height: kSliverAppBarHeight,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            AutoSizeText(
                              person.name,
                              style: Theme.of(context).textTheme.titleLarge,
                              maxLines: 2,
                            ),
                            person.familyName != null && person.givenName != null
                                ? AutoSizeText(
                                    '${person.familyName} ${person.givenName}',
                                    style: Theme.of(context).textTheme.titleSmall,
                                    maxLines: 1,
                                  )
                                : Container(),
                            const SizedBox(height: 24.0),
                            Row(
                              children: <Widget>[
                                const Icon(Icons.person, size: 20.0),
                                const SizedBox(width: 4.0),
                                Text(
                                  person.favorites.decimal(),
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                              ],
                            ),
                            person.birthday != null
                                ? Row(
                                    children: <Widget>[
                                      const Icon(Icons.cake, size: 20.0),
                                      const SizedBox(width: 4.0),
                                      Text(
                                        person.birthday!.formatDate(pattern: 'MMM d, yy'),
                                        style: Theme.of(context).textTheme.bodyLarge,
                                      ),
                                    ],
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              AboutSection(person.about),
              person.voices!.isNotEmpty ? RoleList(person.voices!) : Container(),
              person.anime!.isNotEmpty ? StaffList(person.anime!) : Container(),
              person.manga!.isNotEmpty ? PublishList(person.manga!) : Container(),
              pictures.isNotEmpty ? PictureList(pictures) : Container(),
            ]),
          ),
        ],
      ),
    );
  }
}

class StaffList extends StatelessWidget {
  const StaffList(this.list);

  final BuiltList<AnimeMeta> list;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Divider(height: 0.0),
        Padding(
          padding: kTitlePadding,
          child: Text('Anime Staff Positions', style: Theme.of(context).textTheme.titleMedium),
        ),
        SizedBox(
          height: kImageHeightM,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            itemCount: list.length,
            itemBuilder: (context, index) {
              AnimeMeta anime = list.elementAt(index);
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: SubtitleAnime(
                  anime.malId,
                  anime.title,
                  anime.position!.replaceFirst('add ', ''),
                  anime.imageUrl,
                  type: ItemType.anime,
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12.0),
      ],
    );
  }
}

class PublishList extends StatelessWidget {
  const PublishList(this.list);

  final BuiltList<MangaMeta> list;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Divider(height: 0.0),
        Padding(
          padding: kTitlePadding,
          child: Text('Published Manga', style: Theme.of(context).textTheme.titleMedium),
        ),
        SizedBox(
          height: kImageHeightM,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            itemCount: list.length,
            itemBuilder: (context, index) {
              MangaMeta manga = list.elementAt(index);
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: SubtitleAnime(
                  manga.malId,
                  manga.title,
                  manga.position!,
                  manga.imageUrl,
                  type: ItemType.manga,
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12.0),
      ],
    );
  }
}
