import 'package:flutter/material.dart';
import 'package:jikan_dart/jikan_dart.dart';
import 'package:built_collection/built_collection.dart' show BuiltList;
import 'package:myanimelist/widgets/item_anime.dart';

class AnimeRecommendations extends StatefulWidget {
  AnimeRecommendations(this.id, {this.anime = true});

  final int id;
  final bool anime;

  @override
  _AnimeRecommendationsState createState() => _AnimeRecommendationsState();
}

class _AnimeRecommendationsState extends State<AnimeRecommendations>
    with AutomaticKeepAliveClientMixin<AnimeRecommendations> {
  Future<BuiltList<Recommendation>> _future;

  @override
  void initState() {
    super.initState();
    _future =
        widget.anime ? JikanApi().getAnimeRecommendations(widget.id) : JikanApi().getMangaRecommendations(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Center(child: CircularProgressIndicator());
        }

        BuiltList<Recommendation> recommendationList = snapshot.data;
        if (recommendationList.length == 0) {
          return ListTile(title: Text('No items found.'));
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Center(
            child: Wrap(
              spacing: 16.0,
              runSpacing: 16.0,
              children: recommendationList.map((Recommendation recommendation) {
                return ItemAnime(recommendation.malId, recommendation.title, recommendation.imageUrl,
                    type: widget.anime ? TopType.anime : TopType.manga);
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
