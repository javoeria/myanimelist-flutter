import 'dart:math';

import 'package:flutter/material.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:myanimelist/constants.dart';
import 'package:myanimelist/screens/top_anime_screen.dart';
import 'package:myanimelist/widgets/title_anime.dart';

class TopHorizontal extends StatelessWidget {
  const TopHorizontal(this.top, {required this.label});

  final BuiltList<Anime> top;
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
              Text('Top $label Anime', style: Theme.of(context).textTheme.titleMedium),
              IconButton(
                icon: Icon(Icons.chevron_right),
                key: Key('${label.toLowerCase()}_icon'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TopAnimeScreen(index: label == 'Airing' ? 1 : 2),
                      settings: const RouteSettings(name: 'TopAnimeScreen'),
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
            itemCount: min(top.length, 20),
            itemBuilder: (context, index) {
              Anime anime = top.elementAt(index);
              return Padding(
                padding: const EdgeInsets.all(4.0),
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
