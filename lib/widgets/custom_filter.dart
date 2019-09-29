import 'package:flutter/material.dart';
import 'package:myanimelist/screens/anime_list_screen.dart';
import 'package:myanimelist/screens/manga_list_screen.dart';

class CustomFilter extends StatelessWidget {
  CustomFilter(this.type);

  final String type;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: Icon(Icons.filter_list),
      itemBuilder: (context) {
        return [
          PopupMenuItem(child: Text('Title'), value: 'title'),
          PopupMenuItem(child: Text('Score'), value: 'score'),
          PopupMenuItem(child: Text('Type'), value: 'type'),
          PopupMenuItem(child: Text('Progress'), value: 'progress'),
        ];
      },
      onSelected: (value) {
        if (type == 'anime') {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AnimeListScreen(order: value)));
        } else {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MangaListScreen(order: value)));
        }
      },
    );
  }
}
