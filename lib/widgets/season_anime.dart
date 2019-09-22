import 'package:flutter/material.dart';
import 'package:jikan_dart/jikan_dart.dart';
import 'package:myanimelist/widgets/item_anime.dart';

class SeasonAnime extends StatelessWidget {
  SeasonAnime(this.season);

  final Season season;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('${season.seasonName} ${season.seasonYear} Anime', style: Theme.of(context).textTheme.title),
              IconButton(
                icon: Icon(Icons.chevron_right),
                onPressed: () {},
              )
            ],
          ),
        ),
        Container(
          height: 220.0,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 20,
            itemBuilder: (context, index) {
              Anime anime = season.anime.elementAt(index);
              return Padding(
                padding: index < 19 ? EdgeInsets.only(top: 8.0, bottom: 8.0, left: 8.0) : EdgeInsets.all(8.0),
                child: ItemAnime(anime.malId, anime.title, anime.imageUrl),
              );
            },
          ),
        ),
      ],
    );
  }
}
