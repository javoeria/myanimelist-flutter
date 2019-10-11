import 'package:flutter/material.dart';
import 'package:jikan_dart/jikan_dart.dart';
import 'package:built_collection/built_collection.dart' show BuiltList;
import 'package:myanimelist/widgets/item_anime.dart';

class FavoriteList extends StatelessWidget {
  FavoriteList(this.favorites);

  final Favorites favorites;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text('Favorites', style: Theme.of(context).textTheme.title),
        ),
        favorites.anime.length > 0 ? FavoriteSection(favorites.anime, type: TopType.anime) : Container(),
        favorites.manga.length > 0 ? FavoriteSection(favorites.manga, type: TopType.manga) : Container(),
        favorites.characters.length > 0 ? FavoriteSection(favorites.characters, type: TopType.characters) : Container(),
        favorites.people.length > 0 ? FavoriteSection(favorites.people, type: TopType.people) : Container(),
        Divider(),
      ],
    );
  }
}

class FavoriteSection extends StatelessWidget {
  FavoriteSection(this.list, {this.type});

  final BuiltList<FavoriteItem> list;
  final TopType type;
  final double width = 108.0;
  final double height = 163.0;

  String favoriteTitle() {
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
          child: Text(favoriteTitle(), style: Theme.of(context).textTheme.subhead),
        ),
        Container(
          height: height,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            itemCount: list.length,
            itemBuilder: (context, index) {
              FavoriteItem fav = list.elementAt(index);
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: ItemAnime(fav.malId, fav.name, fav.imageUrl, width: width, height: height, type: type),
              );
            },
          ),
        ),
      ],
    );
  }
}
