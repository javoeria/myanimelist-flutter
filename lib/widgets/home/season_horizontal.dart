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
    String seasonName = season.first.season![0].toUpperCase() + season.first.season!.substring(1);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('$seasonName ${season.first.year} Anime', style: Theme.of(context).textTheme.headline6),
              IconButton(
                icon: Icon(Icons.chevron_right),
                key: Key('season_icon'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SeasonalAnimeScreen(year: season.first.year!, type: seasonName),
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
        SizedBox(height: 12.0),
      ],
    );
  }
}
