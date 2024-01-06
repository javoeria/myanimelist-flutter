import 'dart:math';

import 'package:flutter/material.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:myanimelist/constants.dart';
import 'package:myanimelist/screens/seasonal_anime_screen.dart';
import 'package:myanimelist/widgets/title_anime.dart';

class SeasonHorizontal extends StatelessWidget {
  const SeasonHorizontal(this.season);

  final BuiltList<Anime> season;

  @override
  Widget build(BuildContext context) {
    final String seasonName = season.first.season!.toTitleCase();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: kHomePadding,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('$seasonName ${season.first.year} Anime', style: Theme.of(context).textTheme.titleMedium),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                key: const Key('season_icon'),
                tooltip: 'View all',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SeasonalAnimeScreen(year: season.first.year!, season: seasonName),
                      settings: const RouteSettings(name: 'SeasonalAnimeScreen'),
                    ),
                  );
                },
              )
            ],
          ),
        ),
        SizedBox(
          height: kImageHeightL,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            itemCount: min(season.length, 20),
            itemBuilder: (context, index) {
              Anime anime = season.elementAt(index);
              return Padding(
                padding: const EdgeInsets.all(4.0),
                key: Key('anime_$index'),
                child: TitleAnime(
                  anime.malId,
                  anime.title,
                  anime.imageUrl,
                  type: ItemType.anime,
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
