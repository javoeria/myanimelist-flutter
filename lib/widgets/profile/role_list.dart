import 'package:flutter/material.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:built_collection/built_collection.dart' show BuiltList;
import 'package:myanimelist/constants.dart';
import 'package:myanimelist/widgets/title_anime.dart';

class RoleList extends StatelessWidget {
  RoleList(this.list);

  final BuiltList<VoiceActing> list;

  @override
  Widget build(BuildContext context) {
    BuiltList<VoiceActing> _shortList =
        list.length > 50 ? BuiltList.from(list.where((a) => a.role == 'Main').take(50)) : list;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Divider(height: 0.0),
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Voice Acting Roles', style: Theme.of(context).textTheme.headline6),
              if (list.length > 50)
                IconButton(
                  icon: Icon(Icons.chevron_right),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FullRoleList(list),
                        settings: RouteSettings(name: 'VoiceActingRolesScreen'),
                      ),
                    );
                  },
                )
            ],
          ),
        ),
        Column(
          children: _shortList.map((VoiceActing role) {
            return RoleItem(role);
          }).toList(),
        ),
        SizedBox(height: 12.0),
      ],
    );
  }
}

class FullRoleList extends StatelessWidget {
  FullRoleList(this.list);

  final BuiltList<VoiceActing> list;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Voice Acting Roles'),
      ),
      body: Scrollbar(
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          itemCount: list.length,
          itemBuilder: (context, index) {
            VoiceActing role = list.elementAt(index);
            return RoleItem(role);
          },
        ),
      ),
    );
  }
}

class RoleItem extends StatelessWidget {
  RoleItem(this.role);

  final VoiceActing role;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                TitleAnime(
                  role.anime.malId,
                  role.anime.name,
                  role.anime.imageUrl!,
                  width: kImageWidthS,
                  height: kImageHeightS,
                  type: TopType.anime,
                  showTitle: false,
                ),
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
                TitleAnime(
                  role.character.malId,
                  '',
                  role.character.imageUrl!,
                  width: kImageWidthS,
                  height: kImageHeightS,
                  type: TopType.characters,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
