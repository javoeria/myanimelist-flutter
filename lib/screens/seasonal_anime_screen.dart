import 'package:flutter/material.dart';
import 'package:jikan_dart/jikan_dart.dart';
import 'package:built_collection/built_collection.dart' show BuiltList;
import 'package:myanimelist/widgets/custom_menu.dart';
import 'package:myanimelist/widgets/season_info.dart';

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
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ListView.separated(
      separatorBuilder: (context, index) => Divider(),
      itemCount: widget.animeList.length,
      itemBuilder: (context, index) {
        Anime anime = widget.animeList.elementAt(index);
        return SeasonInfo(anime);
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
