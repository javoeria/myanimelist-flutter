import 'package:flutter/material.dart';
import 'package:jikan_dart/jikan_dart.dart';
import 'package:built_collection/built_collection.dart' show BuiltList;
import 'package:myanimelist/widgets/item_anime.dart';

class MangaCharacters extends StatefulWidget {
  MangaCharacters(this.id);

  final int id;

  @override
  _MangaCharactersState createState() => _MangaCharactersState();
}

class _MangaCharactersState extends State<MangaCharacters> with AutomaticKeepAliveClientMixin<MangaCharacters> {
  Future<BuiltList<MangaCharacter>> _future;

  @override
  void initState() {
    super.initState();
    _future = JikanApi().getMangaCharacters(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Center(child: CircularProgressIndicator());
        }

        BuiltList<MangaCharacter> characterList = snapshot.data;
        if (characterList.length == 0) {
          return ListTile(title: Text('No items found.'));
        }
        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          itemCount: characterList.length,
          itemBuilder: (context, index) {
            MangaCharacter character = characterList.elementAt(index);
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        ItemAnime(character.malId, '', character.imageUrl,
                            width: 50.0, height: 70.0, type: TopType.characters),
                        SizedBox(width: 8.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(character.name),
                              SizedBox(height: 4.0),
                              Text(character.role, style: Theme.of(context).textTheme.caption),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
