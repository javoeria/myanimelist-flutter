import 'dart:math';

import 'package:flutter/material.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:myanimelist/constants.dart';
import 'package:myanimelist/screens/anime_screen.dart';
import 'package:myanimelist/screens/watch_screen.dart';
import 'package:myanimelist/widgets/anime/anime_videos.dart';

class WatchHorizontal extends StatelessWidget {
  const WatchHorizontal(this.trailers);

  final BuiltList<WatchPromo> trailers;

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
              Text('Latest Anime Trailers', style: Theme.of(context).textTheme.titleMedium),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                key: const Key('trailers_icon'),
                tooltip: 'View all',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WatchScreen(episodes: false),
                      settings: const RouteSettings(name: 'PromotionalVideosScreen'),
                    ),
                  );
                },
              )
            ],
          ),
        ),
        SizedBox(
          height: 152.0,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            itemCount: min(trailers.length, 20),
            itemBuilder: (context, index) {
              WatchPromo promo = trailers.elementAt(index);
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    LandscapeVideo(promo),
                    const SizedBox(height: 4.0),
                    SizedBox(
                      width: 220.0,
                      child: InkWell(
                        child: Text(promo.entry.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AnimeScreen(promo.entry.malId, promo.entry.title),
                              settings: const RouteSettings(name: 'AnimeScreen'),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8.0),
      ],
    );
  }
}
