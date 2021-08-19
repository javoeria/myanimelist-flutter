import 'package:flutter/material.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:myanimelist/jikan_v4.dart';
import 'package:myanimelist/widgets/manga/manga_list.dart';
import 'package:myanimelist/widgets/season/season_list.dart';

class ProducerScreen extends StatelessWidget {
  ProducerScreen({this.anime = true});

  final bool anime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(anime ? 'Anime Studios / Producers' : 'Manga Magazines'),
      ),
      body: Scrollbar(
        child: PagewiseListView(
          pageSize: anime ? 100 : 25,
          itemBuilder: _itemBuilder,
          noItemsFoundBuilder: (context) {
            return ListTile(title: Text('No items found.'));
          },
          pageFuture: (pageIndex) => JikanV4().getProducerList(anime: anime, page: pageIndex! + 1),
        ),
      ),
    );
  }

  Widget _itemBuilder(BuildContext context, Map<String, dynamic> producer, int index) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(producer['name']),
          trailing: Chip(label: Text(producer['count'].toString())),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => anime
                    ? ProducerList(producer['mal_id'], producer['name'])
                    : MagazineList(producer['mal_id'], producer['name']),
                settings: RouteSettings(name: '${producer['name']}Screen'),
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
  ProducerList(this.id, this.name);

  final int id;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: FutureBuilder(
        future: Jikan().getProducerInfo(id),
        builder: (context, AsyncSnapshot<Producer> snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Center(child: CircularProgressIndicator());
          }

          Producer producer = snapshot.data!;
          return SeasonList(producer.anime);
        },
      ),
    );
  }
}

class MagazineList extends StatelessWidget {
  MagazineList(this.id, this.name);

  final int id;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: FutureBuilder(
        future: Jikan().getMagazineInfo(id),
        builder: (context, AsyncSnapshot<Magazine> snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Center(child: CircularProgressIndicator());
          }

          Magazine magazine = snapshot.data!;
          return MangaList(magazine.manga);
        },
      ),
    );
  }
}
