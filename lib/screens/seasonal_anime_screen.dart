import 'package:flutter/material.dart';
import 'package:jikan_dart/jikan_dart.dart';
import 'package:built_collection/built_collection.dart' show BuiltList;
import 'package:intl/intl.dart' show NumberFormat, DateFormat;
import 'package:myanimelist/widgets/custom_menu.dart';

final NumberFormat f = NumberFormat.decimalPattern();
final DateFormat dateFormat = DateFormat('MMM d, yyyy, HH:mm');

class SeasonalAnimeScreen extends StatelessWidget {
  SeasonalAnimeScreen({this.year, this.type});

  final int year;
  final SeasonType type;

  @override
  Widget build(BuildContext context) {
    String typeString = type.toString();
    return DefaultTabController(
      length: 5,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          title: Text(typeString[0].toUpperCase() + typeString.substring(1) + ' ' + year.toString()),
          bottom: TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'TV'),
              Tab(text: 'ONA'),
              Tab(text: 'OVA'),
              Tab(text: 'Movie'),
              Tab(text: 'Special'),
            ],
          ),
          actions: <Widget>[
            CustomMenu(),
          ],
        ),
        body: FutureBuilder(
          future: JikanApi().getSeason(year, type),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return Center(child: CircularProgressIndicator());
            }

            BuiltList<Anime> animeList = snapshot.data.anime;
            BuiltList<Anime> tv = BuiltList.from(animeList.where((anime) => anime.type == 'TV'));
            BuiltList<Anime> ona = BuiltList.from(animeList.where((anime) => anime.type == 'ONA'));
            BuiltList<Anime> ova = BuiltList.from(animeList.where((anime) => anime.type == 'OVA'));
            BuiltList<Anime> movie = BuiltList.from(animeList.where((anime) => anime.type == 'Movie'));
            BuiltList<Anime> special = BuiltList.from(animeList.where((anime) => anime.type == 'Special'));
            return TabBarView(
              children: [
                SeasonList(tv),
                SeasonList(ona),
                SeasonList(ova),
                SeasonList(movie),
                SeasonList(special),
              ],
            );
          },
        ),
      ),
    );
  }
}

class SeasonList extends StatefulWidget {
  SeasonList(this.animeList);

  final BuiltList<Anime> animeList;

  @override
  _SeasonListState createState() => _SeasonListState();
}

class _SeasonListState extends State<SeasonList> with AutomaticKeepAliveClientMixin<SeasonList> {
  String producersText(BuiltList<Producer> producers) {
    if (producers.length == 0) {
      return '-';
    } else {
      List<String> names = [];
      for (Producer p in producers) {
        names.add(p.name);
      }
      return names.join(', ');
    }
  }

  String airingText(String date) {
    if (date == null) {
      return '??';
    } else {
      DateTime dateTime = DateTime.parse(date).add(Duration(hours: 9));
      return dateFormat.format(dateTime) + ' (JST)';
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ListView.separated(
      separatorBuilder: (context, index) => Divider(),
      itemCount: widget.animeList.length,
      itemBuilder: (context, index) {
        Anime anime = widget.animeList.elementAt(index);
        String episodes = anime.episodes == null ? '?' : anime.episodes.toString();
        String score = anime.score == null ? 'N/A' : anime.score.toString();
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Text(anime.title, style: Theme.of(context).textTheme.title),
              SizedBox(height: 4.0),
              Text(producersText(anime.producers) + ' | $episodes eps | ' + anime.source, style: Theme.of(context).textTheme.body1),
              Wrap(
                children: anime.genres.map((genre) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2.0),
                    child: Chip(label: Text(genre.name, style: Theme.of(context).textTheme.overline)),
                  );
                }).toList(),
              ),
              Container(
                height: 242.0,
                child: Row(
                  children: <Widget>[
                    Image.network(anime.imageUrl, height: 242.0, width: 167.0, fit: BoxFit.cover),
                    SizedBox(width: 8.0),
                    Expanded(
                      child: Container(
                        alignment: Alignment.topLeft,
                        child: SingleChildScrollView(
                          child: Text(anime.synopsis, style: Theme.of(context).textTheme.caption),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(anime.type + ' - ' + airingText(anime.airingStart), style: Theme.of(context).textTheme.body1),
                  Row(
                    children: <Widget>[
                      Icon(Icons.star_border, color: Colors.grey, size: 20.0),
                      Text(score, style: Theme.of(context).textTheme.body1),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Icon(Icons.person_outline, color: Colors.grey, size: 20.0),
                      Text(f.format(anime.members), style: Theme.of(context).textTheme.body1),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
