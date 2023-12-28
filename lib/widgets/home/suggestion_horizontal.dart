import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:myanimelist/constants.dart';
import 'package:myanimelist/widgets/title_anime.dart';

class SuggestionHorizontal extends StatelessWidget {
  const SuggestionHorizontal(this.suggestions);

  final List<dynamic> suggestions;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Divider(height: 0.0),
        Padding(
          padding: kHomePadding,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('My Anime Suggestions', style: Theme.of(context).textTheme.titleMedium),
              IconButton(
                icon: Icon(Icons.help_outline),
                onPressed: (() => Fluttertoast.showToast(
                    msg: "These suggestions are generated based on MAL's Anime and Manga rankings.")),
              )
            ],
          ),
        ),
        SizedBox(
          height: kImageHeightL,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            itemCount: suggestions.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> item = suggestions.elementAt(index);
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: TitleAnime(
                  item['node']['id'],
                  item['node']['title'],
                  item['node']['main_picture']['large'],
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
