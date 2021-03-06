import 'dart:math';

import 'package:flutter/material.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:built_collection/built_collection.dart' show BuiltList;
import 'package:myanimelist/constants.dart';
import 'package:myanimelist/screens/top_anime_screen.dart';
import 'package:myanimelist/widgets/title_anime.dart';

class TopHorizontal extends StatelessWidget {
  TopHorizontal(this.top, {this.label});

  final BuiltList<Top> top;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Divider(height: 0.0),
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Top $label Anime', style: Theme.of(context).textTheme.headline6),
              IconButton(
                icon: Icon(Icons.chevron_right),
                key: Key('${label.toLowerCase()}_icon'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TopAnimeScreen(index: label == 'Airing' ? 1 : 2),
                      settings: RouteSettings(name: 'TopAnimeScreen'),
                    ),
                  );
                },
              )
            ],
          ),
        ),
        Container(
          height: kImageHeightL,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            itemCount: min(top.length, 20),
            itemBuilder: (context, index) {
              Top anime = top.elementAt(index);
              return Padding(
                padding: const EdgeInsets.all(4.0),
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
