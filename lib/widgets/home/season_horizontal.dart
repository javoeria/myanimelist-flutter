import 'dart:math';

import 'package:flutter/material.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:myanimelist/constants.dart';
import 'package:myanimelist/screens/seasonal_anime_screen.dart';
import 'package:myanimelist/widgets/title_anime.dart';

class SeasonHorizontal extends StatelessWidget {
  const SeasonHorizontal(this.season);

  final Season season;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('${season.seasonName} ${season.seasonYear} Anime', style: Theme.of(context).textTheme.headline6),
              IconButton(
                icon: Icon(Icons.chevron_right),
                key: Key('season_icon'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SeasonalAnimeScreen(year: season.seasonYear!, type: season.seasonName),
                      settings: RouteSettings(name: 'SeasonalAnimeScreen'),
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
            itemCount: min(season.anime.length, 20),
            itemBuilder: (context, index) {
              AnimeItem anime = season.anime.elementAt(index);
              return Padding(
                padding: const EdgeInsets.all(4.0),
                key: Key('anime_$index'),
                child: TitleAnime(
                  anime.malId,
                  anime.title,
                  anime.imageUrl,
                  type: TopType.anime,
                ),
              );
            },
          ),
        ),
        SizedBox(height: 12.0),
      ],
    );
  }
}
