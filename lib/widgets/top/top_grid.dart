import 'package:flutter/material.dart';
import 'package:jikan_dart/jikan_dart.dart';
import 'package:built_collection/built_collection.dart' show BuiltList;
import 'package:myanimelist/widgets/top/rank_image.dart';

class TopGrid extends StatelessWidget {
  TopGrid(this.topList, {this.type});

  final BuiltList<Top> topList;
  final TopType type;

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Center(
          child: Wrap(
            spacing: 16.0,
            runSpacing: 16.0,
            children: topList.map((Top top) {
              return RankImage(top, type: type);
            }).toList(),
          ),
        ),
      ),
    );
  }
}
