import 'package:flutter/material.dart';
import 'package:jikan_dart/jikan_dart.dart';
import 'package:myanimelist/screens/anime_screen.dart';
import 'package:myanimelist/screens/character_screen.dart';
import 'package:myanimelist/screens/manga_screen.dart';
import 'package:myanimelist/screens/person_screen.dart';

class ItemAnime extends StatelessWidget {
  ItemAnime(this.id, this.title, this.image, {this.width = 160.0, this.height = 220.0, this.type});

  final int id;
  final String title;
  final String image;
  final double width;
  final double height;
  final TopType type;

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
              print(type.toString() + ' - $id');
              switch (type) {
                case TopType.anime:
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AnimeScreen(id, title)));
                  break;
                case TopType.manga:
                  Navigator.push(context, MaterialPageRoute(builder: (context) => MangaScreen(id, title)));
                  break;
                case TopType.people:
                  Navigator.push(context, MaterialPageRoute(builder: (context) => PersonScreen(id)));
                  break;
                case TopType.characters:
                  Navigator.push(context, MaterialPageRoute(builder: (context) => CharacterScreen(id)));
                  break;
                default:
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
                      child: Text(
                        title,
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
                  ),
                ],
              )
            : Container(),
      ],
    );
  }
}
