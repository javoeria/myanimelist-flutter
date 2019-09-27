import 'package:flutter/material.dart';
import 'package:jikan_dart/jikan_dart.dart';
import 'package:myanimelist/widgets/item_anime.dart';
import 'package:myanimelist/screens/seasonal_anime_screen.dart';

class SeasonHorizontal extends StatelessWidget {
  SeasonHorizontal(this.season);

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
              Text('${season.seasonName} ${season.seasonYear} Anime', style: Theme.of(context).textTheme.title),
              IconButton(
                icon: Icon(Icons.chevron_right),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SeasonalAnimeScreen(year: 2019, type: Fall())));
                },
              )
            ],
          ),
        ),
        Container(
          height: 220.0,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            itemCount: 20,
            itemBuilder: (context, index) {
              Anime anime = season.anime.elementAt(index);
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: ItemAnime(anime.malId, anime.title, anime.imageUrl),
              );
            },
          ),
        ),
      ],
    );
  }
}
