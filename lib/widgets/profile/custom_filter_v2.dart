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
          PopupMenuItem(child: Text('Title'), value: anime ? 'anime_title' : 'manga_title'),
          PopupMenuItem(child: Text('Score'), value: 'list_score'),
          PopupMenuItem(child: Text('Start Date'), value: anime ? 'anime_start_date' : 'manga_start_date'),
          PopupMenuItem(child: Text('Last Updated'), value: 'list_updated_at'),
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
