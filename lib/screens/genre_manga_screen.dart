import 'package:flutter/material.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:myanimelist/constants.dart';
import 'package:myanimelist/widgets/manga/manga_list.dart';

class GenreMangaScreen extends StatefulWidget {
  const GenreMangaScreen({required this.showCount});

  final bool showCount;

  @override
  State<GenreMangaScreen> createState() => _GenreMangaScreenState();
}

class _GenreMangaScreenState extends State<GenreMangaScreen> {
  BuiltList<Genre> genres = BuiltList(GenreList.manga.where((i) => i.name != 'Hentai'));
  bool loading = false;

  @override
  void initState() {
    super.initState();
    loading = widget.showCount;
    if (loading) load();
  }

  void load() async {
    genres = await jikan.getMangaGenres();
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Scaffold(appBar: AppBar(title: Text('Manga Genres')), body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Manga Genres')),
      body: Scrollbar(
        child: ListView.separated(
          separatorBuilder: (context, index) => const Divider(height: 0.0),
          itemCount: genres.length,
          itemBuilder: (context, index) {
            Genre genre = genres.elementAt(index);
            return ListTile(
              title: Text(genre.name),
              trailing: genre.count != null ? Chip(label: Text(genre.count!.decimal())) : null,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GenreMangaList(genre.malId, genre.name),
                    settings: RouteSettings(name: '${genre.name}MangaScreen'),
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

class GenreMangaList extends StatelessWidget {
  const GenreMangaList(this.id, this.name);

  final int id;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('$name Manga')),
      body: FutureBuilder(
        future: jikan.searchManga(genres: [id], orderBy: 'members', sort: 'desc'),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          return MangaList(snapshot.data!);
        },
      ),
    );
  }
}
