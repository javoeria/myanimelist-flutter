import 'package:flutter/material.dart';
import 'package:jikan_api/jikan_api.dart';
import 'package:intl/intl.dart' show NumberFormat, DateFormat;
import 'package:built_collection/built_collection.dart' show BuiltList;
import 'package:myanimelist/models/user_data.dart';
import 'package:myanimelist/screens/manga_screen.dart';
import 'package:myanimelist/widgets/season/genre_horizontal.dart';
import 'package:provider/provider.dart';

class GenreMangaScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Map<String, int> items = {
      'Action': 1,
      'Adventure': 2,
      'Cars': 3,
      'Comedy': 4,
      'Dementia': 5,
      'Demons': 6,
      'Doujinshi': 43,
      'Drama': 8,
      'Ecchi': 9,
      'Fantasy': 10,
      'Game': 11,
      'Gender Bender': 44,
      'Harem': 35,
//    'Hentai': 12,
      'Historical': 13,
      'Horror': 14,
      'Josei': 42,
      'Kids': 15,
      'Magic': 16,
      'Martial Arts': 17,
      'Mecha': 18,
      'Military': 38,
      'Music': 19,
      'Mystery': 7,
      'Parody': 20,
      'Police': 39,
      'Psychological': 40,
      'Romance': 22,
      'Samurai': 21,
      'School': 23,
      'Sci-Fi': 24,
      'Seinen': 41,
      'Shoujo': 25,
      'Shoujo Ai': 26,
      'Shounen': 27,
      'Shounen Ai': 28,
      'Slice of Life': 36,
      'Space': 29,
      'Sports': 30,
      'Super Power': 31,
      'Supernatural': 37,
      'Thriller': 45,
      'Vampire': 32,
      'Yaoi': 33,
      'Yuri': 34,
    };

    List<String> keys = items.keys.toList();
    List<int> values = items.values.toList();
    return Scaffold(
      appBar: AppBar(
        title: Text('Genres Manga'),
      ),
      body: Scrollbar(
        child: ListView.separated(
          separatorBuilder: (context, index) => Divider(height: 0.0),
          itemCount: items.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(keys.elementAt(index)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GenreMangaList(values[index], keys[index]),
                    settings: RouteSettings(name: '${keys[index]}MangaScreen'),
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
