import 'package:flutter/material.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:myanimelist/constants.dart';
import 'package:myanimelist/widgets/title_anime.dart';

class AnimeCharactersStaff extends StatefulWidget {
  const AnimeCharactersStaff(this.id);

  final int id;

  @override
  _AnimeCharactersStaffState createState() => _AnimeCharactersStaffState();
}

class _AnimeCharactersStaffState extends State<AnimeCharactersStaff>
    with AutomaticKeepAliveClientMixin<AnimeCharactersStaff> {
  final Jikan jikan = Jikan();

  late BuiltList<CharacterMeta> characters;
  late BuiltList<PersonMeta> staff;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    characters = await jikan.getAnimeCharacters(widget.id);
    staff = await jikan.getAnimeStaff(widget.id);
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (loading) {
      return Center(child: CircularProgressIndicator());
    }

    final List<dynamic> items = [];
    items.addAll(characters.toList());
    items.add(Divider(height: 8.0));
    items.addAll(staff.toList());
    return Scrollbar(
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        itemCount: items.length,
        itemBuilder: (context, index) {
          dynamic item = items.elementAt(index);
          if (item is CharacterMeta) {
            BuiltList<PersonMeta> actors = item.voiceActors!;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        TitleAnime(
                          item.malId,
                          '',
                          item.imageUrl,
                          width: kImageWidthS,
                          height: kImageHeightS,
                          type: ItemType.characters,
                        ),
                        SizedBox(width: 8.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(item.name),
                              SizedBox(height: 4.0),
                              Text(item.role, style: Theme.of(context).textTheme.caption),
                              SizedBox(height: 4.0),
                              Text('${item.favorites ?? 0} Favorites', style: Theme.of(context).textTheme.caption),
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
                                    Text(actors.first.language!, style: Theme.of(context).textTheme.caption),
                                  ],
                                ),
                              ),
                              SizedBox(width: 8.0),
                              TitleAnime(
                                actors.first.malId,
                                '',
                                actors.first.imageUrl,
                                width: kImageWidthS,
                                height: kImageHeightS,
                                type: ItemType.people,
                              ),
                            ],
                          ),
                        )
                      : Container(),
                ],
              ),
            );
          } else if (item is PersonMeta) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
              child: Row(
                children: <Widget>[
                  TitleAnime(
                    item.malId,
                    '',
                    item.imageUrl,
                    width: kImageWidthS,
                    height: kImageHeightS,
                    type: ItemType.people,
                  ),
                  SizedBox(width: 8.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(item.name),
                        SizedBox(height: 4.0),
                        Text(item.positions!.join(', '), style: Theme.of(context).textTheme.caption),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
          return item;
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
