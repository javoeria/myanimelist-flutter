import 'package:flutter/material.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:myanimelist/constants.dart';
import 'package:myanimelist/widgets/title_anime.dart';

class AnimeRecommendations extends StatefulWidget {
  const AnimeRecommendations(this.id, {this.anime = true});

  final int id;
  final bool anime;

  @override
  State<AnimeRecommendations> createState() => _AnimeRecommendationsState();
}

class _AnimeRecommendationsState extends State<AnimeRecommendations>
    with AutomaticKeepAliveClientMixin<AnimeRecommendations> {
  late Future<BuiltList<Recommendation>> _future;

  @override
  void initState() {
    super.initState();
    _future = widget.anime ? jikan.getAnimeRecommendations(widget.id) : jikan.getMangaRecommendations(widget.id);
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

        final BuiltList<Recommendation> recommendationList = snapshot.data!;
        if (recommendationList.isEmpty) {
          return ListTile(title: Text('No items found.'));
        }
        return Scrollbar(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Center(
              child: Wrap(
                spacing: 16.0,
                runSpacing: 16.0,
                children: recommendationList.map((rec) {
                  return TitleAnime(
                    rec.entry.malId,
                    rec.entry.title,
                    rec.entry.imageUrl,
                    type: widget.anime ? ItemType.anime : ItemType.manga,
                  );
                }).toList(),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
