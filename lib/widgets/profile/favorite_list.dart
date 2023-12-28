import 'package:flutter/material.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:myanimelist/constants.dart';
import 'package:myanimelist/widgets/title_anime.dart';

class FavoriteList extends StatelessWidget {
  const FavoriteList(this.favorites);

  final Favorites favorites;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Divider(height: 0.0),
        Padding(
          padding: kTitlePadding,
          child: Text('Favorites', style: Theme.of(context).textTheme.titleMedium),
        ),
        favorites.anime.isNotEmpty ? FavoriteSection(favorites.anime, type: ItemType.anime) : Container(),
        favorites.manga.isNotEmpty ? FavoriteSection(favorites.manga, type: ItemType.manga) : Container(),
        favorites.characters.isNotEmpty
            ? FavoriteSection(favorites.characters, type: ItemType.characters)
            : Container(),
        favorites.people.isNotEmpty ? FavoriteSection(favorites.people, type: ItemType.people) : Container(),
        SizedBox(height: 12.0),
      ],
    );
  }
}

class FavoriteSection extends StatelessWidget {
  const FavoriteSection(this.list, {required this.type});

  final BuiltList<Favorite> list;
  final ItemType type;
  final double width = kImageWidthM;
  final double height = kImageHeightM;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          child: Text(type.name.toTitleCase(), style: Theme.of(context).textTheme.bodyLarge),
        ),
        SizedBox(
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
