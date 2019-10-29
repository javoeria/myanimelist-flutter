import 'package:flutter/material.dart';
import 'package:jikan_dart/jikan_dart.dart';
import 'package:myanimelist/screens/anime_screen.dart';
import 'package:myanimelist/screens/character_screen.dart';
import 'package:myanimelist/screens/manga_screen.dart';
import 'package:myanimelist/screens/person_screen.dart';

class SubtitleAnime extends StatelessWidget {
  SubtitleAnime(this.id, this.title, this.subtitle, this.image, {this.type});

  final int id;
  final String title;
  final String subtitle;
  final String image;
  final TopType type;
  final double width = 108.0;
  final double height = 163.0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        Ink.image(
          image: NetworkImage(image),
          width: width,
          height: height,
          fit: BoxFit.cover,
          child: InkWell(
            onTap: () {
              switch (type) {
                case TopType.anime:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AnimeScreen(id, title),
                      settings: RouteSettings(name: 'AnimeScreen'),
                    ),
                  );
                  break;
                case TopType.manga:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MangaScreen(id, title),
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
        title != ''
            ? Stack(
                alignment: AlignmentDirectional.bottomCenter,
                children: <Widget>[
                  Image.asset('images/box_shadow.png', width: width, height: 40.0, fit: BoxFit.cover),
                  Container(
                    width: width,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            title,
                            maxLines: 2,
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
                          Text(
                            subtitle,
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white60,
                              fontSize: 10.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            : Container(),
      ],
    );
  }
}
