import 'package:flutter/material.dart';
import 'package:jikan_dart/jikan_dart.dart';
import 'package:built_collection/built_collection.dart' show BuiltList;
import 'package:myanimelist/widgets/item_anime.dart';
import 'package:myanimelist/screens/top_anime_screen.dart';

class TopAnime extends StatelessWidget {
  TopAnime(this.top, {this.label});

  final BuiltList<Top> top;
  final String label;

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
              Text('Top $label Anime', style: Theme.of(context).textTheme.title),
              IconButton(
                icon: Icon(Icons.chevron_right),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => TopAnimeScreen(index: label == 'Airing' ? 1 : 2)));
                },
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
              Top anime = top.elementAt(index);
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
