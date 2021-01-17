import 'package:flutter/material.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:intl/intl.dart' show NumberFormat, DateFormat;
import 'package:built_collection/built_collection.dart' show BuiltList;
import 'package:myanimelist/jikan_v4.dart';
import 'package:myanimelist/models/user_data.dart';
import 'package:myanimelist/screens/manga_screen.dart';
import 'package:myanimelist/widgets/season/genre_horizontal.dart';
import 'package:provider/provider.dart';

class GenreMangaScreen extends StatefulWidget {
  GenreMangaScreen({this.showCount});

  final bool showCount;

  @override
  _GenreMangaScreenState createState() => _GenreMangaScreenState();
}

class _GenreMangaScreenState extends State<GenreMangaScreen> {
  List<dynamic> items = GenreList.manga.where((genre) => genre['name'] != 'Hentai').toList();
  bool loading = false;

  @override
  void initState() {
    super.initState();
    loading = widget.showCount;
    if (loading) load();
  }

  void load() async {
    items = await JikanV4().getGenreList(anime: false);
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Scaffold(appBar: AppBar(title: Text('Genres Manga')), body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Genres Manga'),
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
                    builder: (context) => GenreMangaList(item['mal_id'], item['name']),
                    settings: RouteSettings(name: '${item['name']}MangaScreen'),
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
  GenreMangaList(this.id, this.genre);

  final int id;
  final String genre;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$genre Manga'),
      ),
      body: FutureBuilder(
        future: Jikan().getGenre(id, GenreType.manga),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Center(child: CircularProgressIndicator());
          }

          Genre genre = snapshot.data;
          BuiltList<MangaItem> mangaList = genre.manga;
          bool kids = Provider.of<UserData>(context).kidsGenre;
          bool r18 = Provider.of<UserData>(context).r18Genre;
          mangaList = BuiltList.from(mangaList.where((manga) => !manga.genres.map((i) => i.name).contains('Hentai')));
          if (!kids) {
            mangaList = BuiltList.from(mangaList.where((manga) => !manga.genres.map((i) => i.name).contains('Kids')));
          }
          if (!r18) {
            mangaList = BuiltList.from(mangaList.where((manga) =>
                !manga.genres.map((i) => i.name).contains('Yaoi') &&
                !manga.genres.map((i) => i.name).contains('Yuri')));
          }

          if (mangaList.isEmpty) {
            return ListTile(title: Text('No items found.'));
          }
          return Scrollbar(
            child: ListView.separated(
              separatorBuilder: (context, index) => Divider(height: 0.0),
              itemCount: mangaList.length,
              itemBuilder: (context, index) {
                MangaItem manga = mangaList.elementAt(index);
                return MangaInfo(manga);
              },
            ),
          );
        },
      ),
    );
  }
}

class MangaInfo extends StatelessWidget {
  MangaInfo(this.manga);

  final MangaItem manga;
  final NumberFormat f = NumberFormat.decimalPattern();
  final DateFormat dateFormat = DateFormat('MMM d, yyyy');

  String get _authorsText {
    return manga.authors.isEmpty ? '-' : manga.authors.first.name;
  }

  String get _publishingText {
    if (manga.publishingStart == null) {
      return '??';
    } else {
      DateTime japanTime = DateTime.parse(manga.publishingStart).add(Duration(hours: 9));
      return dateFormat.format(japanTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    String volumes = manga.volumes == null ? '?' : manga.volumes.toString();
    String score = manga.score == null ? 'N/A' : manga.score.toString();
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MangaScreen(manga.malId, manga.title),
            settings: RouteSettings(name: 'MangaScreen'),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Column(
          children: <Widget>[
            Text(manga.title, style: Theme.of(context).textTheme.headline6),
            SizedBox(height: 4.0),
            Text('$_authorsText | $volumes vols | ${manga.type}'),
            SizedBox(height: 4.0),
            GenreHorizontal(manga.genres, padding: 0.0),
            SizedBox(height: 4.0),
            Container(
              height: 242.0,
              child: Row(
                children: <Widget>[
                  Image.network(manga.imageUrl, width: 167.0, height: 242.0, fit: BoxFit.cover),
                  SizedBox(width: 8.0),
                  Expanded(
                    child: Container(
                      alignment: Alignment.topLeft,
                      child: SingleChildScrollView(
                        child: Text(manga.synopsis, style: Theme.of(context).textTheme.caption),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 4.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(_publishingText),
                Row(
                  children: <Widget>[
                    Icon(Icons.star_border, color: Colors.grey, size: 20.0),
                    Text(score),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Icon(Icons.person_outline, color: Colors.grey, size: 20.0),
                    Text(f.format(manga.members)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
