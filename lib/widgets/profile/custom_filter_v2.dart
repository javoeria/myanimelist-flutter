import 'package:flutter/material.dart';
import 'package:myanimelist/screens/anime_list_screen.dart';
import 'package:myanimelist/screens/manga_list_screen.dart';

class CustomFilterV2 extends StatelessWidget {
  const CustomFilterV2(this.username, {this.anime = true});

  final String username;
  final bool anime;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: Icon(Icons.filter_list),
      itemBuilder: (context) {
        return [
          PopupMenuItem(value: anime ? 'anime_title' : 'manga_title', child: Text('Title')),
          PopupMenuItem(value: 'list_score', child: Text('Score')),
          PopupMenuItem(value: anime ? 'anime_start_date' : 'manga_start_date', child: Text('Start Date')),
          PopupMenuItem(value: 'list_updated_at', child: Text('Last Updated')),
        ];
      },
      onSelected: (String value) {
        if (anime) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => AnimeListScreen(username, sort: value),
              settings: RouteSettings(name: 'AnimeListScreen'),
            ),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MangaListScreen(username, sort: value),
              settings: RouteSettings(name: 'MangaListScreen'),
            ),
          );
        }
      },
    );
  }
}
