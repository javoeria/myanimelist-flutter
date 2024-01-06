import 'dart:math';

import 'package:flutter/material.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:myanimelist/constants.dart';
import 'package:myanimelist/screens/anime_screen.dart';
import 'package:myanimelist/screens/manga_screen.dart';

class UserUpdateList extends StatelessWidget {
  const UserUpdateList(this.updates);

  final BuiltList<EntryUpdate> updates;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Divider(height: 0.0),
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 12.0),
          child: Text('My Last List Updates', style: Theme.of(context).textTheme.titleMedium),
        ),
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          shrinkWrap: true,
          itemCount: min(updates.length, 5),
          itemBuilder: (context, index) {
            EntryUpdate item = updates.elementAt(index);
            String progress = item.episodesSeen == null && item.chaptersRead == null
                ? ''
                : 'at ${item.episodesSeen ?? item.chaptersRead} of ${item.episodesTotal ?? item.chaptersTotal ?? '?'}';
            String score = item.score == 0 ? '-' : item.score.toString();
            return InkWell(
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  children: <Widget>[
                    Container(
                        color: statusColor(item.status.replaceAll('-', ' ').trim()), width: 6.0, height: kImageHeightS),
                    Image.network(item.entry.imageUrl, width: kImageWidthS, height: kImageHeightS, fit: BoxFit.cover),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Text>[
                          Text(item.entry.title),
                          Text('${item.status} $progress', style: Theme.of(context).textTheme.bodySmall),
                          Text(
                            item.date.formatDate(pattern: 'MMM d, yyyy h:mm a'),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    Text(score, style: Theme.of(context).textTheme.bodyLarge),
                  ],
                ),
              ),
              onTap: () {
                if (item.entry.url.contains('/anime/')) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          AnimeScreen(item.entry.malId, item.entry.title, episodes: item.episodesTotal),
                      settings: const RouteSettings(name: 'AnimeScreen'),
                    ),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MangaScreen(item.entry.malId, item.entry.title),
                      settings: const RouteSettings(name: 'MangaScreen'),
                    ),
                  );
                }
              },
            );
          },
        ),
        const SizedBox(height: 12.0),
      ],
    );
  }
}
