import 'package:flutter/material.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:myanimelist/constants.dart';
import 'package:myanimelist/widgets/season/season_list.dart';

class GenreAnimeScreen extends StatefulWidget {
  const GenreAnimeScreen({required this.showCount});

  final bool showCount;

  @override
  _GenreAnimeScreenState createState() => _GenreAnimeScreenState();
}

class _GenreAnimeScreenState extends State<GenreAnimeScreen> {
  BuiltList<Genre> genres = BuiltList(GenreList.anime.where((i) => i.name != 'Hentai'));
  bool loading = false;

  @override
  void initState() {
    super.initState();
    loading = widget.showCount;
    if (loading) load();
  }

  void load() async {
    genres = await jikan.getAnimeGenres();
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Scaffold(appBar: AppBar(title: Text('Anime Genres')), body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: Text('Anime Genres')),
      body: Scrollbar(
        child: ListView.separated(
          separatorBuilder: (context, index) => const Divider(height: 0.0),
          itemCount: genres.length,
          itemBuilder: (context, index) {
            Genre genre = genres.elementAt(index);
            return ListTile(
              title: Text(genre.name),
              trailing: genre.count != null ? Chip(label: Text(genre.count.toString())) : null,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GenreAnimeList(genre.malId, genre.name),
                    settings: RouteSettings(name: '${genre.name}AnimeScreen'),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class GenreAnimeList extends StatelessWidget {
  const GenreAnimeList(this.id, this.name);

  final int id;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('$name Anime')),
      body: FutureBuilder(
        future: jikan.searchAnime(genres: [id], orderBy: 'members', sort: 'desc'),
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
