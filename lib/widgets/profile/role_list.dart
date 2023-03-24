import 'package:flutter/material.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:myanimelist/constants.dart';
import 'package:myanimelist/widgets/title_anime.dart';

class RoleList extends StatelessWidget {
  const RoleList(this.list);

  final BuiltList<VoiceActor> list;

  @override
  Widget build(BuildContext context) {
    BuiltList<VoiceActor> shortList = list.length > 50 ? BuiltList(list.where((a) => a.role == 'Main').take(50)) : list;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Divider(height: 0.0),
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Voice Acting Roles', style: Theme.of(context).textTheme.titleMedium),
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
          children: shortList.map((VoiceActor role) {
            return RoleItem(role);
          }).toList(),
        ),
        SizedBox(height: 12.0),
      ],
    );
  }
}

class FullRoleList extends StatelessWidget {
  const FullRoleList(this.list);

  final BuiltList<VoiceActor> list;

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
            VoiceActor role = list.elementAt(index);
            return RoleItem(role);
          },
        ),
      ),
    );
  }
}

class RoleItem extends StatelessWidget {
  const RoleItem(this.role);

  final VoiceActor role;

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
                  role.anime.title,
                  role.anime.imageUrl,
                  width: kImageWidthS,
                  height: kImageHeightS,
                  type: ItemType.anime,
                  showTitle: false,
                ),
                SizedBox(width: 8.0),
                Expanded(child: Text(role.anime.title)),
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
                      Text(role.role, style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                ),
                SizedBox(width: 8.0),
                TitleAnime(
                  role.character.malId,
                  '',
                  role.character.imageUrl,
                  width: kImageWidthS,
                  height: kImageHeightS,
                  type: ItemType.characters,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
