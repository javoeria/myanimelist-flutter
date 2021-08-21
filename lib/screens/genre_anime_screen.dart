import 'package:flutter/material.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:myanimelist/jikan_v4.dart';
import 'package:myanimelist/widgets/season/season_list.dart';

class GenreAnimeScreen extends StatefulWidget {
  const GenreAnimeScreen({required this.showCount});

  final bool showCount;

  @override
  _GenreAnimeScreenState createState() => _GenreAnimeScreenState();
}

class _GenreAnimeScreenState extends State<GenreAnimeScreen> {
  List<dynamic> items = GenreList.anime.where((genre) => genre['name'] != 'Hentai').toList();
  bool loading = false;

  @override
  void initState() {
    super.initState();
    loading = widget.showCount;
    if (loading) load();
  }

  void load() async {
    items = await JikanV4().getGenreList();
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
            Map<String, dynamic> item = items.elementAt(index);
            return ListTile(
              title: Text(item['name']),
              trailing: item['count'] != null ? Chip(label: Text(item['count'].toString())) : null,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GenreAnimeList(item['mal_id'], item['name']),
                    settings: RouteSettings(name: '${item['name']}AnimeScreen'),
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
        future: Jikan().getGenre(id, GenreType.anime),
        builder: (context, AsyncSnapshot<Genre> snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Center(child: CircularProgressIndicator());
          }

          Genre genre = snapshot.data!;
          return SeasonList(genre.anime!);
        },
      ),
    );
  }
}
