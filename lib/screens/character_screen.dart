import 'package:flutter/material.dart';
import 'package:jikan_dart/jikan_dart.dart';
import 'package:myanimelist/widgets/item_anime.dart';
import 'package:built_collection/built_collection.dart' show BuiltList;
import 'package:intl/intl.dart' show NumberFormat;
import 'package:myanimelist/widgets/profile/about_section.dart';
import 'package:myanimelist/widgets/profile/picture_list.dart';

const kExpandedHeight = 280.0;

class CharacterScreen extends StatefulWidget {
  CharacterScreen(this.id);

  final int id;

  @override
  _CharacterScreenState createState() => _CharacterScreenState();
}

class _CharacterScreenState extends State<CharacterScreen> {
  final JikanApi jikanApi = JikanApi();
  final NumberFormat f = NumberFormat.compact();

  ScrollController _scrollController;
  CharacterInfo character;
  BuiltList<Picture> pictures;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    load();
    _scrollController = ScrollController()..addListener(() => setState(() {}));
  }

  void load() async {
    character = await jikanApi.getCharacterInfo(widget.id);
    pictures = await jikanApi.getCharactersPictures(widget.id);
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
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.network(character.imageUrl, width: 135.0, height: 210.0, fit: BoxFit.cover),
                      SizedBox(width: 24.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(character.name, style: Theme.of(context).textTheme.title.copyWith(color: Colors.white)),
                          Text(character.nameKanji ?? '',
                              style: Theme.of(context).textTheme.subhead.copyWith(color: Colors.white)),
                          SizedBox(height: 24.0),
                          Row(
                            children: <Widget>[
                              Icon(Icons.person, color: Colors.white),
                              SizedBox(width: 4.0),
                              Text(f.format(character.memberFavorites),
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
            AboutSection(character.about),
            character.animeography.length > 0
                ? AnimeographyList(character.animeography, type: TopType.anime)
                : Container(),
            character.mangaography.length > 0
                ? AnimeographyList(character.mangaography, type: TopType.manga)
                : Container(),
            character.voiceActors.length > 0 ? VoiceList(character.voiceActors) : Container(),
            pictures.length > 0 ? PictureList(pictures) : Container(),
          ]),
        ),
      ]),
    );
  }
}

class AnimeographyList extends StatelessWidget {
  AnimeographyList(this.list, {this.type});

  final BuiltList<MangaCharacter> list;
  final TopType type;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Divider(height: 0.0),
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 12.0),
          child:
              Text(type == TopType.anime ? 'Animeography' : 'Mangaography', style: Theme.of(context).textTheme.title),
        ),
        Container(
          height: 163.0,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            itemCount: list.length,
            itemBuilder: (context, index) {
              MangaCharacter anime = list.elementAt(index);
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: ItemAnime(anime.malId, anime.name, anime.imageUrl, width: 108.0, height: 163.0, type: type),
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
          child: Text('Voice Actors', style: Theme.of(context).textTheme.title),
        ),
        Container(
          height: 163.0,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            itemCount: list.length,
            itemBuilder: (context, index) {
              VoiceActor anime = list.elementAt(index);
              String image = anime.imageUrl.replaceFirst('v.jpg', '.jpg');
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: ItemAnime(anime.malId, anime.name, image, width: 108.0, height: 163.0, type: TopType.people),
              );
            },
          ),
        ),
        SizedBox(height: 12.0),
      ],
    );
  }
}
