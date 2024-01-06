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

  int get _labelIndex {
    switch (label) {
      case 'Top Airing':
        return 1;
      case 'Top Upcoming':
        return 2;
      case 'Most Popular':
        return 8;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Divider(height: 0.0),
        Padding(
          padding: kHomePadding,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('$label Anime', style: Theme.of(context).textTheme.titleMedium),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                key: Key('${label.split(' ').last.toLowerCase()}_icon'),
                tooltip: 'View all',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TopAnimeScreen(index: _labelIndex),
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
        const SizedBox(height: 12.0),
      ],
    );
  }
}
