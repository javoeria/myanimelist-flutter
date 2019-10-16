import 'package:flutter/material.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:jikan_dart/jikan_dart.dart';
import 'package:intl/intl.dart' show NumberFormat;
import 'package:myanimelist/models/user_data.dart';
import 'package:myanimelist/screens/person_screen.dart';
import 'package:myanimelist/widgets/top/custom_view.dart';
import 'package:myanimelist/widgets/top/rank_image.dart';
import 'package:provider/provider.dart';

const int PAGE_SIZE = 50;

class TopPeopleScreen extends StatelessWidget {
  final JikanApi jikanApi = JikanApi();
  final TopType type = TopType.people;
  final NumberFormat f = NumberFormat.decimalPattern();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Top People'),
        actions: <Widget>[CustomView()],
      ),
      body: Scrollbar(
        child: Provider.of<UserData>(context).gridView
            ? PagewiseGridView.extent(
                pageSize: PAGE_SIZE,
                maxCrossAxisExtent: 108.0,
                mainAxisSpacing: 16.0,
                crossAxisSpacing: 16.0,
                childAspectRatio: 108.0 / 163.0,
                padding: const EdgeInsets.all(16.0),
                itemBuilder: (context, top, _) => RankImage(top, type: type),
                pageFuture: (pageIndex) => jikanApi.getTop(type, page: pageIndex + 1),
              )
            : PagewiseListView(
                pageSize: PAGE_SIZE,
                itemBuilder: this._itemBuilder,
                padding: const EdgeInsets.all(12.0),
                pageFuture: (pageIndex) => jikanApi.getTop(type, page: pageIndex + 1),
              ),
      ),
    );
  }

  Widget _itemBuilder(BuildContext context, Top top, int index) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => PersonScreen(top.malId)));
      },
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  Image.network(top.imageUrl, width: 50.0, height: 70.0, fit: BoxFit.cover),
                  SizedBox(width: 8.0),
                  Expanded(
                    child: Text('${top.rank}. ' + top.title, style: Theme.of(context).textTheme.subtitle),
                  ),
                  Row(
                    children: <Widget>[
                      Text(f.format(top.favorites), style: Theme.of(context).textTheme.subhead),
                      Icon(Icons.person, color: Colors.grey),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
