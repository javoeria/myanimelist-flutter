import 'package:flutter/material.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
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
      child: GridView.extent(
        maxCrossAxisExtent: 108.0,
        mainAxisSpacing: 16.0,
        crossAxisSpacing: 16.0,
        childAspectRatio: 108.0 / 163.0,
        padding: const EdgeInsets.all(16.0),
        children: topList.map((Top top) {
          return RankImage(top, type: type);
        }).toList(),
      ),
    );
  }
}
