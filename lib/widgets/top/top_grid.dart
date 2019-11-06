import 'package:flutter/material.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:myanimelist/widgets/top/rank_image.dart';

class TopGrid extends StatefulWidget {
  TopGrid({@required this.type, this.subtype});

  final TopType type;
  final TopSubtype subtype;

  @override
  _TopGridState createState() => _TopGridState();
}

class _TopGridState extends State<TopGrid> with AutomaticKeepAliveClientMixin<TopGrid> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scrollbar(
      child: PagewiseGridView.extent(
        pageSize: 50,
        maxCrossAxisExtent: 108.0,
        mainAxisSpacing: 16.0,
        crossAxisSpacing: 16.0,
        childAspectRatio: 108.0 / 163.0,
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, top, _) => RankImage(top, type: widget.type),
        pageFuture: (pageIndex) => Jikan().getTop(widget.type, subtype: widget.subtype, page: pageIndex + 1),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
