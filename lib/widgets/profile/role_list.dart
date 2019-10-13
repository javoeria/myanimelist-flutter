import 'package:flutter/material.dart';
import 'package:jikan_dart/jikan_dart.dart';
import 'package:built_collection/built_collection.dart' show BuiltList;
import 'package:myanimelist/widgets/item_anime.dart';

class RoleList extends StatelessWidget {
  RoleList(this.list);

  final BuiltList<VoiceActing> list;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Divider(height: 0.0),
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 12.0),
          child: Text('Voice Acting Roles', style: Theme.of(context).textTheme.title),
        ),
        Column(
          children: list.map((VoiceActing role) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        ItemAnime(role.anime.malId, role.anime.name, role.anime.imageUrl,
                            width: 50.0, height: 70.0, type: TopType.anime, showTitle: false),
                        SizedBox(width: 8.0),
                        Expanded(child: Text(role.anime.name)),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Text(role.character.name, textAlign: TextAlign.end),
                              SizedBox(height: 4.0),
                              Text(role.role, style: Theme.of(context).textTheme.caption),
                            ],
                          ),
                        ),
                        SizedBox(width: 8.0),
                        ItemAnime(role.character.malId, '', role.character.imageUrl,
                            width: 50.0, height: 70.0, type: TopType.characters),
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
    );
  }
}
