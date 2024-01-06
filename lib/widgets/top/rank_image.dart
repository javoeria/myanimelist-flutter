import 'package:flutter/material.dart';
import 'package:myanimelist/constants.dart';
import 'package:myanimelist/screens/anime_screen.dart';
import 'package:myanimelist/screens/character_screen.dart';
import 'package:myanimelist/screens/manga_screen.dart';
import 'package:myanimelist/screens/person_screen.dart';

class RankImage extends StatelessWidget {
  const RankImage(this.top, this.index, {required this.type});

  final dynamic top;
  final int index;
  final ItemType type;
  final double width = kImageWidthM;
  final double height = kImageHeightM;

  @override
  Widget build(BuildContext context) {
    return Ink.image(
      image: NetworkImage(top.imageUrl),
      width: width,
      height: height,
      fit: BoxFit.cover,
      child: InkWell(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                padding: const EdgeInsets.all(2.0),
                color: Colors.black54,
                child: Text('${index + 1}', style: const TextStyle(color: Colors.white)),
              ),
            ),
            Stack(
              alignment: AlignmentDirectional.bottomCenter,
              children: <Widget>[
                Image.asset('images/box_shadow.png', width: width, height: 40.0, fit: BoxFit.cover),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    type == ItemType.anime || type == ItemType.manga ? top.title : top.name,
                    maxLines: 3,
                    textAlign: TextAlign.center,
                    style: kTextStyleShadow,
                  ),
                ),
              ],
            ),
          ],
        ),
        onTap: () {
          final int id = top.malId;
          switch (type) {
            case ItemType.anime:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AnimeScreen(id, top.title, episodes: top.episodes),
                  settings: const RouteSettings(name: 'AnimeScreen'),
                ),
              );
              break;
            case ItemType.manga:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MangaScreen(id, top.title),
                  settings: const RouteSettings(name: 'MangaScreen'),
                ),
              );
              break;
            case ItemType.people:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PersonScreen(id),
                  settings: const RouteSettings(name: 'PersonScreen'),
                ),
              );
              break;
            case ItemType.characters:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CharacterScreen(id),
                  settings: const RouteSettings(name: 'CharacterScreen'),
                ),
              );
              break;
            default:
              throw 'ItemType Error';
          }
        },
      ),
    );
  }
}
