import 'package:flutter/material.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:myanimelist/constants.dart';
import 'package:myanimelist/widgets/manga/manga_list.dart';
import 'package:myanimelist/widgets/season/season_list.dart';

class ProducerScreen extends StatelessWidget {
  const ProducerScreen({this.anime = true});

  final bool anime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(anime ? 'Anime Studios' : 'Manga Magazines'),
      ),
      body: Scrollbar(
        child: PagewiseListView(
          pageSize: kDefaultPageSize,
          itemBuilder: _itemBuilder,
          noItemsFoundBuilder: (context) {
            return ListTile(title: Text('No items found.'));
          },
          pageFuture: (pageIndex) => anime
              ? Jikan().getProducers(orderBy: 'count', sort: 'desc', page: pageIndex! + 1)
              : Jikan().getMagazines(orderBy: 'count', sort: 'desc', page: pageIndex! + 1),
        ),
      ),
    );
  }

  Widget _itemBuilder(BuildContext context, dynamic producer, int index) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(producer.name),
          trailing: Chip(label: Text(producer.count.toString())),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    anime ? ProducerList(producer.malId, producer.name) : MagazineList(producer.malId, producer.name),
                settings: RouteSettings(name: '${producer.name}Screen'),
              ),
            );
          },
        ),
        Divider(height: 0.0),
      ],
    );
  }
}

class ProducerList extends StatelessWidget {
  const ProducerList(this.id, this.name);

  final int id;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: FutureBuilder(
        future: Jikan().searchAnime(producers: [id], orderBy: 'members', sort: 'desc'),
        builder: (context, AsyncSnapshot<BuiltList<Anime>> snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Center(child: CircularProgressIndicator());
          }

          return SeasonList(snapshot.data!);
        },
      ),
    );
  }
}

class MagazineList extends StatelessWidget {
  const MagazineList(this.id, this.name);

  final int id;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: FutureBuilder(
        future: Jikan().searchManga(magazines: [id], orderBy: 'members', sort: 'desc'),
        builder: (context, AsyncSnapshot<BuiltList<Manga>> snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Center(child: CircularProgressIndicator());
          }

          return MangaList(snapshot.data!);
        },
      ),
    );
  }
}
