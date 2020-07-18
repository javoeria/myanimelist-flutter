import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:built_collection/built_collection.dart' show BuiltList;
import 'package:intl/intl.dart' show NumberFormat;
import 'package:myanimelist/constants.dart';
import 'package:myanimelist/widgets/profile/about_section.dart';
import 'package:myanimelist/widgets/profile/picture_list.dart';
import 'package:myanimelist/widgets/subtitle_anime.dart';
import 'package:myanimelist/widgets/title_anime.dart';
import 'package:firebase_performance/firebase_performance.dart';

class CharacterScreen extends StatefulWidget {
  CharacterScreen(this.id);

  final int id;

  @override
  _CharacterScreenState createState() => _CharacterScreenState();
}

class _CharacterScreenState extends State<CharacterScreen> {
  final Jikan jikan = Jikan();
  final NumberFormat f = NumberFormat.compact();

  ScrollController _scrollController;
  Character character;
  BuiltList<Picture> pictures;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    load();
    _scrollController = ScrollController()..addListener(() => setState(() {}));
  }

  void load() async {
    final Trace characterTrace = FirebasePerformance.instance.newTrace('character_trace');
    characterTrace.start();
    character = await jikan.getCharacterInfo(widget.id);
    pictures = await jikan.getCharacterPictures(widget.id);
    characterTrace.stop();
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
          title: _showTitle ? Text(character.name) : null,
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
                          character.imageUrl,
                          width: kSliverAppBarWidth,
                          height: kSliverAppBarHeight,
                          fit: BoxFit.contain,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            AutoSizeText(
                              character.name,
                              style: Theme.of(context).textTheme.headline6.copyWith(color: Colors.white),
                              maxLines: 2,
                            ),
                            AutoSizeText(
                              character.nameKanji ?? '',
                              style: Theme.of(context).textTheme.subtitle1.copyWith(color: Colors.white),
                              maxLines: 1,
                            ),
                            SizedBox(height: 24.0),
                            Row(
                              children: <Widget>[
                                Icon(Icons.person, color: Colors.white),
                                SizedBox(width: 4.0),
                                Text(
                                  f.format(character.memberFavorites),
                                  style: Theme.of(context).textTheme.headline6.copyWith(color: Colors.white),
                                ),
                              ],
                            ),
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
            AboutSection(character.about),
            character.animeography.isNotEmpty
                ? AnimeographyList(character.animeography, type: TopType.anime)
                : Container(),
            character.mangaography.isNotEmpty
                ? AnimeographyList(character.mangaography, type: TopType.manga)
                : Container(),
            character.voiceActors.isNotEmpty ? VoiceList(character.voiceActors) : Container(),
            pictures.isNotEmpty ? PictureList(pictures) : Container(),
          ]),
        ),
      ]),
    );
  }
}

class AnimeographyList extends StatelessWidget {
  AnimeographyList(this.list, {this.type});

  final BuiltList<CharacterRole> list;
  final TopType type;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Divider(height: 0.0),
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 12.0),
          child: Text(
            type == TopType.anime ? 'Animeography' : 'Mangaography',
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        Container(
          height: kContainerHeight,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            itemCount: list.length,
            itemBuilder: (context, index) {
              CharacterRole anime = list.elementAt(index);
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: TitleAnime(
                  anime.malId,
                  anime.name,
                  anime.imageUrl,
                  width: kContainerWidth,
                  height: kContainerHeight,
                  type: type,
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

class VoiceList extends StatelessWidget {
  VoiceList(this.list);

  final BuiltList<VoiceActor> list;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Divider(height: 0.0),
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 12.0),
          child: Text('Voice Actors', style: Theme.of(context).textTheme.headline6),
        ),
        Container(
          height: kContainerHeight,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            itemCount: list.length,
            itemBuilder: (context, index) {
              VoiceActor anime = list.elementAt(index);
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: SubtitleAnime(
                  anime.malId,
                  anime.name,
                  anime.language,
                  anime.imageUrl.replaceFirst('v.jpg', '.jpg'),
                  type: TopType.people,
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
