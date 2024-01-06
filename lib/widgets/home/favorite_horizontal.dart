import 'package:flutter/material.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:myanimelist/constants.dart';
import 'package:myanimelist/widgets/title_anime.dart';

class FavoriteHorizontal extends StatelessWidget {
  const FavoriteHorizontal(this.favorites);

  final BuiltList<Favorite> favorites;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Divider(height: 0.0),
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 12.0),
          child: Text('My Favorite Anime & Manga', style: Theme.of(context).textTheme.titleMedium),
        ),
        SizedBox(
          height: kImageHeightL,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              Favorite fav = favorites.elementAt(index);
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: TitleAnime(
                  fav.malId,
                  fav.name,
                  fav.imageUrl,
                  type: fav.url.contains('/anime/') ? ItemType.anime : ItemType.manga,
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12.0),
      ],
    );
  }
}
