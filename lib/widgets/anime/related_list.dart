import 'package:flutter/material.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:myanimelist/constants.dart';
import 'package:myanimelist/widgets/subtitle_anime.dart';

class RelatedList extends StatelessWidget {
  RelatedList(this.list, {this.anime = true});

  final List<dynamic> list;
  final bool anime;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Divider(height: 0.0),
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 12.0),
          child: Text(
            anime ? 'Related Anime' : 'Related Manga',
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        Container(
          height: kContainerHeight,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            itemCount: list.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> item = list.elementAt(index);
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: SubtitleAnime(
                  item['node']['id'],
                  item['node']['title'],
                  item['relation_type_formatted'],
                  item['node']['main_picture']['large'],
                  type: anime ? TopType.anime : TopType.manga,
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
