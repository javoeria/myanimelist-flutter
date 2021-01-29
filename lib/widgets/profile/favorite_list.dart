import 'package:flutter/material.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:built_collection/built_collection.dart' show BuiltList;
import 'package:myanimelist/constants.dart';
import 'package:myanimelist/widgets/title_anime.dart';

class FavoriteList extends StatelessWidget {
  FavoriteList(this.favorites);

  final Favorites favorites;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Divider(height: 0.0),
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 8.0),
          child: Text('Favorites', style: Theme.of(context).textTheme.headline6),
        ),
        favorites.anime.isNotEmpty ? FavoriteSection(favorites.anime, type: TopType.anime) : Container(),
        favorites.manga.isNotEmpty ? FavoriteSection(favorites.manga, type: TopType.manga) : Container(),
        favorites.characters.isNotEmpty ? FavoriteSection(favorites.characters, type: TopType.characters) : Container(),
        favorites.people.isNotEmpty ? FavoriteSection(favorites.people, type: TopType.people) : Container(),
        SizedBox(height: 12.0),
      ],
    );
  }
}

class FavoriteSection extends StatelessWidget {
  FavoriteSection(this.list, {this.type});

  final BuiltList<Favorite> list;
  final TopType type;
  final double width = kImageWidthM;
  final double height = kImageHeightM;

  String get _favoriteTitle {
    switch (type) {
      case TopType.anime:
        return 'Anime';
        break;
      case TopType.manga:
        return 'Manga';
        break;
      case TopType.people:
        return 'People';
        break;
      case TopType.characters:
        return 'Characters';
        break;
      default:
        throw 'TopType Error';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(_favoriteTitle, style: Theme.of(context).textTheme.subtitle1),
        ),
        Container(
          height: height,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            itemCount: list.length,
            itemBuilder: (context, index) {
              Favorite fav = list.elementAt(index);
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: TitleAnime(
                  fav.malId,
                  fav.name,
                  fav.imageUrl,
                  width: width,
                  height: height,
                  type: type,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
