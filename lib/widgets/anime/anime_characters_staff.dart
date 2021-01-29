import 'package:flutter/material.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:built_collection/built_collection.dart' show BuiltList;
import 'package:myanimelist/constants.dart';
import 'package:myanimelist/widgets/title_anime.dart';

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
    _future = Jikan().getAnimeCharactersStaff(widget.id);
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
        final List<ListItem> items = [];
        items.addAll(list.characters.map((ch) => CharacterItem(ch)));
        items.add(DividerItem());
        items.addAll(list.staff.map((st) => StaffItem(st)));
        return Scrollbar(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              if (item is CharacterItem) {
                CharacterRole character = item.character;
                BuiltList<VoiceActor> actors = character.voiceActors;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Row(
                          children: <Widget>[
                            TitleAnime(
                              character.malId,
                              '',
                              character.imageUrl,
                              width: kImageWidthS,
                              height: kImageHeightS,
                              type: TopType.characters,
                            ),
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
                      actors.isNotEmpty
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
                                  TitleAnime(
                                    actors.first.malId,
                                    '',
                                    actors.first.imageUrl.replaceFirst('/r/42x62', ''),
                                    width: kImageWidthS,
                                    height: kImageHeightS,
                                    type: TopType.people,
                                  ),
                                ],
                              ),
                            )
                          : Container(),
                    ],
                  ),
                );
              } else if (item is StaffItem) {
                Staff staff = item.staff;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                  child: Row(
                    children: <Widget>[
                      TitleAnime(
                        staff.malId,
                        '',
                        staff.imageUrl,
                        width: kImageWidthS,
                        height: kImageHeightS,
                        type: TopType.people,
                      ),
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
              }
              return Divider(height: 8.0);
            },
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

abstract class ListItem {}

class DividerItem implements ListItem {}

class CharacterItem implements ListItem {
  CharacterItem(this.character);

  final CharacterRole character;
}

class StaffItem implements ListItem {
  StaffItem(this.staff);

  final Staff staff;
}
