import 'package:flutter/material.dart';
import 'package:jikan_dart/jikan_dart.dart';
import 'package:built_collection/built_collection.dart' show BuiltList;
import 'package:myanimelist/widgets/item_anime.dart';

class AnimeCharactersStaff extends StatefulWidget {
  AnimeCharactersStaff(this.id);

  final int id;

  @override
  _AnimeCharactersStaffState createState() => _AnimeCharactersStaffState();
}

class _AnimeCharactersStaffState extends State<AnimeCharactersStaff>
    with AutomaticKeepAliveClientMixin<AnimeCharactersStaff> {
  Future<CharacterStaff> _future;

  @override
  void initState() {
    super.initState();
    _future = JikanApi().getCharacterStaff(widget.id);
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

        CharacterStaff list = snapshot.data;
        if ((list.characters.length + list.staff.length) == 0) {
          return ListTile(title: Text('No items found.'));
        }
        return Scrollbar(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(height: 12.0),
                Column(
                  children: list.characters.map((Character character) {
                    BuiltList<VoiceActor> actors = character.voiceActors;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
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
                          actors.length > 0
                              ? Expanded(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: <Widget>[
                                            Text(actors.first.name, textAlign: TextAlign.end),
                                            SizedBox(height: 4.0),
                                            Text(actors.first.language, style: Theme.of(context).textTheme.caption),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 8.0),
                                      ItemAnime(
                                          actors.first.malId, '', actors.first.imageUrl.replaceFirst('/r/23x32', ''),
                                          width: 50.0, height: 70.0, type: TopType.people),
                                    ],
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                    );
                  }).toList(),
                ),
                Divider(height: 8.0),
                Column(
                  children: list.staff.map((Staff staff) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                      child: Row(
                        children: <Widget>[
                          ItemAnime(staff.malId, '', staff.imageUrl, width: 50.0, height: 70.0, type: TopType.people),
                          SizedBox(width: 8.0),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(staff.name),
                                SizedBox(height: 4.0),
                                Text(staff.positions.join(', '), style: Theme.of(context).textTheme.caption),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 12.0),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
