import 'package:flutter/material.dart';
import 'package:jikan_dart/jikan_dart.dart';
import 'package:myanimelist/screens/anime_screen.dart';
import 'package:myanimelist/screens/character_screen.dart';
import 'package:myanimelist/screens/manga_screen.dart';
import 'package:myanimelist/screens/person_screen.dart';

class RankImage extends StatelessWidget {
  RankImage(this.top, {this.type});

  final Top top;
  final TopType type;
  final double width = 108.0;
  final double height = 163.0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Ink.image(
          image: NetworkImage(top.imageUrl),
          width: width,
          height: height,
          fit: BoxFit.cover,
          child: InkWell(
            onTap: () {
              int id = top.malId;
              switch (type) {
                case TopType.anime:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AnimeScreen(id, top.title),
                      settings: RouteSettings(name: 'AnimeScreen'),
                    ),
                  );
                  break;
                case TopType.manga:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MangaScreen(id, top.title),
                      settings: RouteSettings(name: 'MangaScreen'),
                    ),
                  );
                  break;
                case TopType.people:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PersonScreen(id),
                      settings: RouteSettings(name: 'PersonScreen'),
                    ),
                  );
                  break;
                case TopType.characters:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CharacterScreen(id),
                      settings: RouteSettings(name: 'CharacterScreen'),
                    ),
                  );
                  break;
                default:
                  throw 'TopType Error';
              }
            },
          ),
        ),
        Container(
          height: height,
          width: width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  padding: const EdgeInsets.all(2.0),
                  color: Colors.black54,
                  child: Text('${top.rank}', style: TextStyle(color: Colors.white)),
                ),
              ),
              Stack(
                alignment: AlignmentDirectional.bottomCenter,
                children: <Widget>[
                  Image.asset('images/box_shadow.png', width: width, height: 40.0, fit: BoxFit.cover),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      top.title,
                      maxLines: 3,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.0,
                        shadows: <Shadow>[
                          Shadow(
                            offset: Offset(0.0, 0.0),
                            blurRadius: 3.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
