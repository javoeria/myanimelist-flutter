import 'package:flutter/material.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:myanimelist/widgets/season/season_list.dart';

class GenreAnimeScreen extends StatefulWidget {
  const GenreAnimeScreen({required this.showCount});

  final bool showCount;

  @override
  _GenreAnimeScreenState createState() => _GenreAnimeScreenState();
}

class _GenreAnimeScreenState extends State<GenreAnimeScreen> {
  BuiltList<Genre> items = BuiltList(GenreList.anime.where((genre) => genre.name != 'Hentai'));
  bool loading = false;

  @override
  void initState() {
    super.initState();
    loading = widget.showCount;
    if (loading) load();
  }

  void load() async {
    items = await Jikan().getAnimeGenres();
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Scaffold(appBar: AppBar(title: Text('Anime Genres')), body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Anime Genres'),
      ),
      body: Scrollbar(
        child: ListView.separated(
          separatorBuilder: (context, index) => Divider(height: 0.0),
          itemCount: items.length,
          itemBuilder: (context, index) {
            Genre item = items.elementAt(index);
            return ListTile(
              title: Text(item.name),
              trailing: item.count != null ? Chip(label: Text(item.count.toString())) : null,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GenreAnimeList(item.malId, item.name),
                    settings: RouteSettings(name: '${item.name}AnimeScreen'),
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
  const GenreAnimeList(this.id, this.genre);

  final int id;
  final String genre;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$genre Anime'),
      ),
      body: FutureBuilder(
        future: Jikan().searchAnime(genres: [id], orderBy: 'members', sort: 'desc'),
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
