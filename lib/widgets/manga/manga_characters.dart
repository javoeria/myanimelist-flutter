import 'package:flutter/material.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:myanimelist/constants.dart';
import 'package:myanimelist/widgets/title_anime.dart';

class MangaCharacters extends StatefulWidget {
  const MangaCharacters(this.id);

  final int id;

  @override
  _MangaCharactersState createState() => _MangaCharactersState();
}

class _MangaCharactersState extends State<MangaCharacters> with AutomaticKeepAliveClientMixin<MangaCharacters> {
  late Future<BuiltList<CharacterMeta>> _future;

  @override
  void initState() {
    super.initState();
    _future = jikan.getMangaCharacters(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
      future: _future,
      builder: (context, AsyncSnapshot<BuiltList<CharacterMeta>> snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Center(child: CircularProgressIndicator());
        }

        BuiltList<CharacterMeta> characterList = snapshot.data!;
        if (characterList.isEmpty) {
          return ListTile(title: Text('No items found.'));
        }
        return Scrollbar(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            itemCount: characterList.length,
            itemBuilder: (context, index) {
              CharacterMeta character = characterList.elementAt(index);
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  children: <Widget>[
                    TitleAnime(
                      character.malId,
                      '',
                      character.imageUrl,
                      width: kImageWidthS,
                      height: kImageHeightS,
                      type: ItemType.characters,
                    ),
                    SizedBox(width: 8.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(character.name),
                          SizedBox(height: 4.0),
                          Text(character.role, style: Theme.of(context).textTheme.bodySmall),
                        ],
                      ),
                    ),
                  ],
                ),
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
