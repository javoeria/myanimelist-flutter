import 'package:flutter/material.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:myanimelist/widgets/manga/manga_list.dart';

class GenreMangaScreen extends StatefulWidget {
  const GenreMangaScreen({required this.showCount});

  final bool showCount;

  @override
  _GenreMangaScreenState createState() => _GenreMangaScreenState();
}

class _GenreMangaScreenState extends State<GenreMangaScreen> {
  BuiltList<Genre> items = BuiltList(GenreList.manga.where((genre) => genre.name != 'Hentai'));
  bool loading = false;

  @override
  void initState() {
    super.initState();
    loading = widget.showCount;
    if (loading) load();
  }

  void load() async {
    items = await Jikan().getMangaGenres();
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Scaffold(appBar: AppBar(title: Text('Manga Genres')), body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Manga Genres'),
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
                    builder: (context) => GenreMangaList(item.malId, item.name),
                    settings: RouteSettings(name: '${item.name}MangaScreen'),
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
  const GenreMangaList(this.id, this.genre);

  final int id;
  final String genre;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$genre Manga'),
      ),
      body: FutureBuilder(
        future: Jikan().searchManga(genres: [id], orderBy: 'members', sort: 'desc'),
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
