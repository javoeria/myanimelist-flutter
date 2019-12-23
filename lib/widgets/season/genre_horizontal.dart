import 'package:flutter/material.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:built_collection/built_collection.dart' show BuiltList;

class GenreHorizontal extends StatelessWidget {
  GenreHorizontal(this.genreList, {this.padding = 12.0});

  final BuiltList<GenericInfo> genreList;
  final double padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: padding),
        itemCount: genreList.length,
        itemBuilder: (context, index) {
          GenericInfo genre = genreList[index];
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: Chip(label: Text(genre.name)),
          );
        },
      ),
    );
  }
}
