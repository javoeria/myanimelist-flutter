import 'package:flutter/material.dart';
import 'package:jikan_dart/jikan_dart.dart';
import 'package:built_collection/built_collection.dart' show BuiltList;
import 'package:myanimelist/widgets/item_anime.dart';

class TopGrid extends StatelessWidget {
  TopGrid(this.topList);

  final BuiltList<Top> topList;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Center(
        child: Wrap(
          spacing: 16.0,
          runSpacing: 16.0,
          children: topList.map((top) {
            return ItemAnime(top.malId, top.title, top.imageUrl, width: 108.0, height: 163.0);
          }).toList(),
        ),
      ),
    );
  }
}
